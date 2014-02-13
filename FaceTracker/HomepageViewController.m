//
//  HomepageViewController.m
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import "HomepageViewController.h"
#import "RingTonePageViewController.h"
#import "AlarmPageViewController.h"
#import "ConfirmTimePageViewController.h"
#import "AppDelegate.h"
#import "HelpPageViewController.h"

@interface HomepageViewController ()

@property (strong, nonatomic) IBOutlet UILabel *confirm_time;
@property (strong, nonatomic) IBOutlet UILabel *song_name;
@property (retain, nonatomic) IBOutlet UIImageView *back;
@property (strong, nonatomic) UILabel *label;
@property (retain, nonatomic) UIImageView *Switch;
@property (retain, nonatomic) NSString *rope_range;
@property (retain, nonatomic) UILabel *please;
@property (retain, nonatomic) NSString *time_text;

@end

@implementation HomepageViewController


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
    // Do any additional setup after loading the view from its nib.
    
    self.rope_range = @"0";
 
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    
    NSDate *now_time = [NSDate date];
    NSString *current_hour_str = [formatter stringFromDate:now_time];
    NSString *png = @".png";
    NSString *backgroun_uiimage = [current_hour_str stringByAppendingString:png];
    
    
    //set background
    UIImage *uiimg = [UIImage imageNamed:backgroun_uiimage];
    [self.back setImage:uiimg];
    
    //get ConfirmTime
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    self.confirm_time.text = delegate.confirm_time;
    self.song_name.text = delegate.song_name;
    
    //スイッチ設置する
    self.Switch = [[UIImageView alloc]initWithFrame:CGRectMake(280, -50, 12, 100.0)];
    UIImage *switchT = [UIImage imageNamed:@"switch.png"];
    [self.Switch setImage:switchT];
    [self.view addSubview:self.Switch];
    
    //時間を表示する
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(84, 208, 280, 62)];
    [formatter setDateFormat:@"HH : mm"];
    current_hour_str = [formatter stringFromDate:now_time];
    self.label.text = current_hour_str;
    self.label.font = [UIFont fontWithName:@"Optima-Bold" size:50.0];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 2;
    self.label.highlighted = YES;
    self.label.highlightedTextColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    
}
- (IBAction)AlarmStartAction:(id)sender {
    //get time, get tone get confirmTime.
}


- (IBAction)RingToneAction:(id)sender {
    RingTonePageViewController *ringTonePageViewController = [[RingTonePageViewController alloc]init];
    ringTonePageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:ringTonePageViewController animated:YES];
    
}
- (IBAction)ConfirmTimeAction:(id)sender {
    ConfirmTimePageViewController *confirmTimePageViewController = [[ConfirmTimePageViewController alloc]init];
    confirmTimePageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:confirmTimePageViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    
    //地域分別
    if(pt.x > 250 && pt.y<110 && [self.rope_range isEqual:@"1"]){
        self.rope_range = @"1";
        [self dragRope:pt.x :pt.y];
    } else if(pt.y>430) {
        self.rope_range = @"0";
    
    } else if([self.rope_range isEqual:@"1"]){
        
    } else {
        self.rope_range = @"0";
        [self.label removeFromSuperview];
        
        CGRect rect = CGRectMake(100, 200, 200, 30);
        rect.origin.x = pt.x-35.0;
        rect.origin.y = pt.y-70.0;
        [self moveLabel:rect];
    
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    //    printf("point = %lf,%lf\n", pt.x, pt.y);
    
    if(pt.x > 250 && pt.y<110){
        self.rope_range = @"1";
        [self dragRope:pt.x :pt.y];
        
    }  else if(pt.y>430) {
        self.rope_range = @"0";
    } else if([self.rope_range isEqual:@"1"]){
        
    }  else {
        self.rope_range = @"0";
        [self.label removeFromSuperview];
        
        CGRect rect = CGRectMake(100, 200, 200, 30);
        rect.origin.x = pt.x-35.0;
        rect.origin.y = pt.y-70.0;
        
        [self moveLabel:rect];
        
    }
}

-(void)changeBackColor:(int)intx :(int)inty{
    
    if(intx >10 && intx<190 && inty>0 && inty<360){
        
        int hour = inty/ 15;
        int min = intx - 10;
        min = min/3;
        
        NSString *hour_strT = [NSString stringWithFormat:@"%d",hour];
        NSString *min_strT = [NSString stringWithFormat:@"%d",min];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.wake_hour = hour_strT;
        delegate.wake_min = min_strT;
        
        NSString *hour_zero;
        if(hour < 10){
            hour_zero = @"0";
        } else {
            hour_zero = @"";
        }
        NSString *min_zero;
        
        if(min < 10){
            min_zero = @"0";
        } else {
            min_zero = @"";
        }
        
        NSString *hour_str = [hour_zero stringByAppendingString:hour_strT];
        NSString *min_str = [min_zero stringByAppendingString:min_strT];
        
        
        NSString *png = @".png";
        
        NSString *back_name = [hour_str stringByAppendingString:png];
        
        self.time_text = [NSString stringWithFormat:@"%@ : %@",hour_str,min_str];
        
        delegate.wake_time_text = self.time_text;
//        NSLog(@"hour=%@ : min=%@",hour_str,min_str);
        
        UIImage *uiimg = [UIImage imageNamed:back_name];
        [self.back setImage:uiimg];
    }
}

- (void) moveLabel : (CGRect)rect{
    self.label = [[UILabel alloc] initWithFrame:rect];
    // 文字設置
    
    int intx = (int)rect.origin.x;
    int inty = (int)rect.origin.y;
    
    [self changeBackColor:intx
                         :inty];
    
    NSString *str1 = [NSString stringWithFormat:@"%d", intx];
    NSString *str2 = [NSString stringWithFormat:@"%d", inty];
    NSString *strT = @" : ";
    
    NSString *time_str = [str1 stringByAppendingString:strT];
    time_str = [time_str stringByAppendingString:str2];
    self.label.text = self.time_text;
    self.label.font = [UIFont fontWithName:@"Optima-Bold" size:35.0];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 2;
    self.label.highlighted = YES;
    self.label.highlightedTextColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self ropeAnimation];//ひもの動画。
    
    [self labelBackToCenter];
    [UIView commitAnimations];
    self.rope_range = @"0";
    
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
        
        if ([self checkTime]) {
            [self alarmBegin];
        } else {
//            NSString *error_text = @"please choose a time";
//            
//            self.please.text = error_text;
//            
//            self.please.font = [UIFont fontWithName:@"Optima-Bold" size:20.0];
//            self.please.textColor = [UIColor whiteColor];
//            self.please.backgroundColor = [UIColor clearColor];
//            self.please.numberOfLines = 2;
//            self.please.highlighted = YES;
//            self.please.highlightedTextColor = [UIColor whiteColor];
//            [self.please setFrame:CGRectMake(100, 200, 200, 30)];
//            [self.view addSubview:self.please];
        }
    }
}

-(BOOL) checkTime {
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    if(delegate.wake_min.length == 0 || delegate.wake_hour.length == 0){
        return NO;
    } else {
        return YES;
    }
    
}

-(void) ropeAnimation {
    
    //動画関数を新規
    CGContextRef context = UIGraphicsGetCurrentContext();
    //動画開始
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//動画時間
    
    
}

-(void) labelBackToCenter {
    [self.Switch setFrame:CGRectMake(280, -50, 12.0, 100.0)];
    //    self.label.font = [UIFont boldSystemFontOfSize:50.0];
    self.label.font = [UIFont fontWithName:@"Optima-Bold" size:50.0];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 2;
    self.label.highlighted = YES;
    self.label.highlightedTextColor = [UIColor whiteColor];
    [self.label setFrame:CGRectMake(84, 208, 280, 62)];
}

- (IBAction)helpPageAction:(id)sender {
    
    HelpPageViewController *helpPageViewController = [[HelpPageViewController alloc]init];
    helpPageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:helpPageViewController animated:YES completion:nil];
    
}

- (void)dealloc {
    [_back release];
    [_Switch release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSwitch:nil];
    [super viewDidUnload];
}
@end
