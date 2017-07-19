//
//  SSModuleProtrol.h
//  AppMicroDistribution
//
//  Created by SunSet on 2017/6/19.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SSModuleProtrol <UIApplicationDelegate>

@optional
// 处理第三方链接跳转过来的url
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
// 统一处理收到远程推送的时候
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;



#pragma mark - <启动的时候处理>
// 模块预加载
- (void)loadModule;
// 模块卸载
- (void)unloadModule;


#pragma mark - <登录成功时候处理>
// 登录
- (void)login;
// 退出的时候处理
- (void)logout;



#pragma mark - <登录渲染完成 进入App主页>
// App渲染完成
- (void)onloadSuccess;


@end
