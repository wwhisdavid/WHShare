//
//  WHShareView.m
//  WHShareView
//
//  Created by deyi on 15/7/9.
//  Copyright (c) 2015年 deyi. All rights reserved.
//
#import "ViewController.h"
#import "WHShareView.h"
#import "WHButtonView.h"
#import "Masonry.H"
#define BUTTON_VIEW_SIDE 70.f
#define BUTTON_VIEW_FONT_SIZE 13.f
#define ICON_VIEW_HEIGHT_SPACE 8

#pragma mark - WHShareView

@interface WHShareView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSString *title;

//将要显示在该视图上
@property (nonatomic, weak) UIView *referView;

//内容窗口
@property (nonatomic, strong) UIView *contentView;

//透明的关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

//按钮加载的view
//@property (nonatomic, strong) UIView *iconView;

//button数组
@property (nonatomic, strong) NSMutableArray *buttonArray;

//行数
@property (nonatomic, assign) int lines;

//目前正在生效的numberOfButtonPerLine
@property (nonatomic, assign) int workingNumberOfButtonPerLine;

//按钮间的间隔大小
@property (nonatomic, assign) CGFloat buttonSpace;

//消失的时候移除
@property (nonatomic, strong) NSLayoutConstraint *contentViewAndViewConstraint;

//iconView高度的constraint
@property (nonatomic, strong) NSLayoutConstraint *iconViewHeightConstraint;

//iconView高度的constraint
@property (nonatomic, strong) NSLayoutConstraint *scrollViewHeightConstraint;


//buttonView的constraints
@property (nonatomic, strong) NSMutableArray *buttonConstraintsArray;


//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;





@end

@implementation WHShareView

- (void)dealloc
{
    //移除通知中心
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (id)initWithTitle:(NSString *)title referView:(UIView *)referView
{
    self = [super init];
    if (self) {
        self.title = title;
        
        if (referView) {
            self.referView = referView;
            
        }
        
        [self setup];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        
    }
    return self;
    
}



- (void)calculateButtonSpaceWithNumberOfButtonPerLine:(int)number
{
    self.buttonSpace = (self.referView.bounds.size.width - BUTTON_VIEW_SIDE * number) / (number + 1);
    NSLog(@"%f------%f",self.referView.bounds.size.width,self.buttonSpace);
    if (self.buttonSpace < 0) {
        [self calculateButtonSpaceWithNumberOfButtonPerLine:4];
        
    } else {
        
        self.workingNumberOfButtonPerLine = number;
        
    }
}

- (void)setup
{
    self.buttonArray = [NSMutableArray array];
    self.buttonConstraintsArray = [NSMutableArray array];
    self.lines = 0;
    self.numberOfButtonPerLine = 4;
    self.useGesturer = YES;
    
    //按下按钮后的背景颜色
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    
    self.contentView = [[UIView alloc]init];
    
    self.bgColor = [UIColor colorWithRed:111/255.0 green:1 blue:1 alpha:0.95f];
    [self addSubview:self.contentView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.titleLabel.text = self.title;
    [self.contentView addSubview:self.titleLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    
    //scrollView set
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    //page
    //    self.scrollView.contentSize = CGSizeMake(900, 100);
    
    
    
    //    self.iconView = [[UIView alloc]init];
    //    [self.scrollView addSubview:self.iconView];q
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.contentView addSubview:self.pageControl];
    self.pageControl.currentPage = 0;
    
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    
    
    [self setNeedsUpdateConstraints];
    
    //添加下滑关闭手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipe];
    

}

/**
 *  约束设置
 */
- (void)updateConstraints
{
    [super updateConstraints];
    
    NSArray *constraints = nil;
    NSLayoutConstraint *constraint = nil;
    NSDictionary *views = @{@"contentView": self.contentView, @"closeButton": self.closeButton, @"titleLabel": self.titleLabel, @"cancelButton": self.cancelButton,  @"view": self, @"referView": self.referView, @"scrollView":self.scrollView , @"pageControl":self.pageControl};
    
    //view跟referView的宽高相等
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.referView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.referView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.referView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.referView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.referView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self.referView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.referView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.referView addConstraint:constraint];
    
    //closeButton跟view的左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[closeButton]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //contentView跟view的左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //垂直方向closeButton挨着contentView
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[closeButton(==view@999)][contentView]" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //titleLabel跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //cancelButton跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cancelButton]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //pageControl跟contentView
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[pageControl(40)]" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    
    //ScrollView跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    //    //iconView跟scrollView左右挨着
    //    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iconView]|" options:0 metrics:nil views:views];
    //    [self.scrollView addConstraints:constraints];
    
    //    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iconView]|" options:0 metrics:nil views:views];
    //    [self.scrollView addConstraints:constraints];
    //    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(self.scrollView.contentSize);
    //    }];
    //
    
    
    //    //iconView跟scrollView上下挨着
    //    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]|" options:0 metrics:nil views:views];
    //    [self.scrollView addConstraints:constraints];
    //
    
    
    
    //scrollView的高度
    
    if (self.scrollViewHeightConstraint) {
        [self.scrollView removeConstraint:self.scrollViewHeightConstraint];
        
    }
    self.scrollViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_VIEW_SIDE + 2 * ICON_VIEW_HEIGHT_SPACE];
    [self.scrollView addConstraint:self.scrollViewHeightConstraint];
    
    //垂直方向titleLabel挨着scrollView挨着page挨着cancelButton
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleLabel(==30)]-[scrollView]-[pageControl(==5)]-[cancelButton(==25)]-8-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    
    
}

- (void)prepareForShow
{
    //计算行数
    int count = [self.buttonArray count];
    self.lines = count / self.workingNumberOfButtonPerLine;
    if (count % self.workingNumberOfButtonPerLine != 0) {
        self.lines++;
        
    }
    self.pageControl.numberOfPages = self.lines;
    
#pragma mark - warnning
    if (self.lines > 1) {
        [self.scrollView setContentSize:CGSizeMake(self.lines * self.referView.bounds.size.width,self.scrollView.frame.size.height)];
    }
    else{
        [self.scrollView setContentSize:CGSizeMake(self.referView.bounds.size.width,self.scrollView.frame.size.height)];
    }
    
    for (int i = 0; i < [self.buttonArray count]; i++) {
        WHButtonView *buttonView = [self.buttonArray objectAtIndex:i];
        [self.scrollView addSubview:buttonView];
        int y = i / self.workingNumberOfButtonPerLine;
        int x = i % self.workingNumberOfButtonPerLine;
        
        if (self.workingNumberOfButtonPerLine == 4) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:ICON_VIEW_HEIGHT_SPACE];
            [self.scrollView addConstraint:constraint];
            [self.buttonConstraintsArray addObject:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:(x + 1) * self.buttonSpace + x * BUTTON_VIEW_SIDE + y * self.referView.bounds.size.width];
            NSLog(@"%f-=-=-=-",self.referView.bounds.size.width);
            [self.scrollView addConstraint:constraint];
            [self.buttonConstraintsArray addObject:constraint];
            
        }
        else{
            
            //排列buttonView的位置
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:ICON_VIEW_HEIGHT_SPACE];
            [self.scrollView addConstraint:constraint];
            [self.buttonConstraintsArray addObject:constraint];
            
            constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:(x + 1) * self.buttonSpace + x * BUTTON_VIEW_SIDE + y * self.referView.bounds.size.width];
            [self.scrollView addConstraint:constraint];
            [self.buttonConstraintsArray addObject:constraint];
            
            
            
        }
        //        //排列buttonView的位置
        //        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:(y + 1) * ICON_VIEW_HEIGHT_SPACE + y * BUTTON_VIEW_SIDE];
        //        [self.scrollView addConstraint:constraint];
        //        [self.buttonConstraintsArray addObject:constraint];
        //
        //        constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:(x + 1) * self.buttonSpace + x * BUTTON_VIEW_SIDE];
        //        [self.scrollView addConstraint:constraint];
        //        [self.buttonConstraintsArray addObject:constraint];
        //
    }
    
    [self layoutIfNeeded];
    
    
}



- (void)show
{
    if (self.isShowing) {
        return;
        
    }
    [self.referView addSubview:self];
    [self setNeedsUpdateConstraints];
    self.alpha = 0;
    
    [self prepareForShow];
    
    self.contentViewAndViewConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraint:self.contentViewAndViewConstraint];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
        self.show = YES;
        
    }];
}

- (void)hide
{
    if (!self.isShowing) {
        return;
        
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        [self removeConstraint:self.contentViewAndViewConstraint];
        self.contentViewAndViewConstraint = nil;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.show = NO;
        [self removeFromSuperview];
        
    }];
    
}


- (void)reflashScreen
{
    [self.scrollView removeConstraints:self.buttonConstraintsArray];
    [self.buttonConstraintsArray removeAllObjects];
    
    [self calculateButtonSpaceWithNumberOfButtonPerLine:self.numberOfButtonPerLine];
    [self prepareForShow];
    
    [self.scrollView removeConstraint:self.scrollViewHeightConstraint];
    self.scrollViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant: BUTTON_VIEW_SIDE + 2 * ICON_VIEW_HEIGHT_SPACE];
    [self.scrollView addConstraint:self.scrollViewHeightConstraint];

}
/**
 *  屏幕旋转调用，
 */
- (void)deviceRotate:(NSNotification *)notification
{
    [self reflashScreen];
    
}

- (void)setNumberOfButtonPerLine:(int)numberOfButtonPerLine
{
    _numberOfButtonPerLine = numberOfButtonPerLine;
    [self calculateButtonSpaceWithNumberOfButtonPerLine:numberOfButtonPerLine];
    
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.contentView.backgroundColor = bgColor;
    
}

- (void)addButtonView:(WHButtonView *)buttonView
{
    [self.buttonArray addObject:buttonView];
    buttonView.activityView = self;
    
}

- (void)closeButtonClicked:(UIButton *)button
{
    [self hide];
    
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)swipe
{
    if (self.useGesturer) {
        [self hide];
        
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (self.scrollView.contentOffset.x + self.referView.bounds.size.width * 0.5) / self.referView.bounds.size.width;
}

@end
