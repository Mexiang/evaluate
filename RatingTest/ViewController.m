//
//  ViewController.m
//  RatingTest
//
//  Created by Dry on 2017/7/21.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>

#define kAppId @""
#define kAppleAppStoreUrlAddress [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/..../id%@?l=en&mt=8",kAppId]

@interface ViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     * 注意：用从demo的时别忘了修改两个宏，用你自己的App id和App Store的地址
     */
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width/2-80, 100, 160, 44);
    [button setTitle:[NSString stringWithFormat:@"打开App Store"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor brownColor]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonAction:(UIButton *)sender {
    [self evaluateInApp];
    
//    [self evaluate];
}

#pragma mark 
#pragma mark --1
- (void)evaluateInApp {
    if ([SKStoreReviewController respondsToSelector:@selector(requestReview)])
    {   // iOS10.3+ 直接在App内弹出评分框
        [SKStoreReviewController requestReview];
    }
    else
    {   // <iOS10.3 跳转AppStore的评论页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppleAppStoreUrlAddress]];
    }
}

#pragma mark
#pragma mark --2
// 在App内加载出App Store，但未直接跳转至评论页
- (void)evaluate {
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理指针
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:kAppId}      completionBlock:^(BOOL result, NSError *error){
        
         if(error){
             NSLog(@"error: %@ userInfo: %@",error,error.userInfo);
         }else{
             //模态弹出App Store页面
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }];
         }
     }];
}
#pragma mark SKStoreProductViewControllerDelegate
//取消按钮回调代理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //点击了取消按钮，dissmiss
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
