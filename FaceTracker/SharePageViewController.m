//
//  SharePageViewController.m
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import "SharePageViewController.h"
#import "HomepageViewController.h"
#import <Twitter/TWTweetComposeViewController.h>
#import <Twitter/Twitter.h>

#import "AppDelegate.h"

@interface SharePageViewController ()

@end

@implementation SharePageViewController

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
- (IBAction)openTwitter:(id)sender {
    
    TWTweetComposeViewController *twt = [[TWTweetComposeViewController alloc]init];
    
    
    NSString *initailText = [NSString stringWithFormat:@"おきたよ！#OyE"];
    
    [twt setInitialText:initailText];
    [self presentViewController:twt animated:YES completion:nil];
    
    
}
- (IBAction)BackToHomepage:(id)sender {
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [delegate.check_timer invalidate];
    
    HomepageViewController *homepageViewController = [[HomepageViewController alloc]init];
    
    homepageViewController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
//
//    [self presentModalViewController:homepageViewController animated:YES];
//    
    
    [delegate.window setRootViewController:homepageViewController];
    [delegate.window makeKeyAndVisible];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
