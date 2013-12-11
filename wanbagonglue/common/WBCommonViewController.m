//
//  WBCommonViewController.m
//  wanbagonglue
//
//  Created by demo on 13-12-11.
//  Copyright (c) 2013年 dianqu. All rights reserved.
//

#import "WBCommonViewController.h"
#import "YYUtil.h"
@interface WBCommonViewController ()

@end

@implementation WBCommonViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Do any additional setup after loading the view.
        if([YYUtil isIOS7]){
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
    return self;
}
-(void)initNavTitle:(NSString *)title
{
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = title;
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLab;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
