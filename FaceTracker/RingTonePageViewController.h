//
//  RingTonePageViewController.h
//  FaceAlarmP
//
//  Created by Lsr on 13-8-20.
//  Copyright (c) 2013年 Lsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RingTonePageViewController : UIViewController{
    AVAudioPlayer *player;
    NSString *path;
}



@end
