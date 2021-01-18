const puppeteer = require('puppeteer');
const Xvfb      = require('xvfb');
const fs = require('fs');
const os = require('os');
const homedir = os.homedir();
const platform = os.platform();
const { copyToPath, copyFromPath, S3BucketName, uploadMP4ToS3, playBackType, playBackVersion, bbbDomain } = require('./env');
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

	var meetingIdRegex = new RegExp('[a-z0-9]{40}-[0-9]{13}');
	if(!meetingIdRegex.test(meetingId)) {
		console.warn('Invalid meeting Id');
		process.exit(1);
	}
	
	var url;	   

	if(playBackVersion == "20") {
		url = "https://" + bbbDomain + "/playback/presentation/2.0/playback.html?meetingId=" + meetingId;
	} else  {
		url = "https://" + bbbDomain + "/playback/presentation/2.3/" + meetingId;
		
		if(playBackType == "media") {
			url += "?l=media";
		} else if(playBackType == "content") {
			url += "?l=content";
		}
	}
	
	console.log("Fetching: " + url);

	//Chrome downloads video in webm format. So first download in webm format and then convert into MP4 using ffmpeg
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

    //Set the download location of webm recordings. This is useful when you execute this script as background to record multiple recordings using parallel
	await page._client.send('Page.setDownloadBehavior', {behavior: 'allow', downloadPath: copyFromPath + meetingId})

    // Catch URL unreachable error
    await page.goto(url, {waitUntil: 'networkidle2'}).catch(e => {
        console.error('Recording URL unreachable!');
        process.exit(2);
    })
    await page.setBypassCSP(true)

    // Check if recording exists (search "Recording not found" message)
    /*var loadMsg = await page.evaluate(() => {
        return document.getElementById("load-msg").textContent;
    });
    if(loadMsg == "Recording not found"){
        console.warn("Recording not found!");
        process.exit(1);
    }

    // Get recording duration
    var recDuration = await page.evaluate(() => {
        return document.getElementById("video").duration;
    });
    // If duration was set to 0 or is greater than recDuration, use recDuration value
    if(duration == 0 || duration > recDuration){
        duration = recDuration;
    }*/

    var duration = await page.evaluate(() => {
        //check for video tag in url_playback_1
	if(document.getElementById("vjs_video_3_html5_api") === null) {
	    return 0;
	}
	return document.getElementById("vjs_video_3_html5_api").duration;
    });

    if(duration == 0) {
        console.error('Video is not available');
        process.exit(2);
    }

    console.log("Video Duration: " + duration);

    /*await page.waitForSelector('button[class=acorn-play-button]');
    await page.$eval('#navbar', element => element.style.display = "none");
    await page.$eval('#copyright', element => element.style.display = "none");
    await page.$eval('.acorn-controls', element => element.style.opacity = "0");
    await page.click('button[class=acorn-play-button]', {waitUntil: 'domcontentloaded'});
    */

    await page.waitForSelector('button[class=vjs-big-play-button]');	
    await page.$eval('.top-bar', element => element.style.display = "none");
    await page.$eval('.bottom-content', element => element.style.display = "none");
    await page.$eval('.fullscreen-button', element => element.style.display = "none");
    await page.$eval('.vjs-control-bar', element => element.style.opacity = "0");	
    await page.click('button[class=vjs-big-play-button]', {waitUntil: 'domcontentloaded'});

    await page.evaluate((x) => {
        console.log("REC_START");
        window.postMessage({type: 'REC_START'}, '*')
    })

    // Perform any actions that have to be captured in the exported video
    await page.waitFor((duration * 1000))

    await page.evaluate(filename=>{
        window.postMessage({type: 'SET_EXPORT_PATH', filename: filename}, '*')
        window.postMessage({type: 'REC_STOP'}, '*')
    }, exportname)


    // Wait for download of webm to complete
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
            '-c:v libx264',
            '-preset veryfast',
            '-movflags faststart',
            '-profile:v high',
            '-level 4.2',
            '-max_muxing_queue_size 9999',
            '-vf mpdecimate',
            '-vsync vfr "' + copyTo + '"'
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
