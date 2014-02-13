//
//  TwitterPageViewController.m
//  FaceTracker
//
//  Created by Lsr on 13-8-26.
//
//

#import "TwitterPageViewController.h"
#import "HomepageViewController.h"
#import "RingTonePageViewController.h"
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>

@interface TwitterPageViewController ()
//@property (retain, nonatomic) UITextView *Text;
@property (retain, nonatomic) IBOutlet UITextView *Text;
@property (retain, nonatomic) IBOutlet UIImageView *upArrow;
@property (retain, nonatomic) IBOutlet UIImageView *switchPicture;

@end

@implementation TwitterPageViewController

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
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"%@",delegate.song_name);
    self.Text.text = delegate.twitterText;
    
    if([delegate.twitterSwitch isEqual:@"on"]){
        [self turnToOff];
    }
    
    [self.Text resignFirstResponder];
    
    //off機能手の動きの認識
    UISwipeGestureRecognizer* recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnToOff)];
    
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizerLeft];
    
    //on機能手の動きの認識
    UISwipeGestureRecognizer* recognizerDown;
    recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnToOn)];
    
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizerDown];
    
    [UIView setAnimationDuration:2.0];
    self.upArrow.alpha = 0.0;
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.5];
    
    
    
//    CGRect rect = CGRectMake(10, 20, 200, 100);
//    self.Text = [[UITextView alloc]initWithFrame:rect];
    self.Text.alpha = 1.0;
//    [self.view addSubview:self.Text];
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (IBAction)keyboardCancel:(id)sender {
    [self.Text resignFirstResponder];
    
}

- (void)turnToOff{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self letterToggle:@"off"];
                         
                     }
                     completion:^(BOOL finished){
                         self.Text.alpha = 1.0;
                         self.Text.frame = CGRectMake(20, 20, 280, 132);
                     }];
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    delegate.twitterSwitch = @"off";
}

-(void) turnToOn{
    
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2.0];
    
    if (![self userHasAccessToTwitter]) {
        
        TWTweetComposeViewController *t = [[TWTweetComposeViewController alloc]init];
        [t setInitialText:@"アカウントの設定をしてください。"];
        [self presentViewController:t animated:YES completion:nil];
    } else {
    
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.Text.alpha = 0.0;
                             self.Text.frame = CGRectMake(160, 200, 0, 0);
                         }
                         completion:^(BOOL finished){
                             [self letterToggle:@"on"];
                         }];
        
        
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        delegate.twitterSwitch = @"on";
        delegate.twitterText = self.Text.text;
    }
    
}

- (IBAction)backToHome:(id)sender {
    HomepageViewController *h = [[HomepageViewController alloc]init];
    h.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:h animated:YES completion:nil];
}

- (IBAction)backToRing:(id)sender {
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [self letterToggle:delegate.twitterSwitch];
    
    RingTonePageViewController *r = [[RingTonePageViewController alloc]init];
    r.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:r animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)letterToggle:(NSString *)switchName{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
    switchName = [NSString stringWithFormat:@"%@.png",switchName];
    UIImage *uiimg = [UIImage imageNamed:switchName];
    [self.switchPicture setImage:uiimg];
//    [UIView commitAnimations];
}

- (void)dealloc {
    [_Text release];
    [_upArrow release];
    [_switchPicture release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setText:nil];
    [self setUpArrow:nil];
    [self setSwitchPicture:nil];
    [super viewDidUnload];
}
@end
