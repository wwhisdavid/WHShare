//
//  ViewController.h
//  WHShareView
//
//  Created by deyi on 15/7/9.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>
@optional
- (CGFloat)viewControllerWidthChange:(CGFloat)width;

@end
@interface ViewController : UIViewController


@property (nonatomic , weak) id<ViewControllerDelegate> delegate;
@end


