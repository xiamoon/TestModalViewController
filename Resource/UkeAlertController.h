//
//  UkeAlertController.h
//  TestModalViewController
//
//  Created by liqian on 2018/12/17.
//  Copyright © 2018 liqian. All rights reserved.
//

#import "UkePopUpViewController.h"
#import "NSParagraphStyle+Shortcut.h"
#import "UkeAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkeAlertController : UkePopUpViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)addAction:(UkeAlertAction *)action;
@property (nonatomic, readonly) NSArray<UkeAlertAction *> *actions;



/**
 通过自定义headerView创建，属于父类重载方法。注意：用UkeAlertController和UkePopUpViewController的调用效果不同
 
 @warning 对于UkeAlertController来说，这个view将作为headerView取代由title和message生成的UkeAlertHeaderView
 @warning 对于UkePopUpViewController来说，这个view即为整个contentView
 @warning 此处添加的View是headerView，不是整个contentView，所以可以继续添加action
 */
+ (instancetype)alertControllerWithCustomizeView:(nullable UIView *)view
                                preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 添加自定义headerView

 @param view 同上
 */
- (void)addCustomizeView:(nullable UIView *)view;


//! 中间内容区宽度。如果是alertView，默认270；如果是actionSheet，默认为屏幕宽度-8-8，跟系统保持一致
@property (nonatomic, assign) CGFloat contentWidth;

//! actionSheet的cancelButton距离上边内容的间距，默认为8，跟系统保持一致
@property (nonatomic, assign) CGFloat sheetCancelButtonMarginTop;

//! actionSheet整体内容距离屏幕底部距离，默认为8，跟系统保持一致
@property (nonatomic, assign) CGFloat sheetContentMarginBottom;

//! 标题相关属性
@property(nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;
//! message相关属性
@property(nonatomic, strong) NSDictionary<NSString *, id> *messageAttributes;
//! 按钮相关属性
// 按钮高度。alert默认44.0，sheet默认57.0，跟系统保持一致
@property (nonatomic, assign) CGFloat actionButtonHeight;
@property(nonatomic, strong) NSDictionary<NSString *, id> *defaultButtonAttributes;
@property(nonatomic, strong) NSDictionary<NSString *, id> *cancelButtonAttributes;
@property(nonatomic, strong) NSDictionary<NSString *, id> *destructiveButtonAttributes;

@end

NS_ASSUME_NONNULL_END
