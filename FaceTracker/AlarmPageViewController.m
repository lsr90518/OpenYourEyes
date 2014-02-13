//
//  AlarmPageViewController.m
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import "AlarmPageViewController.h"
#import "FaceAlarmViewController.h"
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>


@interface AlarmPageViewController ()
@property (strong, nonatomic) IBOutlet UILabel *wake_timeS;
@property (strong, nonatomic) IBOutlet UILabel *current_time;
@property (retain, nonatomic) UIImageView *Switch;
@property (retain, nonatomic) NSString *rope_range;
@property (retain,nonatomic) NSString *tweet;
@property (retain,nonatomic) UIImage *image;
@property (retain,nonatomic)AppDelegate *delegate;


@end

@implementation AlarmPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"alarm1=%@",self.delegate.song_name);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH"];
    //get wake_time
    
    self.wake_timeS.text = self.delegate.wake_time_text;
    //get current time
    NSDate *current_timeT = [NSDate date];
    NSString* current_hour = [formatter stringFromDate:current_timeT];
    int int_current_hour = [current_hour intValue];
    
    [formatter setDateFormat:@"mm"];
    NSString *current_min = [formatter stringFromDate:current_timeT];
    int int_current_min = [current_min intValue];
    
    [formatter setDateFormat:@"ss"];
    NSString *current_sec = [formatter stringFromDate:current_timeT];
    int int_current_sec =[current_sec intValue];
    
    //set time transform
    int int_hour = [self.delegate.wake_hour intValue];
    int int_min = [self.delegate.wake_min intValue];
    
    int wake_seconds_hour = int_hour * 3600;
    int wake_seconds_min = int_min * 60;
    int wake_seconds = wake_seconds_hour + wake_seconds_min;
    
    //current time transform
    int current_seconds_hour = int_current_hour * 3600;
    int current_seconds_min = int_current_min * 60;
    int current_seconds = current_seconds_hour + current_seconds_min;
    current_seconds = current_seconds + int_current_sec;
    
    
    //interval calculate
    int interval = wake_seconds - current_seconds;
    NSLog(@"%d",interval);
    //明日
    if(interval < 0.0){
        interval = 86400.0 + interval;
    } 
    
    self.delegate.send_time = [NSString stringWithFormat:@"%d",interval];
    
    //start local notification
    
    NSString *song_nameT = [self.delegate.song_name stringByAppendingString:@".mp3"];
    NSLog(@"song_nameT==============%@",song_nameT);
    
    notify = [[UILocalNotification alloc] init];
//    notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    notify.soundName = song_nameT;
    notify.applicationIconBadgeNumber = 1;
    notify.alertBody = @"時間だ";
    notify.alertAction =@"Open Your Eyes!";
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //一回マナーする
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    
    //[NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(sendTwitter) userInfo:nil repeats:NO];
    
    
    //スイッチ設置する
    self.Switch = [[UIImageView alloc]initWithFrame:CGRectMake(280, -50, 12, 100.0)];
    UIImage *switchT = [UIImage imageNamed:@"switch.png"];
    [self.Switch setImage:switchT];
    [self.view addSubview:self.Switch];
    
    //[self sendTime];
    
//    delegate.thread = [[NSThread alloc]initWithTarget:self selector:@selector(startTheBackgroundJob) object:nil];
//    [delegate.thread start];
    
//    [self performSelectorOnMainThread:@selector(startTheBackgroundJob) withObject:nil waitUntilDone:YES];
    
}


- (void)sendTime{
    NSString * urlStr = [NSString stringWithFormat:@"http://172.17.252.186:8080/_OyE/SaveUser"];
//    NSString * urlStr = [NSString stringWithFormat:@"http://localhost:8080/_OyE/SaveUser"];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSString *body = [NSString stringWithFormat:@"time=%@&twitterColock=%@&confirm_time=%@&song_name=%@&twitterText=%@",self.delegate.send_time,self.delegate.twitterSwitch,self.delegate.confirm_time,self.delegate.song_name,self.delegate.twitterText];

//    NSString *body = [NSString stringWithFormat:@"time=%d",sendTime];
    NSLog(@"%@",body);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"post"];
    [request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)cancel {
    [[UIApplication sharedApplication] cancelLocalNotification:notify];
    self.delegate = [[UIApplication sharedApplication]delegate];
    self.delegate.twitterSwitch=@"off";
    
    HomepageViewController *homepageViewController = [[HomepageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    
    //地域分別
    if(pt.x > 250 && pt.y<110 && [self.rope_range isEqual:@"1"]){
        self.rope_range = @"1";
        [self dragRope:pt.x :pt.y];
    } else {
        self.rope_range = @"0";
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    //    printf("point = %lf,%lf\n", pt.x, pt.y);
    
    if(pt.x > 250 && pt.y<110){
        self.rope_range = @"1";
        [self dragRope:pt.x :pt.y];
    } else {
        self.rope_range = @"0";
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self ropeAnimation];
    
}

-(void) alarmBegin{
    
    [self ropeAnimation];
    
    
    AlarmPageViewController *alarmPageViewController = [[AlarmPageViewController alloc] init];
    
    alarmPageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:alarmPageViewController animated:YES];
}


-(void) dragRope:(float)ropex :(float)ropey {
    
    if(ropey < 70){
        
        [self.Switch removeFromSuperview];
        
        self.Switch = [[UIImageView alloc]initWithFrame:CGRectMake(280, ropey-70, 12, 100.0)];
        UIImage *switchT = [UIImage imageNamed:@"switch.png"];
        [self.Switch setImage:switchT];
        [self.view addSubview:self.Switch];
    } else if(ropey >= 70){
        [self cancel];
        
    }
}

-(void) ropeAnimation {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [self.Switch setFrame:CGRectMake(280, -50, 12.0, 100.0)];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
