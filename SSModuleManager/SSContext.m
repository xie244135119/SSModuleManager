//
//  SSContext.m
//  SSModuleManager
//
//  Created by SunSet on 2017/10/30.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "SSContext.h"
#import "SSModule.h"
#import "SSService.h"

@interface SSContext()
{
    NSMutableDictionary<NSString *, id<SSModule>> *_allModuleDict;       //{moduleName: module}
    NSMutableDictionary<NSString *, id<SSService>> *_allServicesDict;    //{serviceName: service}
}
@end

@implementation SSContext

- (void)dealloc
{
    _allModuleDict = nil;
    _allServicesDict = nil;
}

+ (instancetype)shareContext
{
    static typeof(SSContext) *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SSContext alloc]init];
        _manager->_allModuleDict = [[NSMutableDictionary alloc]init];
        _manager->_allServicesDict = [[NSMutableDictionary alloc]init];
    });
    return _manager;
}


#pragma mark - module
//
- (void)registerModuleClass:(Class)moduleClass
{
    if (![moduleClass conformsToProtocol:@protocol(SSModule)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 模块不符合 SSModule 协议", NSStringFromClass(moduleClass)] userInfo:nil];
    }
    
    if ([[_allModuleDict allKeys] containsObject:NSStringFromClass(moduleClass)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 模块类已经注册", NSStringFromClass(moduleClass)] userInfo:nil];
    }
    
    NSString *key = NSStringFromClass(moduleClass);
    id<SSModule> module = [[moduleClass alloc]init];
    [_allModuleDict setObject:module forKey:key];
    
    //
    if([module respondsToSelector:@selector(loadModule)]) {
        [module loadModule];
    }
}

- (void)unregisterModuleClass:(Class)moduleClass
{
    NSString *key = NSStringFromClass(moduleClass);
    if ([[_allModuleDict allKeys] containsObject:key]) {
        id<SSModule> module = _allModuleDict[key];
        if([module respondsToSelector:@selector(unloadModule)]) {
            [module unloadModule];
        }
        [_allModuleDict removeObjectForKey:key];
    }
    
}

- (id<SSModule>)findModuleClass:(Class)moduleClass
{
    id<SSModule> sender = nil;
    for (sender in [_allModuleDict allValues]) {
        if ([sender isKindOfClass:moduleClass]) {
            break;
        }
    }
    return sender;
}

- (NSArray<id<SSModule>> *)modules
{
    return [_allModuleDict allValues];
}


#pragma mark - SSService

//
- (void)registerServiceClass:(Class)serviceClass
{
    if (![serviceClass conformsToProtocol:@protocol(SSService)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 模块不符合 SSModule 协议", NSStringFromClass(serviceClass)] userInfo:nil];
    }
    
    if ([[_allModuleDict allKeys] containsObject:NSStringFromClass(serviceClass)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 模块类已经注册", NSStringFromClass(serviceClass)] userInfo:nil];
    }
    
    NSString *key = NSStringFromClass(serviceClass);
    id<SSService> service = [[serviceClass alloc]init];
    [_allServicesDict setObject:service forKey:key];
}

// 查找相应的服务
- (id<SSService>)findServiceClass:(Class)ServiceClass
{
    id<SSService> sender = nil;
    for (sender in [_allServicesDict allValues]) {
        if ([sender isKindOfClass:ServiceClass]) {
            break;
        }
    }
    return sender;
}

@end


#pragma mark -
@implementation SSContext(AppDelegate)

// 启动的初始化方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    [self p_invokeSel:_cmd params:[NSMutableArray arrayWithObjects:application,launchOptions, nil]];
    
    return YES;
}

// app即将销毁
- (void)applicationWillTerminate:(UIApplication *)application
{
    [self p_invokeSel:_cmd params:@[application]];
}

// 注册通知的时候
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self p_invokeSel:_cmd params:@[application, deviceToken]];
}

// 收到本地通知的时候
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self p_invokeSel:_cmd params:@[application, notification]];
}


#pragma mark - 推送相关
// 收到远程推送的时候
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [self p_invokeSel:@selector(application:didReceiveRemoteNotification:) params:@[application, userInfo]];
}

// 收到远程推送的时候
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self p_invokeSel:@selector(application:didReceiveRemoteNotification:) params:@[application, userInfo]];
}


#pragma mark - OpenURL 相关
// 打开
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self p_invokeSel:_cmd params:@[application, url]];
    return YES;
}

// 打开URL
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [self application:app handleOpenURL:url];
}

// 打开App
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self application:application handleOpenURL:url];
}


#pragma mark - 支持unival link
// 用户点击
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    [self p_invokeSel:_cmd params:[NSMutableArray arrayWithObjects:application, userActivity, restorationHandler, nil]];
    return YES;
}


#pragma mark - Private api
// 共用执行的方法
- (void)p_invokeSel:(SEL)sel params:(NSArray *)params
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 加载需要优先配置的api
        for (id<SSModule> protrol in [SSContext shareContext].modules) {
            if ([protrol respondsToSelector:sel]) {
                NSMethodSignature *sig = [[protrol class] instanceMethodSignatureForSelector:sel];
                NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:sig];
                [invoke setTarget:protrol];
                [invoke setSelector:sel];
                // 参数设置
                for (int i =0; i<params.count; i++) {
                    NSObject *param = params[i];
                    [invoke setArgument:&param atIndex:2+i];
                }
                [invoke invoke];
            }
        }
    });
}


@end







