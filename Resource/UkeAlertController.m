//
//  UkeAlertController.m
//  TestModalViewController
//
//  Created by liqian on 2018/12/17.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "UkeAlertController.h"
#import "UkeAlertContentView.h"
#import "UkeAlertHeaderView.h"
#import "UkeActionGroupView.h"
#import "Masonry.h"

@interface UkeAlertController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UkeAlertContentView *contentView; //! 整个content
@property (nonatomic, strong) UkeAlertHeaderView *headerView; //! title和message
@property (nonatomic, strong) UkeActionGroupView *actionGroupView; //! 按钮区域
@end

@implementation UkeAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UkeAlertController *alertVc = [[UkeAlertController alloc] init];
    alertVc.preferredStyle = preferredStyle;
    UIView *contentView = [alertVc generateAlertContentViewWithTitle:title message:message preferredStyle:preferredStyle];
    [alertVc addContentView:contentView];
    return alertVc;
}

- (void)addAction:(UkeAlertAction *)action {
    [self.actionGroupView addAction:action];
    [self.contentView insertActionGroupView:self.actionGroupView];
    [self addContentView:self.contentView];
}

- (UkeAlertContentView *)generateAlertContentViewWithTitle:(NSString *)title
                                      message:(NSString *)message
                               preferredStyle:(UIAlertControllerStyle)preferredStyle {
    UkeAlertHeaderView *header = [[UkeAlertHeaderView alloc] initWithTitle:title message:message];
    
    UkeAlertContentView *content = [[UkeAlertContentView alloc] init];
    [content insertHeaderView:header];
    
    self.headerView = header;
    self.contentView = content;
    
    return content;
}

#pragma mark - Getter.
- (UkeActionGroupView *)actionGroupView {
    if (!_actionGroupView) {
        _actionGroupView = [[UkeActionGroupView alloc] init];
    }
    return _actionGroupView;
}

- (NSArray<UkeAlertAction *> *)actions {
    return self.actionGroupView.actions;
}

@end