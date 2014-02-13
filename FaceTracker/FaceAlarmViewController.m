    //
//  FaceAlarmViewController.m
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import "FaceAlarmViewController.h"
#import "SharePageViewController.h"

@interface FaceAlarmViewController ()

@end

@implementation FaceAlarmViewController

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
}
- (IBAction)AlarmFinish:(id)sender {
    
    SharePageViewController *sharePageViewController = [[SharePageViewController alloc]init];
    
    sharePageViewController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:sharePageViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
