//
//  HelpPage4ViewController.m
//  FaceTracker
//
//  Created by Lsr on 13-8-27.
//
//

#import "HelpPage4ViewController.h"
#import "HelpPage3ViewController.h"
#import "HomepageViewController.h"

@interface HelpPage4ViewController ()

@end

@implementation HelpPage4ViewController

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
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
    
    
    
    UISwipeGestureRecognizer* recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backHome)];
    
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
    [recognizerLeft release];
}

- (IBAction)goBackHome:(id)sender {
    HomepageViewController *homepageViewController = [[HomepageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
}

-(void) goBack{
    
    HelpPage3ViewController *p3 = [[HelpPage3ViewController alloc]init];
    
    p3.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:p3 animated:YES completion:nil];
}

-(void) backHome{
    
    HomepageViewController *homepageViewController = [[HomepageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
}

- (IBAction)backToThird:(id)sender {
    HelpPage3ViewController *p3 = [[HelpPage3ViewController alloc]init];
    
    p3.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:p3 animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
