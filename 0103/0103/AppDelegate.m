//
//  AppDelegate.m
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZAlert.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    
    // 注册本地推送通知
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert + UNAuthorizationOptionBadge + UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // 注册成功
    }];
    // 设置代理
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    return YES;
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"前台");
    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);
    
    [self alertWithNotifyRequest:notification.request];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"后台");
    completionHandler();
    
    [self alertWithNotifyRequest:response.notification.request];
}

- (void)alertWithNotifyRequest:(UNNotificationRequest *)notifyRequest {
    
     NSString *str = [NSString stringWithFormat:@"%@, %@", notifyRequest.content.title, notifyRequest.content.body];
    
    [ZAlert showAlertWithMessage:str block:^{
        NSLog(@"确定");
        ViewController *vcs =  self.window.rootViewController.childViewControllers.firstObject;
        if (vcs.notifiBlock) {
            vcs.notifiBlock();
        }
        // 清空提示数值
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
    // 点APP图标进来
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
       
        if (notifications.count != 0) {
            [self alertWithNotifyRequest:notifications.firstObject.request];
        }
    }];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
