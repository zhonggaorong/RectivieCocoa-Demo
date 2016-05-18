//
//  TwoViewController.m
//  RectivieCocoa
//
//  Created by 张国荣 on 16/5/18.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()
{
    RACCommand *command;
}
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self arrayRac];
    [self CommondRac];
}


-(void)arrayRac{
    NSArray *array = @[@1,@2,@3,@4];
    
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    NSDictionary *dic = @{@"dsfd":@"name",@"sfsdfs":@"other"};
    [dic.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack( NSString *key,NSString *name) = x;
        NSLog(@"key = %@ value = %@",key,name);
        
    }];
}

-(void)CommondRac{
    
   command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       NSLog(@"执行命令 %@",input);
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           [subscriber sendNext:@"发送数据"];
           [subscriber sendCompleted];
           return nil;
       }];
   }];
    
    [command.executionSignals subscribeNext:^(id x) {
        NSLog(@"1接受到的数据 %@",x);
       [x subscribeNext:^(id x) {
           NSLog(@"2接受到的数据 %@",x);
       }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"最新的信号 %@",x);
    }];
    
      // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:0] subscribeNext:^(id x) {
        NSLog(@"跳跃第一次的信号 %@",x);
    }];
    
    [command execute:@"jj"];
    
    [command execute:@"cc"];
    
    
    
    RACScheduler *duler = [RACScheduler currentScheduler];
    [duler afterDelay:2 schedule:^{
        NSLog(@"开始 scheduler");
    }];
    
    [_myTextField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    
    [_myTextField.rac_willDeallocSignal subscribeNext:^(id x) {
        NSLog(@"销毁了呀");
    }];
    
    
//    _myTextField = nil;
    
    [[self.view rac_signalForSelector:@selector(goBackAction:)]subscribeNext:^(id x) {
        NSLog(@"被点击了哟");
    }];
    
    [[_myBtn rac_valuesForKeyPath:@"center" observer:NSKeyValueChangeNewKey
     ]subscribeNext:^(id x) {
        NSLog(@"center %@",x);
    }];
    
    _myBtn.center = CGPointMake(100, 100);
    
    
    [[_myBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        NSLog(@"被点击了哟");
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        NSLog(@"键盘弹出了呀");
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        NSLog(@"键盘消失了哟");
    }];
    
//    [[_myTextField.text rac_valuesForKeyPath:NSKeyValueChangeNewKey observer:nil]subscribeNext:^(id x) {
//        NSLog(@"嘻嘻嘻嘻嘻嘻嘻嘻嘻 %@",x);
//    }];
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"数据one"];
        return nil;
    }];
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"数据two"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(mydata:andData2:) withSignalsFromArray:@[request1,request2]];
}

-(void)mydata:(id)data andData2:(id)data2{
    NSLog(@"请求到的数据  %@   %@",data,data2);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBackAction:(id)sender {
    if (self.myDelegate) {
        [self.myDelegate sendNext:_myTextField.text];
    }
  //  [self.navigationController popViewControllerAnimated:YES];
}
@end
