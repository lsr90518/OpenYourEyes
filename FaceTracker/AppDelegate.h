//
//  AppDelegate.h
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HomepageViewController.h"
#import "FaceAlarmViewController.h"

@class VideoCaptureViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *wake_time;
    HomepageViewController *homepageViewController;
    FaceAlarmViewController *faceAlarmViewController;
    
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) NSString *wake_time_text;

@property (retain, nonatomic) NSDate *wake_time;

@property (retain, nonatomic) NSString *wake_hour;

@property (retain, nonatomic) NSString *wake_min;


@property (retain, nonatomic) NSString *confirm_time;

@property (retain, nonatomic) NSString *path;

@property (retain, nonatomic) NSString *song_name;

@property (retain, nonatomic) NSString *alarm_status;

@property (retain, nonatomic) AVAudioPlayer *player;

@property (retain, nonatomic) NSString *open;

@property (retain,nonatomic) NSThread *thread;

@property (retain, nonatomic) NSTimer *check_timer;

@property (nonatomic, retain) VideoCaptureViewController *viewController;

@property (retain,nonatomic) NSString *twitterSwitch;

@property (retain,nonatomic) NSString *twitterText;

@property (retain,nonatomic) NSString *send_time;

- (NSString *) getCurrentTime;

@end
