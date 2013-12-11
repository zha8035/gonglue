//
//  WBHomeViewController.m
//  wanbagonglue
//
//  Created by demo on 13-12-11.
//  Copyright (c) 2013年 dianqu. All rights reserved.
//

#import "WBHomeViewController.h"

@interface WBHomeViewController ()
{
    UITableView *dataTableView;
}
@end

@implementation WBHomeViewController

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
    [self initNavTitle:@"主页"];
    
    dataTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    dataTableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:dataTableView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
