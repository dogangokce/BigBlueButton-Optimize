const puppeteer = require('puppeteer');
const Xvfb      = require('xvfb');
const fs = require('fs');
const os = require('os');
const homedir = os.homedir();
const platform = os.platform();
const { copyToPath, copyFromPath, playBackURL, S3BucketName, uploadMP4ToS3 } = require('./env');
const spawn = require('child_process').spawn;
//Required to find the latest file (downloaded webm) in a directory
const glob = require('glob');
//Required for S3 upload
const { exec } = require('child_process');

var xvfb        = new Xvfb({
    silent: true,
    timeout: 5000,	
    xvfb_args: ["-screen", "0", "1280x800x24", "-ac", "-nolisten", "tcp", "-dpi", "96", "+extension", "RANDR"]
});
var width       = 1280;
var height      = 720;
var options     = {
  headless: false,
  args: [
    '--enable-usermedia-screen-capturing',
    '--allow-http-screen-capture',
    '--auto-select-desktop-capture-source=bbbrecorder',
    '--load-extension=' + __dirname,
    '--disable-extensions-except=' + __dirname,
    '--disable-infobars',
    '--no-sandbox',
    '--shm-size=1gb',
    '--disable-dev-shm-usage',
    '--start-fullscreen',
    '--app=https://www.google.com/',
    `--window-size=${width},${height}`,
  ],
}

if(platform == "linux"){
    options.executablePath = "/usr/bin/google-chrome";
}else if(platform == "darwin"){
    options.executablePath = "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome";
}

async function main() {
    let browser, page;

    try{
        if(platform == "linux"){
            xvfb.startSync()
        }


	var meetingId = process.argv[2];
	
	var url = playBackURL + meetingId;	   
	
	console.log("Fetching: " + url);

	//Chrome, videoyu webm biçiminde indirir. Bu yüzden önce webm formatında indirin ve ardından ffmpeg kullanarak MP4'e dönüştürün
    var exportname = meetingId + '.webm';

    var duration = 0;

    var convert = true;

    browser = await puppeteer.launch(options);
    const pages = await browser.pages();

    page = pages[0]

    page.on('console', msg => {
        var m = msg.text();
        //console.log('PAGE LOG:', m) // uncomment if you need
    });

    await page._client.send('Emulation.clearDeviceMetricsOverride')

    //Webm kayıtlarının indirme konumunu ayarlayın. Paralel kullanarak birden çok kaydı kaydetmek için bu komut dosyasını arka plan olarak çalıştırdığınızda bu yararlıdır.
	await page._client.send('Page.setDownloadBehavior', {behavior: 'allow', downloadPath: copyFromPath + meetingId})

    // Ulaşılamayan URL hatası
    await page.goto(url, {waitUntil: 'networkidle2'}).catch(e => {
        console.error('Recording URL unreachable!');
        process.exit(2);
    })
    await page.setBypassCSP(true)

    // Kaydın olup olmadığını kontrol edin ("Kayıt bulunamadı" mesajını arayın)
    var loadMsg = await page.evaluate(() => {
        return document.getElementById("load-msg").textContent;
    });
    if(loadMsg == "Recording not found"){
        console.warn("Recording not found!");
        process.exit(1);
    }

    // Kayıt süresini alın
    var recDuration = await page.evaluate(() => {
        return document.getElementById("video").duration;
    });
    // Süre 0 olarak ayarlanmışsa veya yinelemeden büyükse yineleme değerini kullanın
    if(duration == 0 || duration > recDuration){
        duration = recDuration;
    }

    await page.waitForSelector('button[class=acorn-play-button]');
    await page.$eval('#navbar', element => element.style.display = "none");
    await page.$eval('#copyright', element => element.style.display = "none");
    await page.$eval('.acorn-controls', element => element.style.opacity = "0");
    await page.click('button[class=acorn-play-button]', {waitUntil: 'domcontentloaded'});

    await page.evaluate((x) => {
        console.log("REC_START");
        window.postMessage({type: 'REC_START'}, '*')
    })

    // Dışa aktarılan videoda yakalanması gereken tüm işlemleri gerçekleştirin
    await page.waitFor((duration * 1000))

    await page.evaluate(filename=>{
        window.postMessage({type: 'SET_EXPORT_PATH', filename: filename}, '*')
        window.postMessage({type: 'REC_STOP'}, '*')
    }, exportname)


    // Webm'nin indirilmesinin tamamlanmasını bekleyin
    await page.waitForSelector('html.downloadComplete', {timeout: 0})

    convertAndCopy(exportname)

    }catch(err) {
        console.log(err)
        
    } finally {
        page.close && await page.close()
        browser.close && await browser.close()

        xvfb.stopSync()
    }
}

main()

function convertAndCopy(filename){

    console.log("Starting conversion ...");

    var onlyfileName = filename.split(".webm");
    var copyFromPathForRecording = copyFromPath + onlyfileName[0];
    var mp4File = onlyfileName[0] + ".mp4";
    var copyTo = copyToPath + mp4File;    

    var newestFile = glob.sync(copyFromPathForRecording + '/*webm').map(name => ({name, ctime: fs.statSync(name).ctime})).sort((a, b) => b.ctime - a.ctime)[0].name;

    var copyFrom = newestFile;	

    if(!fs.existsSync(copyToPath)){
        fs.mkdirSync(copyToPath);
    }

    console.log(copyTo);
    console.log(copyFrom);

    const ls = spawn('ffmpeg',
        [   '-y',
            '-i "' + copyFrom + '"',
            '-c:v copy',
            '"' + copyTo + '"'
        ],
        {
            shell: true
        }

    );

    /*	
    ls.stdout.on('data', (data) => {
        console.log(`stdout: ${data}`);
    });

    ls.stderr.on('data', (data) => {
        console.error(`stderr: ${data}`);
    });
    */

    ls.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
        if(code == 0) {
            console.log("Convertion done to here: " + copyTo)
            fs.rmdirSync(copyFromPathForRecording, { recursive: true });		
            console.log('successfully deleted ' + copyFromPathForRecording);

	    if(uploadMP4ToS3 == "true") {
                uploadToS3(copyTo);
	    }
        }

    });

}

function uploadToS3(fileName) {
  console.log("Starting S3 upload ...");
  var cmd = 'aws s3 cp ' + fileName + ' s3://' + S3BucketName + ' --acl public-read';
  exec(cmd, (err, stdout, stderr) => {
    if (err) {
      //some err occurred
      console.error(err)
    } else {
      // the *entire* stdout and stderr (buffered)
      console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
    }
  });
}
