//
//  WBTabBarController.m
//  wanbagonglue
//
//  Created by demo on 13-12-11.
//  Copyright (c) 2013年 dianqu. All rights reserved.
//
#define marginLeft 180

#define titleCellLabelColor [UIColor colorWithRed:0x55/255.0 green:0x55/255.0 blue:0x55/255.0 alpha:1]
#define aboutLabelColor [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1]

#import "WBTabBarController.h"
#import "YYUtil.h"
static NSString *kImageName = @"imageName";
static NSString *kTitle = @"titleName";
static NSString *kSubTitle = @"subTitle";
@interface WBTabBarController ()
{
    UIImageView *menuView;
    UIButton *menuButton;
    BOOL isCanMenu;
    BOOL isFrist;
    NSArray *titlesArray;
    NSMutableArray *menuCellsArray;
    NSInteger currentIndex;
}
@end

@implementation WBTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)setMenu
{
    
    UIViewController *currentVC=[self selectedViewController];
    int forward=1;
    if(menuView.frame.origin.x==0){
        forward=-1;
        currentVC.view.userInteractionEnabled=YES;
    }else{
        currentVC.view.userInteractionEnabled=NO;
    }
    menuView.center=CGPointMake(menuView.center.x+forward*marginLeft, menuView.center.y);
    menuButton.center=CGPointMake(menuButton.center.x+forward*marginLeft, menuButton.center.y);
    currentVC.view.center=CGPointMake(currentVC.view.center.x+forward*marginLeft, currentVC.view.center.y);
    isCanMenu=YES;
    
}
//菜单按钮事件
-(void)menuButtonClick
{
    menuButton.selected = !menuButton.selected;
    UIViewController *currentVC=[self selectedViewController];
    int forward=1;
    if(menuView.frame.origin.x==0){
        forward=-1;
        currentVC.view.userInteractionEnabled=YES;
    }else{
        if (isFrist) {
            for (int i=0; i<menuCellsArray.count; i++) {
                UIView *cellView = [menuCellsArray objectAtIndex:i];
                CGRect frame = cellView.frame;
                frame.origin.x = -cellView.frame.size.width;
                cellView.frame = frame;
            }
        }
        currentVC.view.userInteractionEnabled=NO;
        
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        menuView.center=CGPointMake(menuView.center.x+forward*marginLeft, menuView.center.y);
        menuButton.center=CGPointMake(menuButton.center.x+forward*marginLeft, menuButton.center.y);
        currentVC.view.center=CGPointMake(currentVC.view.center.x+forward*marginLeft, currentVC.view.center.y);
    } completion:^(BOOL finished) {
        isCanMenu=YES;
        if (isFrist && menuView.frame.origin.x == 0) {
            [self menuCellAnimation];
            isFrist = NO;
        }
    }];
}
-(void)tabTitleButtonClick:(UIButton *)button
{
    if (!isCanMenu) {
        return;
    }
    isCanMenu=NO;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion:^(BOOL finished) {
            self.selectedIndex = button.tag;
            UIViewController *currentVC=self.selectedViewController;
            if (currentVC.view.frame.origin.x==0) {
                currentVC.view.center=CGPointMake(currentVC.view.center.x+80, currentVC.view.center.y);
            }
            [self menuButtonClick];
        }];
    }];
    
}

- (void)makeTabBarHidden:(BOOL)hide {
    if ( [self.view.subviews count] < 2 )
        return;
    
    UIView *contentView;
    
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if ( hide ){
        contentView.frame = self.view.bounds;
    }
    else{
        contentView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    
    self.tabBar.hidden = hide;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isCanMenu=YES;
    isFrist = YES;
	//添加菜单
    if ([YYUtil isIOS7]) {
        menuView=[[UIImageView alloc] initWithFrame:CGRectMake(-marginLeft, 0, marginLeft, 568)];
    }else{
        menuView=[[UIImageView alloc] initWithFrame:CGRectMake(-marginLeft, 20, marginLeft, 568)];
    }
    menuView.userInteractionEnabled=YES;
    menuView.backgroundColor = [UIColor grayColor];
    //menuView.image = [UIImage imageNamed:@"home_menu_bg"];
    [self.view addSubview:menuView];
    
    //添加阴影效果
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(menuView.frame.size.width-8, 0, 8, menuView.frame.size.height)];
    shadowImageView.image = [UIImage imageNamed:@"home_menu_shadow"];
    [menuView addSubview:shadowImageView];
    
    
    UIImage *menuImage=[UIImage imageNamed:@"home_menu_normal"];
    menuButton=[[UIButton alloc] initWithFrame:CGRectMake(15, 10+[YYUtil adjustStatusBarHeightForiOS7], menuImage.size.width/menuImage.size.height*25, 25)];
    [menuButton addTarget:self action:@selector(menuButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //[menuButton setBackgroundImage:[UIImage imageNamed:@"caidan_dianji"] forState:UIControlStateSelected];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    //添加手势
    UISwipeGestureRecognizer *swip=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipTheView:)];
    swip.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swip];
    
    swip=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipTheView:)];
    swip.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    
    titlesArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"主页", kTitle, @"home_menu_main", kImageName,@"了解最新攻略", kSubTitle, nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"我的收藏", kTitle, @"home_menu_collect", kImageName,@"收藏极品攻略", kSubTitle, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"推荐给朋友", kTitle, @"home_menu_tuijian", kImageName,@"让我的朋友们知道", kSubTitle, nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"意见反馈", kTitle, @"home_menu_feedback", kImageName,@"我发现一些问题", kSubTitle, nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"home_menu_about", kImageName,@"关于玩吧", kTitle,@"了解神一般的存在",kSubTitle,  nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"玩吧家族", kTitle,@"我的小伙伴们", kSubTitle, @"home_mune_family", kImageName, nil],nil];
    
    UIScrollView *menuScrollView = [[UIScrollView alloc] initWithFrame:menuView.bounds];
    [menuView addSubview:menuScrollView];
    
    UIImage *cellNormalImage = [UIImage imageNamed:@"menucellbg_select"];
    UIImage *cellSelectImage = [UIImage imageNamed:@"menucellbg"];
    float height =(marginLeft -20)*cellNormalImage.size.height/cellNormalImage.size.width;
    menuCellsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<titlesArray.count; i++) {
        
        UIButton *menuCellButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100+(height+15)*i,marginLeft -20, height)];
        [menuCellButton setBackgroundImage:cellNormalImage forState:UIControlStateNormal];
        [menuCellButton setBackgroundImage:cellSelectImage forState:UIControlStateHighlighted];
        [menuCellButton addTarget:self action:@selector(tabTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        menuCellButton.tag = i;
        [menuScrollView addSubview:menuCellButton];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        iconImageView.image = [UIImage imageNamed:[[titlesArray objectAtIndex:i] objectForKey:kImageName]];
        [menuCellButton addSubview:iconImageView];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 8, 100, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [[titlesArray objectAtIndex:i] objectForKey:kTitle];
        titleLabel.textColor = titleCellLabelColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [menuCellButton addSubview:titleLabel];
        
        float width = menuCellButton.frame.size.width - 45-5;
        CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(width, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect titleFrame = titleLabel.frame;
        titleFrame.size.width = size.width;
        titleLabel.frame = titleFrame;
        
        UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 33, 100, 12)];
        aboutLabel.text = [[titlesArray objectAtIndex:i] objectForKey:kSubTitle];;
        aboutLabel.backgroundColor = [UIColor clearColor];
        aboutLabel.textColor = aboutLabelColor;
        aboutLabel.font = [UIFont systemFontOfSize:12];
        [menuCellButton addSubview:aboutLabel];
        
        size = [aboutLabel.text sizeWithFont:aboutLabel.font constrainedToSize:CGSizeMake(width, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect aboutFrame = aboutLabel.frame;
        aboutFrame.size.width = size.width;
        aboutLabel.frame = aboutFrame;
        
        [menuCellsArray addObject:menuCellButton];
    }
    [menuScrollView setContentSize:CGSizeMake(marginLeft,100+(height+15)*titlesArray.count)];
    
}



-(void)swipTheView:(UISwipeGestureRecognizer *)swip
{
    float p=menuView.frame.origin.x;
    switch (swip.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            if(p==-marginLeft){
                [self menuButtonClick];
            }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            if(p==0){
                [self menuButtonClick];
            }
            break;
        default:
            break;
    }
}

-(void)menuCellAnimation
{
    UIView *cellView = [menuCellsArray objectAtIndex:currentIndex];
    CGRect frame = cellView.frame;
    frame.origin.x = 10;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cellView.frame = frame;
    } completion:^(BOOL finished) {

    }];
    if (currentIndex < menuCellsArray.count-1) {
        currentIndex++;
        [self performSelector:@selector(menuCellAnimation) withObject:nil afterDelay:0.1];
    }else{
        currentIndex = 0;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
