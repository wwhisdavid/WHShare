//
//  WHButtonView.m
//  WHShareView
//
//  Created by deyi on 15/7/9.
//  Copyright (c) 2015年 deyi. All rights reserved.
//
#import "ViewController.h"
#import "WHButtonView.h"
#import "WHShareView.h"
#define BUTTON_VIEW_SIDE 70.f
#define BUTTON_VIEW_FONT_SIZE 13.f
#pragma mark - ButtonView

@interface WHButtonView ()

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) ButtonViewHandler handler;

@end

@implementation WHButtonView

- (id)initWithText:(NSString *)text image:(UIImage *)image handler:(ButtonViewHandler)handler
{
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
        if (handler) {
            self.handler = handler;
            
        }
        
        [self setup];
        
    }
    return self;
    
}

- (void)setup
{
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.text = self.text;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:BUTTON_VIEW_FONT_SIZE];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageButton setImage:self.image forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.imageButton];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint = nil;
    NSDictionary *views = @{@"textLabel": self.textLabel, @"imageButton": self.imageButton};
    NSArray *constraints = nil;
    
    //view的宽高为70
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_VIEW_SIDE];
    [self addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_VIEW_SIDE];
    [self addConstraint:constraint];
    
    //label紧贴view的左右
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textLabel]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //imageView距离view左右各10, imageView的宽为50
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[imageButton(50)]-10-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //竖直方向imageView和textLabel在一条直线上, 并且挨着, imageView的高为50
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageButton(50)][textLabel]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    [self addConstraints:constraints];
    
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.handler) {
        self.handler(self);
        
    }
    
    if (self.activityView) {
        [self.activityView hide];
        
    }
    
}

@end

