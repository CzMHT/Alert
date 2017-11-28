//
//  AlertController.h
//  Test3.0
//
//  Created by YuanGu on 2017/10/30.
//  Copyright © 2017年 YuanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertController;

/**
 AlertController: alertAction配置链
 
 @param title 标题
 @return      AlertController对象
 */
typedef AlertController * _Nonnull (^AlertActionTitle)(NSString * _Nullable title);

/**
 AlertController: alert按钮执行回调
 
 @param buttonIndex 按钮index(根据添加action的顺序)
 @param action      UIAlertAction对象
 @param alertSelf   本类对象
 */
typedef void (^AlertActionBlock)(NSInteger buttonIndex, UIAlertAction * _Nullable action, AlertController * _Nonnull alertSelf);


NS_CLASS_AVAILABLE_IOS(8_0) @interface AlertController : UIAlertController

/**
 JXTAlertController: 禁用alert弹出动画，默认执行系统的默认弹出动画
 */
- (void)alertAnimateDisabled;

/**
 AlertController: alert弹出后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidShown)(void);

/**
 AlertController: alert关闭后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidDismiss)(void);

/**
 AlertController: 设置toast模式展示时间：如果alert未添加任何按钮，将会以toast样式展示，这里设置展示时间，默认1s
 */
@property (nonatomic, assign) NSTimeInterval toastStyleDuration; //deafult alertShowDurationDefault = 2s

/**
 AlertController: 链式构造alert视图按钮，添加一个alertAction按钮，默认样式，参数为标题
 
 @return AlertController对象
 */

- (AlertActionTitle _Nullable )addActionDefaultTitle;

/**
 AlertController: 链式构造alert视图按钮，添加一个alertAction按钮，取消样式，参数为标题(warning:一个alert该样式只能添加一次!!!)
 
 @return AlertController对象
 */
- (AlertActionTitle _Nullable )addActionCancelTitle;

/**
 AlertController: 链式构造alert视图按钮，添加一个alertAction按钮，警告样式，参数为标题
 
 @return AlertController对象
 */
- (AlertActionTitle _Nullable )addActionDestructiveTitle;

@end


typedef void(^AlertAppearanceProcess)(AlertController * _Nullable alertMaker);

@interface UIViewController (JXTAlertController)

/**
 AlertController: show-alert(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess alert配置过程
 @param actionBlock       alert点击响应回调
 */
- (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
         appearanceProcess:(AlertAppearanceProcess _Nullable )appearanceProcess
              actionsBlock:(nullable AlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

/**
 AlertController: show-actionSheet(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess actionSheet配置过程
 @param actionBlock       actionSheet点击响应回调
 */
- (void)showActionSheetWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
               appearanceProcess:(AlertAppearanceProcess _Nullable )appearanceProcess
                    actionsBlock:(nullable AlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);


@end


