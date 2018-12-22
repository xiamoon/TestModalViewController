//
//  UkeAlertHeaderView.m
//  TestModalViewController
//
//  Created by liqian on 2018/12/17.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "UkeAlertHeaderView.h"
#import "NSParagraphStyle+Shortcut.h"
#import "Masonry.h"

@interface UkeAlertHeaderView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation UkeAlertHeaderView

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message {
    BOOL hasTitle = NO;
    BOOL hasMessage = NO;
    if ([title isKindOfClass:[NSString class]] && title.length) {
        hasTitle = YES;
    }
    if ([message isKindOfClass:[NSString class]] && message.length) {
        hasMessage = YES;
    }
    if (!hasTitle && !hasMessage) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        
        _titleAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                             NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:18],
                             NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithLineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]
                             };
        _messageAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                               NSFontAttributeName: [UIFont systemFontOfSize:16],
                               NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithLineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]
                               };
        
        NSMutableArray *subviews = [NSMutableArray array];
        if (hasTitle) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.tag = 100;
            _titleLabel.numberOfLines = 0;
            _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:_titleAttributes];
            [self addSubview:_titleLabel];
            [subviews addObject:_titleLabel];
        }
        
        if (hasMessage) {
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.tag = 101;
            _messageLabel.numberOfLines = 0;
            _messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:_messageAttributes];
            [self addSubview:_messageLabel];
            [subviews addObject:_messageLabel];
        }
        
        [self layoutTitleAndMessage:subviews.copy];
    }
    return self;
}

- (void)layoutTitleAndMessage:(NSArray<UIView *> *)subviews {
    UIView *firstView = subviews.firstObject;
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(24);
        if (subviews.count == 1) {
            make.bottom.offset(-24);
        }
    }];
    
    if (subviews.count == 2) {
        UIView *secondView = subviews.lastObject;
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(30);
            make.right.offset(-30);
            make.top.mas_equalTo(firstView.mas_bottom).offset(24);
            make.bottom.offset(-30);
        }];
    }
}

#pragma mark - Setter.
- (void)setTitleAttributes:(NSDictionary<NSString *,id> *)titleAttributes {
    if (![self.title isKindOfClass:[NSString class]] || !self.title.length) return;
    
    _titleAttributes = titleAttributes;
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_title attributes:_titleAttributes];
}

- (void)setMessageAttributes:(NSDictionary<NSString *,id> *)messageAttributes {
    if (![self.message isKindOfClass:[NSString class]] || !self.message.length) return;

    _messageAttributes = messageAttributes;
    _messageLabel.attributedText = [[NSAttributedString alloc] initWithString:_message attributes:_messageAttributes];
}

@end