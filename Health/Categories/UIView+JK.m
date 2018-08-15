//
//  UIView+JK.m
//  Health
//
//  Created by Weichen Jiang on 8/10/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

#import "UIView+JK.h"

#import <objc/runtime.h>

@implementation UIView (JK)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(jk_layoutSubviews);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)jk_layoutSubviews {
    [self jk_layoutSubviews];
    
    [self.loadingView setFrame:self.bounds];
}

- (BOOL)loading {
    return [(NSNumber *)objc_getAssociatedObject(self, @selector(loading)) boolValue];
}

- (void)setLoading:(BOOL)loading {
    objc_setAssociatedObject(self, @selector(loading), @(loading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (loading) {
        if (!self.loadingView) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false;
            activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            
            [view addSubview:activityIndicatorView];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:20.0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:20.0]];
            [activityIndicatorView startAnimating];
            
            [self setLoadingView:view];
        }
        
        [self addSubview:self.loadingView];
        [self bringSubviewToFront:self.loadingView];
    } else {
        [self.loadingView removeFromSuperview];
    }
}

- (UIView *)loadingView {
    return objc_getAssociatedObject(self, @selector(loadingView));
}
    
- (void)setLoadingView:(UIView *)loadingView {
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
