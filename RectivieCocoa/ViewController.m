//
//  ViewController.m
//  RectivieCocoa
//
//  Created by 张国荣 on 16/5/12.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TwoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self RACSignalText];
    [self RACSubjectText]; // 充当代理角色
}

-(void)RACSignalText{
    
    RACSignal *signl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{ //自动销毁
            NSLog(@"销毁了呀，哈哈");
        }];
    }];
    
    [signl subscribeNext:^(id x) { //订阅信号，才激活信号。
        NSLog(@"%@",x);
    }];
}

//RACSubject
-(void)RACSubjectText{
    RACSubject *sub = [RACSubject subject];
    [sub subscribeNext:^(id x) {
        NSLog(@"第一个接收到的值 %@",x);
        NSInteger d = [x integerValue];
        d++;
    }];
    
    [sub subscribeNext:^(id x) {
         NSLog(@"第二个接收到的值 %@",x);
    }];
    [sub sendNext:@"100"];
    
    RACReplaySubject *sub2 = [RACReplaySubject replaySubjectWithCapacity:3];
    [sub2 sendNext:@"重复1"];
    [sub2 sendNext:@"重复2"];
    [sub2 sendNext:@"重复3"];
    
    [sub2 subscribeNext:^(id x) {
         NSLog(@"1重复 %@接收到的值",x);
    }];
    
    [sub2 subscribeNext:^(id x) {
         NSLog(@"2重复 %@接收到的值",x);
    }];
    
    [sub2 subscribeNext:^(id x) {
         NSLog(@"3重复 %@接收到的值",x);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myAction:(id)sender {
    
    TwoViewController *two = [[TwoViewController alloc]initWithNibName:@"TwoViewControler" bundle:nil];
    two.myDelegate = [RACSubject subject];
    [two.myDelegate subscribeNext:^(id x) {
        _myLabel.text = x;
    }];
    [self.navigationController pushViewController:two animated:YES];
}

- (IBAction)myTwoAction:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TwoViewController *VC = [sb instantiateViewControllerWithIdentifier:@"TwoViewController"];
    
    VC.myDelegate = [RACSubject subject];
    [VC.myDelegate subscribeNext:^(id x) {
        _myLabel.text = x;
        NSLog(@"---%@",x);
    }];
    [self.navigationController pushViewController:VC animated:YES];
    
}
@end
