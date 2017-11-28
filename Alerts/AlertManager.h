//
//  AlertManager.h
//  HUDCooldrive
//
//  Created by YuanGu on 2017/11/2.
//  Copyright © 2017年 YuanGu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* 处理 全程 弹窗逻辑 */

typedef void(^finishHandle)(void);
typedef void(^actionHandle)(UIAlertAction *action, NSUInteger index);
typedef void(^textActionHandle)(UIAlertAction *action ,UIAlertController *alertCtl ,NSUInteger index);
typedef void(^textFieldHandle)(UITextField *textField, NSUInteger index);

@interface AlertManager : NSObject

/**
 *  按钮--中间
 *
 *  @param title             提示标题
 *  @param message           提示信息
 *  @param textFieldNumber   输入框个数
 *  @param actionTitles      按钮标题，数组
 *  @param textFieldHandler  输入框响应事件
 *  @param actionHandler     按钮响应事件
 *  @param finishHandle      结束事件
 */
+ (void)alertTextFieldWithTitle:(NSString *)title
                        message:(NSString *)message
                textFieldNumber:(NSUInteger)textFieldNumber
                   actionTitles:(NSArray *)actionTitles
               textFieldHandler:(textFieldHandle)textFieldHandler
                  actionHandler:(textActionHandle)actionHandler
                   finishHandle:(finishHandle)finishHandle;

/**
 *  按钮--中间
 *
 *  @param title             提示标题
 *  @param message           提示信息
 *  @param actionTitles      按钮标题，数组
 *  @param actionHandler     按钮响应事件
 *  @param finishHandle      结束事件
 */
+ (void)alertActionWithTitle:(NSString *)title
                     message:(NSString *)message
                actionTitles:(NSArray *)actionTitles
               actionHandler:(actionHandle)actionHandler
                finishHandle:(finishHandle)finishHandle;

/**
 *  按钮--底部
 *
 *  @param title            提示标题
 *  @param message          提示信息
 *  @param actionTitles     按钮标题，数组
 *  @param actionHandler    按钮响应事件
 */
+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                actionTitles:(NSArray *)actionTitles
                actionHandle:(actionHandle)actionHandler;

@end
