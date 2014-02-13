//
//  RingTonePageViewController.m
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import "RingTonePageViewController.h"
#import "HomepageViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TwitterPageViewController.h"

@interface RingTonePageViewController ()
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIImageView *back;
@property (retain,nonatomic) NSString *song_flag;
@property (retain, nonatomic) IBOutlet UIImageView *upArrow;
@property (retain, nonatomic) IBOutlet UIImageView *rightArrow;
@property (retain, nonatomic) IBOutlet UIImageView *confirm_icon;
@property (retain, nonatomic) IBOutlet UIImageView *music_icon;

@end

@implementation RingTonePageViewController

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
    //保存した確認時間を表示する
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //保存した秒数から位置情報まで転換
    int position_y = [self secondsToPosition:[delegate.confirm_time intValue]];
    
    [self moveLabel:CGRectMake(5, position_y, 100, 30)];
    
    int position_x = [delegate.song_name intValue];
    position_x = position_x*55;
    position_y = 100;
    [self changeBackColor:position_x :position_y];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //動画開始
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:2.0];
    NSLog(@"ring1=%@",delegate.song_name);

    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)SetFinish:(id)sender {
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    
    [player stop];
    
    HomepageViewController *homepageViewController=[[HomepageViewController alloc]init];
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
}


- (void) playMusic:(NSString*)song_path{
    if(player){
        [player stop];
    }

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    delegate.path=[[NSBundle mainBundle] pathForResource:song_path ofType:@"mp3"];
    
    delegate.song_name = song_path;
    
    
    if (delegate.path) {
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:delegate.path]error:nil];
        [player prepareToPlay];
        
        player.numberOfLoops = 3;
        
        player.volume = 1.0f;
        [player play];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    NSLog(@"%f,%f",pt.x,pt.y);
    if(pt.y<409 && pt.y>50){
    
        [self.label removeFromSuperview];
    
        CGRect rect = CGRectMake(100, 200, 200, 30);
        rect.origin.x = 5;
        rect.origin.y = pt.y;
        [self moveLabel:rect];
        
        [self changeBackColor:pt.x
                             :pt.y];
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.upArrow.alpha = 0.0;
    self.rightArrow.alpha = 0.0;
    self.music_icon.alpha = 0.0;
    self.confirm_icon.alpha = 0.0;
    [UIView commitAnimations];
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    //    printf("point = %lf,%lf\n", pt.x, pt.y);
    NSLog(@"%f,%f",pt.x,pt.y);
    if(pt.y<409 && pt.y>50){
    
        [self.label removeFromSuperview];
    
        CGRect rect = CGRectMake(100, 200, 200, 30);
        rect.origin.x = 5;
        rect.origin.y = pt.y;
        [self moveLabel:rect];
        
        [self changeBackColor:pt.x
                             :pt.y];
        
    }
}

-(void)changeBackColor:(int)intx :(int)inty{
    
    if(intx >11 && intx<286 && inty>0 && inty<409){
        int song_x = intx - 11;
        song_x = song_x/55;
        if(intx > 11 && intx <= 66){
            UIImage *uiimg = [UIImage imageNamed:@"setting_1.png"];
            [self.back setImage:uiimg];
            if(![self.song_flag isEqual:@"1"]){
                self.song_flag = @"1";
                [self playMusic:@"1"];
            }
            
        } else if(intx > 66 && intx <= 121){
            UIImage *uiimg = [UIImage imageNamed:@"setting_2.png"];
            [self.back setImage:uiimg];
            
            if(![self.song_flag isEqual:@"2"]){
                self.song_flag = @"2";
                [self playMusic:@"2"];
            }
            
        } else if(intx > 121 && intx <= 176){
            UIImage *uiimg = [UIImage imageNamed:@"setting_3.png"];
            [self.back setImage:uiimg];
            
            if(![self.song_flag isEqual:@"3"]){
                self.song_flag = @"3";
                
                [self playMusic:@"3"];
            }
        } else if(intx > 176 && intx <= 231){
            UIImage *uiimg = [UIImage imageNamed:@"setting_4.png"];
            [self.back setImage:uiimg];
            
            if(![self.song_flag isEqual:@"4"]){
                self.song_flag = @"4";
                [self playMusic:@"4"];
            }
        } else if(intx > 231 && intx <= 286){
            UIImage *uiimg = [UIImage imageNamed:@"setting_5.png"];
            [self.back setImage:uiimg];
            if(![self.song_flag isEqual:@"5"]){
                self.song_flag = @"5";
                [self playMusic:@"5"];
            }
        }
    }
}

- (void) moveLabel : (CGRect)rect{
    self.label = [[UILabel alloc] initWithFrame:rect];
    
    int intx = (int)rect.origin.x;
    int inty = (int)rect.origin.y;
    
    inty = inty/12;
    //
    inty = 36-inty;
    if(inty == 0){
        inty = 1;
    }
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    delegate.confirm_time = [NSString stringWithFormat:@"%d",inty];
    
    
    self.label.text = [NSString stringWithFormat:@"%d",inty];
    
    // text bold
    self.label.font = [UIFont boldSystemFontOfSize:20];
    // text color
    self.label.textColor = [UIColor whiteColor];
    // background color
    self.label.backgroundColor = [UIColor clearColor];
    // return
    self.label.numberOfLines = 2;
    // hight
    self.label.highlighted = YES;
    self.label.highlightedTextColor = [UIColor whiteColor];
    //shadow setting
    //    self.label.shadowColor = [UIColor whiteColor];
    //    self.label.shadowOffset = CGSizeMake(1.0,1.0);
    [self.view addSubview:self.label];
}

- (int) secondsToPosition: (int)seconds{
    seconds = 36 - seconds;
    seconds = seconds * 12;
    return seconds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moveToTwitter:(id)sender {
    
    AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    
    NSLog(@"ring2=%@",delegate.song_name);

    [player stop];
    TwitterPageViewController *t = [[TwitterPageViewController alloc]init];
    t.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:t animated:YES completion:nil];
}

- (void)dealloc {
    [_label release];
    [_back release];
    [_upArrow release];
    [_rightArrow release];
    [_confirm_icon release];
    [_music_icon release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLabel:nil];
    [self setBack:nil];
    [self setCoverView:nil];
    [self setUpArrow:nil];
    [self setRightArrow:nil];
    [self setConfirm_icon:nil];
    [self setMusic_icon:nil];
    [super viewDidUnload];
}
@end
