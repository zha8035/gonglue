//
//  WBNavigationViewController.m
//  wanbagonglue
//
//  Created by demo on 13-12-11.
//  Copyright (c) 2013年 dianqu. All rights reserved.
//

#import "WBNavigationViewController.h"
#import "YYUtil.h"
@interface WBNavigationViewController ()

@end

@implementation WBNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Do any additional setup after loading the view.
        [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:49/255.0 green:128/255.0 blue:144/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
        
        if([YYUtil isGreaterThanIOS6]){
            //ios6下去掉nav bar下面的阴影
            self.navigationBar.shadowImage = [[UIImage alloc] init];
        }
        //加一条黑线
        CGFloat borderWidth = 0.5;
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.borderColor = [UIColor blackColor].CGColor;
        bottomLayer.borderWidth = borderWidth;
        bottomLayer.frame = CGRectMake(0, self.navigationBar.frame.size.height-borderWidth, self.navigationBar.frame.size.width, borderWidth);
        
        [self.navigationBar.layer addSublayer:bottomLayer];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
