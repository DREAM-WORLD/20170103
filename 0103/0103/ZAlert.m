//
//  ZAlert.m
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import "ZAlert.h"

@implementation ZAlert

+ (void)showAlertWithMessage:(NSString *)message block:(void (^)(void))block {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
 
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
