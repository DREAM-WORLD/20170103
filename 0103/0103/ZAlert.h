//
//  ZAlert.h
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZAlert : NSObject

+ (void)showAlertWithMessage:(NSString *)message block:(void (^)(void))block;

@end
