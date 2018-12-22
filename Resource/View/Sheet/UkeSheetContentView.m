//
//  UkeSheetContentView.m
//  TestModalViewController
//
//  Created by liqian on 2018/12/22.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "UkeSheetContentView.h"
#import "UkeSheetActionGroupView.h"
#import "UkeAlertActionButton.h"
#import "UkeAlertAction.h"
#import "Masonry.h"

@interface UkeSheetContentView ()
@property (nonatomic, strong) UkeAlertAction *cancelAction;
@property (nonatomic, strong) UkeSheetActionGroupView *actionGroupView;
@property (nonatomic, assign) CGFloat actionButtonHeight;
@end

@implementation UkeSheetContentView

- (instancetype)init {
    self = [super init];
    if (self) {        
        self.sheetCancelButtonMarginTop = 8.0;
    }
    return self;
}

- (void)insertActionGroupView:(UIView *)actionGroupView {
    [super insertActionGroupView:actionGroupView];

    _actionGroupView = (UkeSheetActionGroupView *)actionGroupView;
    _actionButtonHeight = _actionGroupView.actionButtonHeight;
}

- (void)addCancelAction:(UkeAlertAction *)action {
    self.cancelAction = action;
    
    [self.backContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-self.sheetCancelButtonMarginTop-self.actionButtonHeight);
    }];
    
    UkeAlertActionButton *cancelButton = [[UkeAlertActionButton alloc] init];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.cornerRadius = 12.0;
    cancelButton.layer.masksToBounds = YES;
    [self setAttributedTextWith:action.title forButton:cancelButton];
    [cancelButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backContentView.mas_bottom).offset(self.sheetCancelButtonMarginTop);
        make.left.right.offset(0);
        make.height.mas_equalTo(self.actionButtonHeight);
    }];
}

- (void)setAttributedTextWith:(NSString *)text
                    forButton:(UkeAlertActionButton *)button {
    button.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.actionGroupView.cancelButtonAttributes];
}

- (void)handleButtonAction:(UIButton *)button {
    if (self.cancelAction.actionHandler) {
        self.cancelAction.actionHandler(self.cancelAction);
    }
    
    if (self.actionGroupView.dismissHandler) {
        self.actionGroupView.dismissHandler();
    }
}

@end
