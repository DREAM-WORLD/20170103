//
//  NotifiModel.m
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import "NotifiModel.h"

@implementation NotifiModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    if (self = [super init]) {
    
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

+ (NSArray<NotifiModel *> *)modelWithArr:(NSArray *)arr {
    NSMutableArray *muArr = [NSMutableArray array];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NotifiModel *model = [[NotifiModel alloc] initWithDic:obj];
        
        [muArr addObject:model];
        
    }];
    return muArr;
}

@end
