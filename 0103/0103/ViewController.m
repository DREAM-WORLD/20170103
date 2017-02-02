//
//  ViewController.m
//  0103
//
//  Created by Zhang on 2017/1/30.
//  Copyright © 2017年 ZhangJinHua. All rights reserved.
//

#import "ViewController.h"
#import "NotifiModel.h"
#import "NotifiViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NotifiModel *>*dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    self.notifiBlock = ^ () {
        [weakSelf initializeData];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeData];
}


- (void)initializeData {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        NSString *str = [NSString stringWithFormat:@"代码千行过：%d",i];
        [arr addObject:@{@"string":str, @"imgStr":@""}];
    }
    self.dataSource = [NotifiModel modelWithArr:arr];
    [self getPendingNotifiy];
}

#warning 重用、通知响了后去除图标

- (void)getPendingNotifiy {
    // 获取全部通知
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        
        [requests enumerateObjectsUsingBlock:^(UNNotificationRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NotifiModel *model = self.dataSource[[request.identifier integerValue]];
            
            model.imgStr = @"铃铛-蓝色";
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NotifiModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.string;
    cell.imageView.image = [UIImage imageNamed:model.imgStr];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint location = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        
        
        UIMenuItem *itemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(cellCopy:)];
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(cellDelete:)];
 
        UIMenuController *meun = [UIMenuController sharedMenuController];
        [meun setMenuItems:@[itemCopy, itemDelete]];
        [meun setTargetRect:cell.frame inView:self.tableView];
        [meun setMenuVisible:YES animated:YES];
    }
}
- (void)cellCopy:(id)sender {
    NSLog(@"copy");
}
- (void)cellDelete:(id)sender {
    NSLog(@"delete");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NotifiViewController *notifiVC = [[NotifiViewController alloc] init];
    notifiVC.titles = self.dataSource[indexPath.row].string;
    notifiVC.identifier = indexPath.row;
    [self.navigationController pushViewController:notifiVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
