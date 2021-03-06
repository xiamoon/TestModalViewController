//
//  UkeAlertController.m
//  TestModalViewController
//
//  Created by liqian on 2018/12/17.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "UkeAlertController.h"
#import "UkeAlertContentView.h"
#import "UkeSheetContentView.h"
#import "UkeAlertCustomizeHeaderView.h"
#import "UkeAlertHeaderView.h"
#import "UkeSheetHeaderView.h"
#import "UkeAlertActionGroupView.h"
#import "UkeSheetActionGroupView.h"
#import "Masonry.h"

@interface UkeAlertController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UkeAlertContentView *alertContentView; //! 整个content
@property (nonatomic, strong) UkeAlertHeaderView *headerView; //! title和message
@property (nonatomic, strong) UkeAlertActionGroupView *actionGroupView; //! 按钮区域
@end

@implementation UkeAlertController
@synthesize contentWidth = _contentWidth;
@synthesize sheetContentMarginBottom = _sheetContentMarginBottom;
@synthesize cornerRadius = _cornerRadius;

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UkeAlertController *alertVc = [[UkeAlertController alloc] initInternalWithTitle:title message:message preferredStyle:preferredStyle];
    return alertVc;
}

+ (instancetype)alertControllerWithContentView:(UIView *)view preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UkeAlertController *alertVc = [[UkeAlertController alloc] initInternalWithPreferredStyle:preferredStyle];
    [alertVc addContentView:view];
    return alertVc;
}

- (void)addContentView:(UIView *)view {
    _headerView = [[UkeAlertCustomizeHeaderView alloc] initWithCustomizeView:view];
}

- (void)viewDidLoad {
    BOOL needLayout = [self.actionGroupView layoutActions];
    [self.alertContentView insertHeaderView:self.headerView];
    [self.alertContentView insertActionGroupView:needLayout ? self.actionGroupView : nil];
    
    [super addContentView:self.alertContentView];
    [super viewDidLoad];
}

- (void)addAction:(UkeAlertAction *)action {
    // ActionSheet的cancel按钮需要特殊处理，因为这个按钮不是添加在actionGroupView中的，而是在contentView中
    BOOL isSheetCancelAction = NO;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet && action.style == UIAlertActionStyleCancel) {
        isSheetCancelAction = YES;
    }
    
    if (isSheetCancelAction) {
        [[self sheetContentView] addCancelAction:action];
    }else {
        [self.actionGroupView addAction:action];
    }
}

#pragma mark - Private.
- (instancetype)initInternalWithTitle:(NSString *)title
                              message:(NSString *)message
                       preferredStyle:(UIAlertControllerStyle)preferredStyle {
    self = [[[self class] alloc] initInternalWithPreferredStyle:preferredStyle];
    if (self) {
        CGFloat defaultContentWidth = 0;
        UkeAlertHeaderView *header = nil;
        
        if (preferredStyle == UIAlertControllerStyleAlert) {
            header = [[UkeAlertHeaderView alloc] initWithTitle:title message:message];
            defaultContentWidth = 270.0;
        }else if (preferredStyle == UIAlertControllerStyleActionSheet) {
            header = [[UkeSheetHeaderView alloc] initWithTitle:title message:message];
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGFloat minWidth = MIN(screenSize.width, screenSize.height);
            defaultContentWidth = minWidth-8-8;
        }
        [self setContentWidth:defaultContentWidth];
        _headerView = header;
    }
    return self;
}

- (instancetype)initInternalWithPreferredStyle:(UIAlertControllerStyle)preferredStyle {
    self = [super init];
    if (self) {
        self.preferredStyle = preferredStyle;
        
        UkeAlertContentView *content = nil;
        if (preferredStyle == UIAlertControllerStyleAlert) {
            content = [[UkeAlertContentView alloc] init];
            content.contentMaximumHeight = self.contentMaximumHeight;
        }else if (preferredStyle == UIAlertControllerStyleActionSheet) {
            [self setSheetContentMarginBottom:8.0];
            content = [self sheetContentView];
            content.contentMaximumHeight = self.contentMaximumHeight-self.sheetContentMarginBottom;
        }
        _alertContentView = content;
        [self setCornerRadius:12.0];
    }
    return self;
}

- (void)deviceOrientationWillChangeWithContentMaximumHeight:(CGFloat)contentMaximumHeight
                                                   duration:(NSTimeInterval)duration {
    CGFloat newContentMaximumHeight = contentMaximumHeight;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        newContentMaximumHeight = contentMaximumHeight-self.sheetContentMarginBottom;
    }
    [_alertContentView deviceOrientationWillChangeWithContentMaximumHeight:newContentMaximumHeight duration:duration];
    
    [super deviceOrientationWillChangeWithContentMaximumHeight:contentMaximumHeight duration:duration];
}

#pragma mark - Setter.
- (void)setContentWidth:(CGFloat)contentWidth {
    _contentWidth = contentWidth;
    [super setContentWidth:contentWidth];
}

- (void)setTitleMessageAreaContentInsets:(UIEdgeInsets)titleMessageAreaContentInsets {
    _titleMessageAreaContentInsets = titleMessageAreaContentInsets;
    [_headerView setTitleMessageAreaContentInsets:titleMessageAreaContentInsets];
}

- (void)setTitleMessageVerticalSpacing:(CGFloat)titleMessageVerticalSpacing {
    _titleMessageVerticalSpacing = titleMessageVerticalSpacing;
    [_headerView setTitleMessageVerticalSpacing:titleMessageVerticalSpacing];
}

- (void)setSheetCancelButtonMarginTop:(CGFloat)sheetCancelButtonMarginTop {
    _sheetCancelButtonMarginTop = sheetCancelButtonMarginTop;
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [self sheetContentView].sheetCancelButtonMarginTop = sheetCancelButtonMarginTop;
    }
}

- (void)setSheetContentMarginBottom:(CGFloat)sheetContentMarginBottom {
    _sheetContentMarginBottom = sheetContentMarginBottom;
    [super setSheetContentMarginBottom:sheetContentMarginBottom];
}

- (void)setTitleAttributes:(NSDictionary<NSString *,id> *)titleAttributes {
    [self.headerView setTitleAttributes:titleAttributes];
}

- (void)setMessageAttributes:(NSDictionary<NSString *,id> *)messageAttributes {
    [self.headerView setMessageAttributes:messageAttributes];
}

- (void)setActionButtonHeight:(CGFloat)actionButtonHeight {
    _actionButtonHeight = actionButtonHeight;
    [self.actionGroupView setActionButtonHeight:actionButtonHeight];
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [self sheetContentView].cancelActionButtonHeight = actionButtonHeight;
    }
}

- (void)setDefaultButtonAttributes:(NSDictionary<NSString *,id> *)defaultButtonAttributes {
    [self.actionGroupView setDefaultButtonAttributes:defaultButtonAttributes];
}

- (void)setCancelButtonAttributes:(NSDictionary<NSString *,id> *)cancelButtonAttributes {
    [self.actionGroupView setCancelButtonAttributes:cancelButtonAttributes];
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [self sheetContentView].cancelButtonAttributes = cancelButtonAttributes;
    }
}

- (void)setDestructiveButtonAttributes:(NSDictionary<NSString *,id> *)destructiveButtonAttributes {
    [self.actionGroupView setDestructiveButtonAttributes:destructiveButtonAttributes];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _alertContentView.cornerRadius = cornerRadius;
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    self.alertContentView.separatorHeight = lineHeight;
    self.actionGroupView.lineHeight = lineHeight;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.alertContentView.separatorColor = lineColor;
    self.actionGroupView.lineColor = lineColor;
}

#pragma mark - Getter.
- (UkeSheetContentView *)sheetContentView {
    UkeSheetContentView *sheetContentView = (UkeSheetContentView *)self.alertContentView;
    if (!sheetContentView) {
        sheetContentView = [[UkeSheetContentView alloc] init];
        __weak typeof(self)weakSelf = self;
        sheetContentView.ukeActionButtonHandler = ^(UkeAlertAction * _Nonnull action) {
            if (action.shouldAutoDismissAlertController) {
                [weakSelf uke_dismissWithAnimated:YES completion:^{
                    if (action.actionHandler) {
                        action.actionHandler(action);
                    }
                }];
            } else {
                if (action.actionHandler) {
                    action.actionHandler(action);
                }
            }
        };
    }
    return sheetContentView;
}

- (UkeAlertActionGroupView *)actionGroupView {
    if (!_actionGroupView) {
        if (self.preferredStyle == UIAlertControllerStyleAlert) {
            _actionGroupView = [[UkeAlertActionGroupView alloc] init];
        }else if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
            _actionGroupView = [[UkeSheetActionGroupView alloc] init];
        }
        
        __weak typeof(self)weakSelf = self;
        _actionGroupView.ukeActionButtonHandler = ^(UkeAlertAction * _Nonnull action) {
            if (action.shouldAutoDismissAlertController) {
                [weakSelf uke_dismissWithAnimated:YES completion:^{
                    if (action.actionHandler) {
                        action.actionHandler(action);
                    }
                }];
            } else {
                if (action.actionHandler) {
                    action.actionHandler(action);
                }
            }
        };
    }
    return _actionGroupView;
}

- (NSArray<UkeAlertAction *> *)actions {
    return self.actionGroupView.actions;
}

- (CGFloat)sheetContentMarginBottom {
    CGFloat safePaddingBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        safePaddingBottom = safeInsets.bottom;
    }
    return _sheetContentMarginBottom+safePaddingBottom;
}

@end
