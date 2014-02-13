//
//  HelpPageViewController.m
//  FaceTracker
//
//  Created by Lsr on 13-8-26.
//
//

#import "HelpPageViewController.h"
#import "HelpPage2ViewController.h"
#import "HomepageViewController.h"

@interface HelpPageViewController ()

@end

@implementation HelpPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)goToNextPage {
    
    HelpPage2ViewController *helpPage2ViewController = [[HelpPage2ViewController alloc]init];
    
    helpPage2ViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:helpPage2ViewController animated:YES completion:nil];
    
    
}
- (IBAction)goToNext:(id)sender {
    [self goToNextPage];
}

- (IBAction)backHome:(id)sender {
    HomepageViewController *homepageViewController = [[HomepageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homepageViewController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer* recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextPage)];
    
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
    [recognizerLeft release];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
