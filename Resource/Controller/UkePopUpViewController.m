//
//  UkePopUpViewController.m
//  TestModalViewController
//
//  Created by liqian on 2018/12/17.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "UkePopUpViewController.h"
#import "UkeAlertStyleAnimation.h"
#import "UkeActionSheetAnimation.h"
#import "UkeAlertPresentingViewController.h"
#import "Masonry.h"

@interface UkePopUpViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) UkeAlertPresentingViewController *presentingVc;
@property (nonatomic, assign) UIDeviceOrientation originalOrientation;
@property (nonatomic, assign) CGFloat contentMaximumHeightInset;
@property (nonatomic, strong) UkeAlertBaseAnimation *animation;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation UkePopUpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;
        self.originalOrientation = [UIDevice currentDevice].orientation;
    }
    return self;
}

+ (instancetype)alertControllerWithContentView:(UIView *)view
                             preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UkePopUpViewController *popUpController = [[UkePopUpViewController alloc] init];
    popUpController.preferredStyle = preferredStyle;
    [popUpController addContentView:view];
    return popUpController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:_contentView];
    
    CGFloat contentMaximumHeight = self.contentMaximumHeight;
    if (_preferredStyle == UIAlertControllerStyleActionSheet) {
        contentMaximumHeight = self.contentMaximumHeight-self.sheetContentMarginBottom;
    }
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.contentWidth != 0) {
            make.width.mas_equalTo(self.contentWidth);
        }
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_lessThanOrEqualTo(contentMaximumHeight);
    }];
    [self.view layoutIfNeeded];
    self.view.bounds = _contentView.bounds;
}

#pragma mark - 监听屏幕方向变化
#ifdef __IPHONE_8_0
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGFloat newContentMaximumHeight = size.height-self.contentMaximumHeightInset;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [self deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:context.transitionDuration];
            return;
        }
        
        CGFloat safePadding = 0;
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
            safePadding = MAX(safeInsets.top, safeInsets.bottom);
        }

        if (self.originalOrientation == UIDeviceOrientationPortrait ||
            self.originalOrientation == UIDeviceOrientationPortraitUpsideDown) {
            UIDevice *device = [UIDevice currentDevice];
            // 如果最开始是竖屏，现在是横屏
            if (device.orientation == UIDeviceOrientationLandscapeLeft ||
                device.orientation == UIDeviceOrientationLandscapeRight) {
                if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
                    newContentMaximumHeight += CGRectGetHeight([UIApplication sharedApplication].statusBarFrame); // 横屏时状态栏是隐藏的，所以多出20pt
                }else if (self.preferredStyle == UIAlertControllerStyleAlert) {
                    
                }
            }
        }else if (self.originalOrientation == UIDeviceOrientationLandscapeLeft ||
                  self.originalOrientation == UIDeviceOrientationLandscapeRight) {
            UIDevice *device = [UIDevice currentDevice];
            // 如果最开始是横屏，现在是竖屏
            if (device.orientation == UIDeviceOrientationPortrait ||
                device.orientation == UIDeviceOrientationPortraitUpsideDown) {
                
                if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
                    newContentMaximumHeight -= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame); // 竖屏时状态栏是显示的，所以少20pt
                }else if (self.preferredStyle == UIAlertControllerStyleAlert) {
                    if (safePadding >= 20) {
                        newContentMaximumHeight -= safePadding;
                    }
                }
            }
        }
        
        [self deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:context.transitionDuration];
    } completion:nil];
}
#else
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    CGFloat newContentMaximumHeight = CGRectGetHeight([UIScreen mainScreen].bounds)-self.contentMaximumHeightInset;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:context.transitionDuration];
        return;
    }

    if (self.originalOrientation == UIDeviceOrientationLandscapeLeft ||
             self.originalOrientation == UIDeviceOrientationLandscapeRight) {
        UIDevice *device = [UIDevice currentDevice];
        // 如果最开始是横屏，现在是竖屏
        if (device.orientation == UIDeviceOrientationPortrait ||
            device.orientation == UIDeviceOrientationPortraitUpsideDown) {
            
            if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
                newContentMaximumHeight -= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame); // 竖屏时状态栏是显示的，所以少20pt
            }
        }
    }
    [self deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:duration];
}
#endif

- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                  duration:(NSTimeInterval)duration {
    if (_preferredStyle == UIAlertControllerStyleActionSheet) {
        contentMaximumHeight = contentMaximumHeight-self.sheetContentMarginBottom;
    }
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_lessThanOrEqualTo(contentMaximumHeight);
    }];
    [self.view layoutIfNeeded];
    self.view.bounds = _contentView.bounds;
    
    [self.animation deviceOrientationDidChangeDuration:duration];
}

#pragma mark - Public.
- (void)setPreferredStyle:(UIAlertControllerStyle)preferredStyle {
    _preferredStyle = preferredStyle;
    
    CGFloat safePadding = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        safePadding = MAX(safeInsets.top, safeInsets.bottom);
    }
    
    if (preferredStyle == UIAlertControllerStyleAlert) {
        self.presentDelayTimeInterval = 0;
        self.presentTimeInterval = 0.25;
        self.dismissDelayTimeInterval = 0.1;
        self.dismissTimeInterval = 0.22;
        self.shouldRespondsMaskViewTouch = NO;
        
        if (safePadding <= 20) {
            safePadding = 24;
        }
        self.contentMaximumHeight = [UIScreen mainScreen].bounds.size.height-safePadding-safePadding;
    }else if (preferredStyle == UIAlertControllerStyleActionSheet) {
        self.presentDelayTimeInterval = 0.1;
        self.presentTimeInterval = 0.18;
        self.dismissDelayTimeInterval = 0.1;
        self.dismissTimeInterval = 0.16;
        self.shouldRespondsMaskViewTouch = YES;
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationPortrait ||
            orientation == UIDeviceOrientationPortraitUpsideDown) {
            if (safePadding <= 20) {
                safePadding = 40;
            }
        }else if (orientation == UIDeviceOrientationLandscapeLeft ||
                  orientation == UIDeviceOrientationLandscapeRight) {
            if (safePadding == 0) {
                safePadding = 8;
                if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                    safePadding = 40; // iPad横屏时状态栏不消失
                }
            }
        }
        self.contentMaximumHeight = [UIScreen mainScreen].bounds.size.height-safePadding;
    }
}

- (void)addContentView:(UIView *)view {
    _contentView = view;
}

#pragma mark - Show
- (void)show {
    [self showWithAnimated:YES];
}

- (void)showWithAnimated:(BOOL)animated {
    [self showWithAnimated:animated completion:nil];
}

- (void)showWithAnimated:(BOOL)animated
              completion:(nullable void(^)(void))completionHandler {
    UkeAlertPresentingViewController *presentingVc = [[UkeAlertPresentingViewController alloc] init];
    [presentingVc presentViewController:self animated:animated completion:completionHandler];
    _presentingVc = presentingVc;
}

#pragma mark - Dismiss
- (void)dismiss {
    [self dismissWithAnimated:YES];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismissWithAnimated:animated completion:nil];
}

- (void)dismissWithAnimated:(BOOL)animated
                 completion:(nullable void (^)(void))completionHandler {
    [self dismissViewControllerAnimated:animated completion:^{
        if (completionHandler) {
            completionHandler();
        }
        if (self.dismissCompletion) {
            self.dismissCompletion();
        }
        if (self.presentingVc) {
            [self.presentingVc alertControllerDidDismiss];
        }
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate.
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    UkeAlertBaseAnimation *animation = self.animation;
    animation.isPresented = YES;
    return animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    UkeAlertBaseAnimation *animation = self.animation;
    animation.isPresented = NO;
    return animation;
}

#pragma mark - Setter.
- (void)setContentMaximumHeight:(CGFloat)contentMaximumHeight {
    _contentMaximumHeight = contentMaximumHeight;
    _contentMaximumHeightInset = CGRectGetHeight([UIScreen mainScreen].bounds)-contentMaximumHeight;
}

- (void)setPresentDelayTimeInterval:(CGFloat)presentDelayTimeInterval {
    _presentDelayTimeInterval = presentDelayTimeInterval;
    self.animation.presentDelayTimeInterval = presentDelayTimeInterval;
}

- (void)setPresentTimeInterval:(CGFloat)presentTimeInterval {
    _presentTimeInterval = presentTimeInterval;
    self.animation.presentTimeInterval = presentTimeInterval;
}

- (void)setDismissDelayTimeInterval:(CGFloat)dismissDelayTimeInterval {
    _dismissDelayTimeInterval = dismissDelayTimeInterval;
    self.animation.dismissDelayTimeInterval = dismissDelayTimeInterval;
}

- (void)setDismissTimeInterval:(CGFloat)dismissTimeInterval {
    _dismissTimeInterval = dismissTimeInterval;
    self.animation.dismissTimeInterval = dismissTimeInterval;
}

#pragma mark - Getter.
- (UkeAlertBaseAnimation *)animation {
    if (!_animation) {
        if (self.preferredStyle == UIAlertControllerStyleAlert) {
            _animation = [[UkeAlertStyleAnimation alloc] init];
        }else if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
            _animation = [[UkeActionSheetAnimation alloc] init];
        }
    }
    return _animation;
}

- (CGFloat)sheetContentMarginBottom {
    CGFloat safePaddingBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        safePaddingBottom = safeInsets.bottom;
    }
    return _sheetContentMarginBottom+safePaddingBottom;
}

- (void)dealloc {
    NSLog(@"UkePopUpViewController 销毁");
}

@end
