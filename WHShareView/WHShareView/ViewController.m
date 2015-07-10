//
//  ViewController.m
//  WHShareView
//
//  Created by deyi on 15/7/9.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "ViewController.h"
#import "WHShareView.h"
#import "WHButtonView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) WHShareView *activityView;

//@property (nonatomic, assign) CGFloat screenWidth;

@end

@implementation ViewController

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
    // Do any additional setup after loading the view.
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:@"press button" forState:UIControlStateNormal];
    [self.button sizeToFit];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view setNeedsUpdateConstraints];
    
}



/**
 *  约束在中心
 */
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
}


//
//- (void)addButtonClicked:(UIButton *)button
//{
//    ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"share_platform_sina"] handler:^(ButtonView *buttonView){
//        NSLog(@"点击新增的新浪微博");
//    }];
//    [self.activityView addButtonView:bv];
//}


- (void)buttonClicked:(UIButton *)button
{
    if (!self.activityView) {
        self.activityView = [[WHShareView alloc]initWithTitle:@"分享到" referView:self.view];
        self.activityView.screenWidth = 320;
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 6;
        
        WHButtonView *bv = [[WHButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"share_platform_sina"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击新浪微博");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"Email" image:[UIImage imageNamed:@"share_platform_email"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击Email");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"印象笔记" image:[UIImage imageNamed:@"share_platform_evernote"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击印象笔记");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"share_platform_qqfriends"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击QQ");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击微信");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
        }];
        [self.activityView addButtonView:bv];
        bv = [[WHButtonView alloc]initWithText:@"印象笔记" image:[UIImage imageNamed:@"share_platform_evernote"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击印象笔记");
        }];
        [self.activityView addButtonView:bv];
        bv = [[WHButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击微信");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
        }];
        [self.activityView addButtonView:bv];
        bv = [[WHButtonView alloc]initWithText:@"印象笔记" image:[UIImage imageNamed:@"share_platform_evernote"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击印象笔记");
        }];
        [self.activityView addButtonView:bv];
        bv = [[WHButtonView alloc]initWithText:@"微信" image:[UIImage imageNamed:@"share_platform_wechat"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击微信");
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[WHButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"share_platform_wechattimeline"] handler:^(WHButtonView *buttonView){
            NSLog(@"点击微信朋友圈");
        }];
        [self.activityView addButtonView:bv];
        
        
        
    }
    
    [self.activityView show];
    
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  viewController的尺寸发生变化调用
 */
//注意：第一次获取的屏幕宽度为320？？！！，所以如果这样获取屏幕宽度，第一次显示是不准确的，不使用这样的方法，而是获得WHShareView的referView宽度作为屏宽。
//- (void)viewDidLayoutSubviews
//{
//    
//    NSLog(@"%f",self.view.frame.size.width);
//    
//    self.activityView.screenWidth = self.view.frame.size.width;
//    
//}


@end
