//
//  NotifiViewController.m
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import "NotifiViewController.h"
#import "ZAlert.h"
#import <UserNotifications/UserNotifications.h>

@interface NotifiViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *button;


@end

@implementation NotifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.button];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    [self getPendingNotifi];
}

- (void)getPendingNotifi {
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        
        for (UNNotificationRequest *request in requests) {
            
            // [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[request.identifier]]; // 删除所有通知
            
            if ([request.identifier isEqualToString: [NSString stringWithFormat:@"%ld", self.identifier]]) {
                self.button.selected = YES;
                self.datePicker.transform = CGAffineTransformMakeTranslation(0, 0);
                self.datePicker.alpha = 1;
            }
        }
    }];
}

- (void)save {
    
    if (!self.button.selected) {
        NSLog(@"请选择");
        return;
    } else {
     
        if (self.datePicker.date.timeIntervalSinceNow <= [NSDate date].timeIntervalSinceNow) {
            NSLog(@"不能设置为过去的时间");
        } else {
            // 设置闹钟
            [self setNotifications];
        }
    }
}

- (void)cancePendingNotifi {
    
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        
        for (UNNotificationRequest *request in requests) {
            
            if ([request.identifier isEqualToString:[NSString stringWithFormat:@"%ld",self.identifier]]) {
                
                [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[[NSString stringWithFormat:@"%ld",self.identifier]]];
                
                [ZAlert showAlertWithMessage:@"移除成功" block:nil];
            }
        }
    }];
}

- (void)clickButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    CGAffineTransform transform;
    CGFloat alpha;
    
    if (sender.selected) {
        transform = CGAffineTransformMakeTranslation(0, 0);
        alpha = 1;
    } else {
        
        transform = CGAffineTransformMakeTranslation(0, -200);
        alpha = 0;
        
        // 取消
        [self cancePendingNotifi];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.transform = transform;
        self.datePicker.alpha = alpha;
    } completion:^(BOOL finished) {
        self.datePicker.hidden = !sender.selected;
    }];
}


- (void)setNotifications {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = self.titles;
    content.body = [NSString stringWithFormat:@"%@",self.datePicker.date];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @([UIApplication sharedApplication].applicationIconBadgeNumber + 1);
    
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.datePicker.date];
    NSLog(@"dateComponent--- %@", dateComponent);
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponent repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%ld",self.identifier] content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"闹钟设置成功");
    }];
}


- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(20, 80, 200, 44);
        [_button setTitle:@"按  钮" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.bounds), 300)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.transform = CGAffineTransformMakeTranslation(0, -200);
        _datePicker.alpha = 0;
    }
    return _datePicker;
}

@end
