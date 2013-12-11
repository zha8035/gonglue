//
//  WBAppDelegate.h
//  wanbagonglue
//
//  Created by demo on 13-12-11.
//  Copyright (c) 2013年 dianqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTabBarController.h"
@interface WBAppDelegate : UIResponder <UIApplicationDelegate>
{
    WBTabBarController *tabbarVC;
}
@property (strong, nonatomic) UIWindow *window;

@end
