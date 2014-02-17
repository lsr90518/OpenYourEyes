//
//  DemoVideoCaptureViewController.m
//  FaceTracker
//
//  Created by Robin Summerhill on 9/22/11.
//  Copyright 2011 Aptogo Limited. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UIImage+OpenCV.h"
#import "AppDelegate.h"
#import "DemoVideoCaptureViewController.h"
#import "SharePageViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>

// Name of face cascade resource file without xml extension
NSString * const kFaceCascadeFilename = @"haarcascade_frontalface_alt2";
NSString * const kEyesCascadeFilename = @"haarcascade_eye";

// Options for cv::CascadeClassifier::detectMultiScale
const int kHaarOptions =  CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;

@interface DemoVideoCaptureViewController ()
@property (retain, nonatomic) IBOutlet
    UIProgressView *second;

@property (retain,nonatomic) NSString *tweet;
@property (retain,nonatomic) UIImage *image;


- (void)displayFaces:(const std::vector<cv::Rect> &)faces
       forVideoRect:(CGRect)rect 
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation;
@end

@implementation DemoVideoCaptureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.captureGrayscale = YES;
        self.qualityPreset = AVCaptureSessionPreset640x480;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = [[UIApplication sharedApplication]delegate];
    
    sec = 0;
    delegate.open = @"no";
    //self.second.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    // Load the face Haar cascade from resources
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:kFaceCascadeFilename ofType:@"xml"];
    NSString *eyesCascadePath = [[NSBundle mainBundle] pathForResource:kEyesCascadeFilename ofType:@"xml"];
    
    if (!_faceCascade.load([faceCascadePath UTF8String])) {
        NSLog(@"Could not load face cascade: %@", faceCascadePath);
    }
    if (!_eyesCascade.load([eyesCascadePath UTF8String])) {
        NSLog(@"Could not load face cascade: %@", eyesCascadePath);
    }
    
    self.camera = 1;
    
    //play music

    if (![delegate.player isPlaying]){
        if (delegate.path) {
            delegate.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:delegate.path]error:nil];
        
            [delegate.player prepareToPlay];
        
            delegate.player.numberOfLoops = -1;
    
            delegate.player.volume = 1.0f;
            [delegate.player play];
//            AVAudioSession *session = [AVAudioSession sharedInstance];
//            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//            [session setActive:YES error:nil];
        }
    }
    delegate.alarm_status = @"1";
    
    
    sec = [delegate.confirm_time intValue];
    
    
    //[self sendTwitterClock];
    
    time = 1.0/sec;
    
    delegate.thread = [[NSThread alloc]initWithTarget:self selector:@selector(startTheBackgroundJob) object:nil];
    [delegate.thread start];
    
    
    
    //[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
}

- (void)sendTwitterClock{
    NSString * urlStr = [NSString stringWithFormat:@"http://172.17.252.186:8080/_OyE/ChangeTwitterClock"];
//    NSString * urlStr = [NSString stringWithFormat:@"http://localhost:8080/_OyE/ChangeTwitterClock"];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSString *body = [NSString stringWithFormat:@"time=%@&twitterColock=%@",delegate.send_time,delegate.twitterSwitch];
    
    //    NSString *body = [NSString stringWithFormat:@"time=%d",sendTime];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(returnString);
}

- (void)viewDidUnload
{
    NSLog(@"unload");
    [self setSecond:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: VideoCaptureViewController overrides

- (void)processFrame:(cv::Mat &)mat videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)videOrientation
{
    /// Shrink video frame to 320X240
    cv::resize(mat, mat, cv::Size(), 0.5f, 0.5f, CV_INTER_LINEAR);
    rect.size.width /= 2.0f;
    rect.size.height /= 2.0f;
    
    // Rotate video frame by 90deg to portrait by combining a transpose and a flip
    // Note that AVCaptureVideoDataOutput connection does NOT support hardware-accelerated
    // rotation and mirroring via videoOrientation and setVideoMirrored properties so we
    // need to do the rotation in software here.
    cv::transpose(mat, mat);
    CGFloat temp = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = temp;
    
    if (videOrientation == AVCaptureVideoOrientationLandscapeRight)
    {
        // flip around y axis for back camera
        cv::flip(mat, mat, 1);
    }
    else {
        // Front camera output needs to be mirrored to match preview layer so no flip is required here
    }
    
    videOrientation = AVCaptureVideoOrientationPortrait;
    
    // Detect faces
    std::vector<cv::Rect> faces;
    std::vector<cv::Rect> eyes;
    
    
    _faceCascade.detectMultiScale(mat, faces, 1.1, 2, 0 |CV_HAAR_SCALE_IMAGE, cv::Size(1, 1));
    
    // We will usually have only one face in frame
    if (faces.size() >0){
        
        cv::Mat faceROI = mat(faces.front());
        _eyesCascade.detectMultiScale( faceROI, eyes, 1.15, 3.0, 0 , cv::Size(1, 1));
    }
    
    
    // Dispatch updating of face markers to main queue
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self displayFaces:eyes
                      eyes:faces
              forVideoRect:rect
          videoOrientation:videOrientation];
    });
}

// Update face markers given vector of face rectangles
- (void)displayFaces:(const std::vector<cv::Rect> &)faces
                eyes:(const std::vector<cv::Rect> &)eyes
       forVideoRect:(CGRect)rect
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation
{
    NSArray *sublayers = [NSArray arrayWithArray:[self.view.layer sublayers]];
    int sublayersCount = [sublayers count];
    int currentSublayer = 0;
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	// hide all the face layers
	for (CALayer *layer in sublayers) {
        NSString *layerName = [layer name];
		if ([layerName isEqualToString:@"FaceLayer"])
			[layer setHidden:YES];
	}	
    
    // Create transform to convert from vide frame coordinate space to view coordinate space
    CGAffineTransform t = [self affineTransformForVideoFrame:rect orientation:videoOrientation];

    std::vector<cv::Rect> temps;

    
    if (faces.size()>0) {
        delegate.open = @"yes";
    }else{
        delegate.open = @"no";
    }
    
    
    //faces' positions
    for (int j = 0;j < eyes.size();j++){
        
    //eyes' positions
        for (int i = 0; i < faces.size(); i++) {
            
            CGRect faceRect;
            faceRect.origin.x = faces[i].x+eyes[j].x;
            faceRect.origin.y = faces[i].y+eyes[j].y;
            faceRect.size.width = faces[i].width;
            faceRect.size.height = faces[i].height;
    
            faceRect = CGRectApplyAffineTransform(faceRect, t);
        
            CALayer *featureLayer = nil;
        
            while (!featureLayer && (currentSublayer < sublayersCount)) {
                CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
                if ([[currentLayer name] isEqualToString:@"FaceLayer"]) {
                    featureLayer = currentLayer;
                    [currentLayer setHidden:NO];
                }
            }
            
            if (!featureLayer) {
                // Create a new feature marker layer
                featureLayer = [[CALayer alloc] init];
                featureLayer.name = @"FaceLayer";
                featureLayer.borderColor = [[UIColor redColor] CGColor];
                featureLayer.borderWidth = 3.0f;
                [self.view.layer addSublayer:featureLayer];
                [featureLayer release];
            }
        
            featureLayer.frame = faceRect;
        }
    }
    [CATransaction commit];
}

- (void)startTheBackgroundJob {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //    threadで目の開くの検索
    //    [NSThread sleepForTimeInterval:3];
    [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)makeMyProgressBarMoving {
    NSLog(@"open=%@",delegate.open);
    if([delegate.open isEqual:@"yes"]){
    
        
        if(_second.progress < 1.0 &&[delegate.player isPlaying]&&[delegate.alarm_status isEqual:@"1"]){
            //終わってない、音楽をプレイしている、アラームの状態はon、認識続き
            _second.progress = _second.progress + time;
        } else {
            
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [delegate.player stop];
            
            //close all
            
            delegate.open = @"no";
            
            [self AlarmEnd];
//            
//            delegate.alarm_status = @"0";
        }
    } else {
        _second.progress = 0.0;
    }
    
    delegate.check_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
}

- (void) AlarmEnd {
    
    delegate.twitterSwitch = @"off";
    [delegate.check_timer invalidate];
    
    [delegate.thread cancel];
    
    SharePageViewController *sharePageViewController = [[SharePageViewController alloc] init];
    sharePageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:sharePageViewController animated:YES completion:nil];
}



- (void)dealloc {
    [_second release];
    [super dealloc];
}
@end
