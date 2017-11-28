//
//  AlertManager.m
//  HUDCooldrive
//
//  Created by YuanGu on 2017/11/2.
//  Copyright © 2017年 YuanGu. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (void)alertTextFieldWithTitle:(NSString *)title
                        message:(NSString *)message
                textFieldNumber:(NSUInteger)textFieldNumber
                   actionTitles:(NSArray *)actionTitles
               textFieldHandler:(textFieldHandle)textFieldHandler
                  actionHandler:(textActionHandle)actionHandler
                   finishHandle:(finishHandle)finishHandle {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    if (textFieldNumber > 0) {
        
        for (int i = 0; i < textFieldNumber; i++) {
            [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textFieldHandler(textField ,i);
            }];
        }
    }
    NSInteger count = actionTitles.count;
    
    if (count > 0) {
        
        for (NSUInteger i = 0; i < count; i++) {
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action ,alertC ,i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC
                                                                                       animated:YES
                                                                                     completion:^{
        
                                                                                         finishHandle();
                                                                                     }];
}

+ (void)alertActionWithTitle:(NSString *)title
                     message:(NSString *)message
                actionTitles:(NSArray *)actionTitles
               actionHandler:(actionHandle)actionHandler
                finishHandle:(finishHandle)finishHandle{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    NSInteger count = actionTitles.count;
    
    if (count > 0) {
        
        for (NSUInteger i = 0; i < count; i++) {
        
            UIAlertAction *action;
            
            if (count == 1 || [actionTitles[i] isEqualToString:@"取消"]) {
                
                action = [UIAlertAction actionWithTitle:actionTitles[i]
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * action)  {
                    actionHandler(action, i);
                }];
            }else{
                action = [UIAlertAction actionWithTitle:actionTitles[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)  {
                    actionHandler(action, i);
                }];
            }
            
            [alertC addAction:action];
        }
    }

    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC
                                                                                       animated:YES
                                                                                     completion:^{
                                                                                         finishHandle();
                                                                                     }];
}

+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                actionTitles:(NSArray *)actionTitles
                actionHandle:(actionHandle)actionHandler {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (actionTitles.count > 0) {
        
        for (NSUInteger i = 0; i < actionTitles.count; i++) {
            
            UIAlertAction *action;
            
            if ([actionTitles[i] isEqualToString:@"取消"]) {
                
                action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)  {
                    
                    actionHandler(action, i);
                }];
            }else{
                action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                    
                    actionHandler(action, i);
                }];
            }

            [alertC addAction:action];
        }
    }
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

@end
