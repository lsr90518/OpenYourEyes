//
//  HelpPage2ViewController.m
//  FaceTracker
//
//  Created by Lsr on 13-8-26.
//
//

#import "HelpPage2ViewController.h"
#import "HelpPage3ViewController.h"
#import "HelpPageViewController.h"

@interface HelpPage2ViewController ()

@end

@implementation HelpPage2ViewController

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
    [recognizerRight release];
    
    UISwipeGestureRecognizer* recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextPage)];
    
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
    [recognizerLeft release];
}

- (void)goToNextPage {
    
    HelpPage3ViewController *helpPage2ViewController = [[HelpPage3ViewController alloc]init];
    
    helpPage2ViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:helpPage2ViewController animated:YES completion:nil];
    
    
}
- (void)backHome {
    
    HelpPageViewController *homepageViewController = [[HelpPageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
    
}
- (IBAction)backHome:(id)sender {
    [self backHome];
}
- (IBAction)goToNext:(id)sender {

    [self goToNextPage];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
