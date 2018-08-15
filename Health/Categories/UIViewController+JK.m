//
//  UIViewController+JK.m
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

#import "UIViewController+JK.h"

#import <objc/runtime.h>

#import "BaiduMobStat.h"

static inline void jk_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(theClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(theClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIViewController (JK)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        jk_swizzleSelector(class, @selector(viewDidLoad), @selector(jk_viewDidLoad));
        jk_swizzleSelector(class, @selector(viewDidAppear:), @selector(jk_viewDidAppear:));
        jk_swizzleSelector(class, @selector(viewDidDisappear:), @selector(jk_viewDidDisappear:));
    });
}

- (void)jk_viewDidLoad {
    [self jk_viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem.title = @"";
}

- (void)jk_viewDidAppear:(BOOL)animated {
    [self jk_viewDidAppear:animated];
    
    
}

- (void)jk_viewDidDisappear:(BOOL)animated {
    [self jk_viewDidDisappear:animated];
    
    
}

@end
