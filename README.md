# evaluate app
对于iOS开发者来说，我们的App内如果需要有“关于我们”或者“给xx好评”等类似的设计，就需要实现App的评分功能。我们在这里总结两种实现思路。如果小伙伴们有其他实现思路不妨提出来大家一起学习，一起完善该功能。

## 关于StoreKit
首先实现该功能，得益于苹果的原生框架StoreKit，对于StoreKit功能官方文档是这么说的：
* Embed a store in your app. Process financial transactions associated with the purchase of content and services.

* The Store Kit framework provides classes that allow an app to request payment from a user for additional functionality or content that your application delivers.

在我们的应用程序里面嵌入App Store，实现App Store的相关功能，那这样的话对于iOS程序来说在不用打开App Store的情况下，就能进行App Store一下相关的操作，比如下载App、评分、查看App详情等，具体的学习大家可以看文档，看完档感觉StoreKit功能会很强大，而且还会完善，个人感觉以后会被广泛使用在App中。

## 直接打开手机的App Store并跳转
```
//这里有两个宏，一个是AppId，一个是苹果商店地址
#define kAppId @"xxxxxx"
#define kAppleAppStoreUrlAddress [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xxxx/id%@?l=en&mt=8",kAppId]

if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kAppleAppStoreUrlAddress]])
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppleAppStoreUrlAddress]];
}
```
这种直接跳转至App Store是在自己的App内调起并打开了手机的App Store。

## 在自己的App中，模态弹出一个App Store的页面
### 实现方法如下
```
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
```
有个代理方法是弹出视图后点击“取消”按钮的回调，在这里我们实现该代理，并在里面做了dismiss操作
```
#pragma mark SKStoreProductViewControllerDelegate
//取消按钮回调代理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //点击了取消按钮，dissmiss
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
```
如果不在这里面做dismiss操作，返回之后返回不到原来的界面，会返回位置界面，present和dismiss一对。
### SKStoreProductViewController
* A SKStoreProductViewController object presents a store that allows the user to purchase other media from the App Store. For example, your app might display the store to allow the user to purchase another app.
...

## 直接在自己的App中评分
### 实现方法如下
```
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
```
### SKStoreReviewController
* Controls the process of requesting App Store ratings and reviews from users.

* Use the requestReview() method to indicate when it makes sense to ask the user for ratings and review within your app.

请求App Store评分和评论的类，通过调用+ (void)requestReview方法，发起评分请求。

## demo地址
demo地址: <https://github.com/Mexiang/evaluate>




