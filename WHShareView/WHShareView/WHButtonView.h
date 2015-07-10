//
//  WHButtonView.h
//  WHShareView
//
//  Created by deyi on 15/7/9.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHShareView;
@class WHButtonView;
typedef void(^ButtonViewHandler)(WHButtonView *buttonView);

@interface WHButtonView : UIView

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *imageButton;

@property (nonatomic, weak) WHShareView *activityView;



- (id)initWithText:(NSString *)text image:(UIImage *)image handler:(ButtonViewHandler)handler;

@end
