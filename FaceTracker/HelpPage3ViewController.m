//
//  HelpPage3ViewController.m
//  FaceTracker
//
//  Created by Lsr on 13-8-26.
//
//

#import "HelpPage3ViewController.h"
#import "HomepageViewController.h"
#import "HelpPage4ViewController.h"
#import "HelpPage2ViewController.h"

@interface HelpPage3ViewController ()

@end

@implementation HelpPage3ViewController

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
    
    UISwipeGestureRecognizer* recognizerRight;
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backHome)];
    
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
    
    
    
    UISwipeGestureRecognizer* recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToNext)];
    
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
    [recognizerLeft release];
    
}

- (void)backHome {
    
    HelpPage2ViewController *homepageViewController = [[HelpPage2ViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
    
}
- (IBAction)backToSecond:(id)sender {
    
    [self backHome];
    
}

- (IBAction)goToFourth:(id)sender {
    HelpPage4ViewController *p4 = [[HelpPage4ViewController alloc]init];
    p4.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:p4 animated:YES completion:nil];
}

-(void)goToNext{
    HelpPage4ViewController *p4 = [[HelpPage4ViewController alloc]init];
    p4.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:p4 animated:YES completion:nil];
}

- (IBAction)goBackHome:(id)sender {
    HomepageViewController *homepageViewController = [[HomepageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
