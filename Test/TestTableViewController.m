//
//  TestTableViewController.m
//  Test
//
//  Created by surio on 17/6/16.
//  Copyright © 2017年 surio. All rights reserved.
//

#import "TestTableViewController.h"
#import "ShowIndexView.h"
#import <objc/runtime.h>

@interface TestTableViewController ()

{
    NSDictionary *indexAlphaDic;
    NSArray *alphaArr;
    ShowIndexView *showIndexView;
    NSInteger indexPathSection;
}

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self initSearchDic];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
    showIndexView  = [[[NSBundle mainBundle]  loadNibNamed:@"ShowIndexView" owner:self options:nil] lastObject];
    showIndexView.hidden = YES;
    showIndexView.center = window.center;
    [window addSubview:showIndexView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@",self.view.subviews);
    UIView *indexView = [self.view.subviews lastObject];
    
    NSArray *actionArr = [indexView valueForKey:@"targetActions"];
    for (UIControl *action in actionArr) {
            [action setValue:self forKey:@"target"];
    }
}

//仅当SDKiOS10以上生效（该方法仅当10以上存在）
- (void)_sectionIndexTouchesBegan:(id)Id {
    [self showIndexView:Id isHidden:NO];
}

//触摸索引栏
- (void)_sectionIndexChanged:(id)Id {
    [self showIndexView:Id isHidden:NO];
}
//触摸索引栏结束
- (void)_sectionIndexTouchesEnded:(id)Id {

    [self showIndexView:Id isHidden:YES];
}
//显示或隐藏 索引视图
- (void)showIndexView:(id)Id isHidden:(BOOL)hidden{
   
    if (hidden) {
        showIndexView.hidden = YES;
        NSLog(@"A");

    } else {
        showIndexView.hidden = NO;
        NSInteger section = [[Id valueForKey:@"selectedSection"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:nil];
        showIndexView.contentTitle.text = alphaArr[section];
        NSLog(@"B");
    }
}

//设置索引字母
- (void)initSearchDic {
    
    NSString *alphaStr = @"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
    alphaArr = [alphaStr componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < 26; i++) {
        [dic setValue:alphaArr[i] forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    indexAlphaDic = [NSDictionary dictionaryWithDictionary:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return alphaArr;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *alpha = [indexAlphaDic valueForKey:[NSString stringWithFormat:@"%ld",section]];
    return alpha;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


@end
