//
//  AlertView.m
//  Test3.0
//
//  Created by YuanGu on 2017/10/30.
//  Copyright © 2017年 YuanGu. All rights reserved.
//

#import "AlertView.h"

#pragma mark - Private
/**
 *  取消按钮默认标题
 */
static NSString *const CancelButtonTitleDefault = @"确定";
/**
 *  toast默认展示时间，当设置为0时，用该值
 */
static NSTimeInterval const ToastShowDurationDefault = 1.0f;
/**
 *  alertView子视图key
 */
static NSString *const AlertViewAccessoryViewKey = @"accessoryView";


#pragma mark - Public
//1.常规alert
void showAlertTwoButton(NSString *title, NSString *message, NSString *cancelButtonTitle, AlertClickBlock cancelBlock, NSString *otherButtonTitle, AlertClickBlock otherBlock)
{
    getSafeMainQueue(^{
        [AlertView showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle cancelButtonBlock:cancelBlock otherButtonBlock:otherBlock];
    });
}
void showAlertOneButton(NSString *title, NSString *message, NSString *cancelButtonTitle, AlertClickBlock cancelBlock)
{
    showAlertTwoButton(title, message, cancelButtonTitle, cancelBlock, nil, NULL);
}
void showAlertTitle(NSString *title)
{
    showAlertTwoButton(title, nil, CancelButtonTitleDefault, NULL, nil, NULL);
}
void showAlertMessage(NSString *message)
{
    showAlertTwoButton(@"", message, CancelButtonTitleDefault, NULL, nil, NULL);
}
void showAlertTitleMessage(NSString *title, NSString *message)
{
    showAlertTwoButton(title, message, CancelButtonTitleDefault, NULL, nil, NULL);
}

//2.无按钮toast
void showToastTitleMessageDismiss(NSString *title, NSString *message, NSTimeInterval duration, AlertClickBlock dismissCompletion)
{
    getSafeMainQueue(^{
        [AlertView showToastViewWithTitle:title message:message duration:duration dismissCompletion:dismissCompletion];
    });
}
void showToastTitleDismiss(NSString *title, NSTimeInterval duration, AlertClickBlock dismissCompletion)
{
    showToastTitleMessageDismiss(title, nil, duration, dismissCompletion);
}
void showToastMessageDismiss(NSString *message, NSTimeInterval duration, AlertClickBlock dismissCompletion)
{
    showToastTitleMessageDismiss(@"", message, duration, dismissCompletion);
}
void showToastTitle(NSString *title, NSTimeInterval duration)
{
    showToastTitleMessageDismiss(title, nil, duration, NULL);
}
void showToastMessage(NSString *message, NSTimeInterval duration)
{
    showToastTitleMessageDismiss(@"", message, duration, NULL);
}

//3.文字HUD
void showTextHUDTitleMessage(NSString *title, NSString *message)
{
    getSafeMainQueue(^{
        [AlertView showTextHUDWithTitle:title message:message];
    });
}
void showTextHUDTitle(NSString *title)
{
    showTextHUDTitleMessage(title, nil);
}
void showTextHUDMessage(NSString *message)
{
    showTextHUDTitleMessage(@"", message);
}

//4.loadHUD
void showLoadingHUDTitleMessage(NSString *title, NSString *message)
{
    getSafeMainQueue(^{
        [AlertView showLoadingHUDWithTitle:title message:message];
    });
}
void showLoadingHUDTitle(NSString *title)
{
    showLoadingHUDTitleMessage(title, nil);
}
void showLoadingHUDMessage(NSString *message)
{
    showLoadingHUDTitleMessage(@"", message);
}

//5.progressHUD
void showProgressHUDTitleMessage(NSString *title, NSString *message)
{
    getSafeMainQueue(^{
        [AlertView showProgressHUDWithTitle:title message:message];
    });
}
void showProgressHUDTitle(NSString *title)
{
    showProgressHUDTitleMessage(title, nil);
}
void showProgressHUDMessage(NSString *message)
{
    showProgressHUDTitleMessage(@"", message);
}
void setHUDProgress(float progress)
{
    [AlertView setHUDProgress:progress];
}

//6.HUD公用
//成功状态
void setHUDSuccessTitleMessage(NSString *title, NSString *message)
{
    getSafeMainQueue(^{
        [AlertView setHUDSuccessStateWithTitle:title message:message];
    });
}
void setHUDSuccessTitle(NSString *title)
{
    setHUDSuccessTitleMessage(title, nil);
}
void setHUDSuccessMessage(NSString *message)
{
    setHUDSuccessTitleMessage(@"", message);
}
//失败状态
void setHUDFailTitleMessage(NSString *title, NSString *message)
{
    getSafeMainQueue(^{
        [AlertView setHUDFailStateWithTitle:title message:message];
    });
}
void setHUDFailTitle(NSString *title)
{
    setHUDFailTitleMessage(title, nil);
}
void setHUDFailMessage(NSString *message)
{
    setHUDFailTitleMessage(@"", message);
}
//关闭HUD
void dismissHUD()
{
    getSafeMainQueue(^{
        [AlertView dismissHUD];
    });
}


#pragma mark - define
/**
 *  AlertType
 */
typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeNormal,
    AlertTypeToast,
    AlertTypeHUD
};

/**
 *  AlertHUDType
 */
typedef NS_ENUM(NSInteger, AlertHUDType) {
    AlertHUDTypeTextOnly,
    AlertHUDTypeLoading,
    AlertHUDTypeProgress
};


@interface AlertView () <UIAlertViewDelegate>
//block
@property (nonatomic, copy) AlertClickBlock buttonClickBlock;
@property (nonatomic, copy) AlertClickBlock completionBlock;
//type
@property (nonatomic, assign) AlertType alertType;
@property (nonatomic, assign) AlertHUDType alertHUDType;
//HUD附件
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIProgressView *progressView;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

@end

@implementation AlertView

#pragma mark - Init
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle, ...
{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    if (!self) return nil;
    
    return self;
}

#pragma mark - shared
static AlertView *_commonHUD = nil;
+ (instancetype)sharedCommonHUDWithHUDType:(AlertHUDType)HUDType
{
    if (_commonHUD == nil)
    {
        _commonHUD = [[AlertView alloc] initWithTitle:nil message:nil cancelButtonTitle:nil otherButtonTitle:nil];
        //
        _commonHUD.alertType = AlertTypeHUD;
        _commonHUD.alertHUDType = HUDType;
        
        switch (HUDType)
        {
            case AlertHUDTypeTextOnly:
                break;
            case AlertHUDTypeLoading:
            {
                //添加指示器
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                indicatorView.color = [UIColor blackColor];
                [indicatorView startAnimating];
                _commonHUD.indicatorView = indicatorView;
                //强制添加子视图
                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
                {
                    [_commonHUD setValue:indicatorView forKey:AlertViewAccessoryViewKey];
                }
                else
                {
                    [_commonHUD addSubview:indicatorView];
                }
                break;
            }
            case AlertHUDTypeProgress:
            {
                //添加进度条
                UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                progressView.progressTintColor = [UIColor blackColor];
                progressView.progress = 0.0;
                _commonHUD.progressView = progressView;
                //强制添加子视图
                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
                {
                    [_commonHUD setValue:progressView forKey:AlertViewAccessoryViewKey];
                }
                else
                {
                    [_commonHUD addSubview:progressView];
                }
                break;
            }
        }
    }
    return _commonHUD;
}
+ (AlertView *)sharedCommonHUD
{
    return _commonHUD;
}
+ (void)clearCommonHUD
{
    _commonHUD = nil;
}

//重写setValue:forUndefinedKey:方法，处理不存在的key赋值，防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key: %@ 不存在", key);
}
- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"value: %@ 不存在", key);
    return nil;
}


#pragma mark - Methods
//1.常规alert
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle cancelButtonBlock:(AlertClickBlock)cancelBlock otherButtonBlock:(AlertClickBlock)otherBlock
{
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    AlertView *alertView = [[AlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle, nil];
    
    alertView.alertType = AlertTypeNormal;
    
    alertView.buttonClickBlock = ^(NSInteger buttonIndex){
        if (buttonIndex == 0)
        {
            if (cancelBlock) {
                cancelBlock(buttonIndex);
            }
        }
        else if (buttonIndex == 1)
        {
            if (otherBlock) {
                otherBlock(buttonIndex);
            }
        }
    };
    
    [alertView show];
}
//不定按钮
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle buttonIndexBlock:(AlertClickBlock)buttonIndexBlock otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    AlertView *alertView = [[AlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:nil];
    
    alertView.alertType = AlertTypeNormal;
    alertView.buttonClickBlock = buttonIndexBlock;
    
    if (otherButtonTitles)
    {
        va_list args;//定义一个指向个数可变的参数列表指针
        va_start(args, otherButtonTitles);//得到第一个可变参数地址
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *))
        {
            [alertView addButtonWithTitle:arg];
        }
        va_end(args);//置空指针
    }
    
    [alertView show];
}

//2.无按钮toast
+ (void)showToastViewWithTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration dismissCompletion:(AlertClickBlock)dismissCompletion
{
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    AlertView *toastView = [[AlertView alloc] initWithTitle:title message:message cancelButtonTitle:nil otherButtonTitle:nil];
    
    toastView.alertType = AlertTypeToast;
    
    toastView.completionBlock = ^(NSInteger buttonIndex){
        if (buttonIndex == 0)
        {
            if (dismissCompletion) {
                dismissCompletion(buttonIndex);
            }
        }
    };
    
    [toastView show];
    
    duration = duration > 0 ? duration : ToastShowDurationDefault;
    [toastView performSelector:@selector(dismissToastView:) withObject:toastView afterDelay:duration];
}

- (void)dismissToastView:(UIAlertView *)toastView
{
    [toastView dismissWithClickedButtonIndex:0 animated:YES];
}

//3.文字HUD
+ (void)showTextHUDWithTitle:(NSString *)title message:(NSString *)message
{
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    AlertView *textHUD = [AlertView sharedCommonHUDWithHUDType:AlertHUDTypeTextOnly];
    
    textHUD.title = title;
    textHUD.message = message;
    //    textHUD.delegate = nil;
    
    [textHUD show];
}

//4.loadHUD
+ (void)showLoadingHUDWithTitle:(NSString *)title message:(NSString *)message
{
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    AlertView *loadingHUD = [AlertView sharedCommonHUDWithHUDType:AlertHUDTypeLoading];
    
    loadingHUD.title = title;
    loadingHUD.message = message;
    
    [loadingHUD show];
}

//5.progressHUD
+ (void)showProgressHUDWithTitle:(NSString *)title message:(NSString *)message
{
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    AlertView *alertHUD = [AlertView sharedCommonHUDWithHUDType:AlertHUDTypeProgress];
    
    alertHUD.title = title;
    alertHUD.message = message;
    
    [alertHUD show];
}
+ (void)setHUDProgress:(float)progress
{
    AlertView *alertHUD = [AlertView sharedCommonHUD];
    [alertHUD.progressView setProgress:progress animated:YES];
    
    if (progress >= 1.0) {
        [alertHUD.progressView setProgress:1];
        //        [alertHUD dismissWithClickedButtonIndex:0 animated:YES];
    }
}

//6.HUD公用
+ (void)setHUDSuccessStateWithTitle:(NSString *)title message:(NSString *)message
{
    AlertView *alertHUD = [AlertView sharedCommonHUD];
    alertHUD.title = title;
    alertHUD.message = message;
    
    switch (alertHUD.alertHUDType)
    {
        case AlertHUDTypeTextOnly:
            break;
        case AlertHUDTypeLoading:
        {
            [alertHUD.indicatorView stopAnimating];
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [alertHUD setValue:nil forKey:AlertViewAccessoryViewKey];
            }
            else
            {
                [alertHUD.indicatorView removeFromSuperview];
            }
            alertHUD.indicatorView = nil;
            break;
        }
        case AlertHUDTypeProgress:
        {
            [alertHUD.progressView setProgress:1 animated:YES];
            break;
        }
    }
}
+ (void)setHUDFailStateWithTitle:(NSString *)title message:(NSString *)message
{
    AlertView *alertHUD = [AlertView sharedCommonHUD];
    alertHUD.title = title;
    alertHUD.message = message;
    
    switch (alertHUD.alertHUDType)
    {
        case AlertHUDTypeTextOnly:
            break;
        case AlertHUDTypeLoading:
        {
            [alertHUD.indicatorView stopAnimating];
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [alertHUD setValue:nil forKey:AlertViewAccessoryViewKey];
            }
            else
            {
                [alertHUD.indicatorView removeFromSuperview];
            }
            alertHUD.indicatorView = nil;
            break;
        }
        case AlertHUDTypeProgress:
        {
            [alertHUD.progressView setProgress:0 animated:YES];
            break;
        }
    }
}
+ (void)dismissHUD
{
    AlertView *alertHUD = [AlertView sharedCommonHUD];
    switch (alertHUD.alertHUDType)
    {
        case AlertHUDTypeTextOnly:
            break;
        case AlertHUDTypeLoading:
        {
            [alertHUD.indicatorView stopAnimating];
            alertHUD.indicatorView = nil;
            break;
        }
        case AlertHUDTypeProgress:
            break;
    }
    [alertHUD dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(buttonIndex);
    }
    self.buttonClickBlock = NULL;//解除闭环
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.completionBlock) {
        self.completionBlock(buttonIndex);
    }
    self.completionBlock = NULL;//解除闭环
    
    switch (self.alertType)
    {
        case AlertTypeNormal:
            break;
            
        case AlertTypeToast:
        {
            //清理performSelector，防止意外情况下的内存泄漏
            [NSObject cancelPreviousPerformRequestsWithTarget:alertView selector:@selector(dismissToastView:) object:alertView];
            break;
        }
        case AlertTypeHUD:
        {
            //清理static
            [AlertView clearCommonHUD];
            break;
        }
    }
}

@end

