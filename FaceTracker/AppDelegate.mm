//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "HomepageViewController.h"
#import "FaceAlarmViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

#import "DemoVideoCaptureViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    // Override point for customization after application launch.
//    self.viewController = [[[DemoVideoCaptureViewController alloc] initWithNibName:@"DemoVideoCaptureViewController" bundle:nil] autorelease];
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//    return YES;
    application.applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    homepageViewController = [[HomepageViewController alloc]init];
    homepageViewController.title = @"Open Your Eye";
    self.confirm_time=@"5";
    
    self.path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
    
    self.alarm_status = @"0";
    
    self.song_name = @"1";
    
    self.open = @"no";
    //
    
    //twitter text setting
    self.twitterText = @"I'm still sleeping, who can wake me up!! Thank you! #OyE";
    //twitter　スイッチ設定
    self.twitterSwitch = @"off";
    
    
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:self.path]error:nil];
    //[self.window addSubview:homepageViewController.view];
    [self.window setRootViewController:homepageViewController];
    //[self.window addSubview:homepageViewController.view];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];

    self.alarm_status = @"0";
    self.open = @"no";
    [self.thread cancel];
    [self.check_timer invalidate];
    NSLog(@"willResign");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"EB");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    if(![self.player isPlaying]){
        
    } else {
        
        DemoVideoCaptureViewController *demoViewCaptureViewController = [[DemoVideoCaptureViewController alloc]init];
        [self.window setRootViewController:demoViewCaptureViewController];
        [self.window makeKeyAndVisible];
    }
////
////        
////    }
//    self.alarm_status = @"1";
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DemoVideoCaptureViewController *demoVideoCaptureViewController = [[DemoVideoCaptureViewController alloc]init];
    //self.twitterSwitch = @"off";
    [self.window setRootViewController:demoVideoCaptureViewController];
    //[self.viewController presentViewController:demoVideoCaptureViewController animated:NO completion:nil];
    [self.window makeKeyAndVisible];
//    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
//    [noti addObserver:self selector:@selector(dismiss) name:@"back" object:nil];
}

- (NSString *) getCurrentTime{
    NSDate *current_date = [NSDate date];
    
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    
    [f setDateFormat:@"HH : mm"];
    
    NSString *cTime = [f stringFromDate:current_date];
    
    NSString *initailText = [NSString stringWithFormat:@"%@",cTime];
    
    return initailText;
}


@end
