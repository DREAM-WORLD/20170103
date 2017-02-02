//
//  ViewController.h
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NotificationBlock)();

@interface ViewController : UIViewController

@property (nonatomic, copy) NotificationBlock notifiBlock;

@end

