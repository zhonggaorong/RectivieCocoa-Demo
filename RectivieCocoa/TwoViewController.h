//
//  TwoViewController.h
//  RectivieCocoa
//
//  Created by 张国荣 on 16/5/18.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) RACSubject *myDelegate;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;

- (IBAction)goBackAction:(id)sender;

@end
