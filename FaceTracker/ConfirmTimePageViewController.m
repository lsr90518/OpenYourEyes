//
//  ConfirmTimePageViewController.m
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import "ConfirmTimePageViewController.h"
#import "HomepageViewController.h"
#import "AppDelegate.h"

@interface ConfirmTimePageViewController ()
@property (strong, nonatomic) IBOutlet UITextField *confirmTime;

@end

@implementation ConfirmTimePageViewController

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
    self.confirmTime.text = delegate.confirm_time;
    
}
- (IBAction)SetFinish:(id)sender {
    
    //set confirm time
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    delegate.confirm_time = self.confirmTime.text;
    //
    
    HomepageViewController *homepageViewController=[[HomepageViewController alloc]init];
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:homepageViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
