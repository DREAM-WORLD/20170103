//
//  NotifiModel.h
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifiModel : NSObject

#pragma mark - Model解决重用问题

//@property (nonatomic, assign) BOOL isImg;
@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *string;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (NSArray <NotifiModel *>*)modelWithArr:(NSArray *)arr;

@end
