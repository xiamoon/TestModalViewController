//
//  UkeAlertPresentingViewController.m
//  TestModalViewController
//
//  Created by liqian on 2019/1/14.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeAlertPresentingViewController.h"
#import "UkePopUpViewController.h"
#import "UkeAlertSingleton.h"

@interface UkeAlertPresentingViewController ()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UkePopUpViewController *currentPrentedVc;
@property (nonatomic, strong) NSMutableArray<UkePopUpViewController *> *alertHierarchStack;
@end

@implementation UkeAlertPresentingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIWindow *window = [[UIWindow alloc] init];
        window.backgroundColor = [UIColor clearColor];
        window.frame = [UIScreen mainScreen].bounds;
        window.windowLevel = UIWindowLevelAlert;
        _window = window;
        
        _alertHierarchStack = [NSMutableArray array];
    }
    return self;
}

- (void)presentPopUpViewController:(UkePopUpViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion {
    if (self.window.isHidden) {
        self.window.rootViewController = self;
        self.window.hidden = NO;
        [self.window makeKeyAndVisible];
    }
    
    if (_currentPrentedVc) {
        [_currentPrentedVc dismissViewControllerAnimated:NO completion:^{
            [self removeEqualVcFromStackWith:viewControllerToPresent];
            [self presentViewController:viewControllerToPresent animated:flag completion:^{
                self.currentPrentedVc = viewControllerToPresent;
                [self.alertHierarchStack addObject:self.currentPrentedVc];
                if (completion) {
                    completion();
                }
            }];
        }];
    }else {
        [self removeEqualVcFromStackWith:viewControllerToPresent];
        [self presentViewController:viewControllerToPresent animated:flag completion:^{
            self.currentPrentedVc = viewControllerToPresent;
            [self.alertHierarchStack addObject:self.currentPrentedVc];
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)ukePopUpViewControllerWillDismiss:(UkePopUpViewController *)popUpViewController {
    [_alertHierarchStack removeObject:popUpViewController];
}

- (void)ukePopUpViewControllerDidDismiss {
    _currentPrentedVc = nil;
    
    if (_alertHierarchStack.count == 0) {
        self.window.rootViewController = nil;
        self.window.hidden = YES;
        [[UkeAlertSingleton sharedInstance] destoryUkeAlertSingleton];
    }else {
        UkePopUpViewController *previousVc = _alertHierarchStack.lastObject;
        [self presentViewController:previousVc animated:YES completion:^{
            self.currentPrentedVc = previousVc;
        }];
    }
}

// 如果之前存在相同的popUpVc，则移除掉
- (void)removeEqualVcFromStackWith:(UkePopUpViewController *)popUpVcToPresent {
    if (self.alertHierarchStack.count != 0) {
        for (NSInteger i = self.alertHierarchStack.count-1; i >= 0; i --) {
            UkePopUpViewController *popUpVc = self.alertHierarchStack[i];
            if ([popUpVc.contentView isEqual:popUpVcToPresent.contentView]) {
                [self.alertHierarchStack removeObject:popUpVc];
                break;
            }
        }
    }
}

- (void)dealloc {
    self.window = nil;
    NSLog(@"UkeAlertPresentingViewController 销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
