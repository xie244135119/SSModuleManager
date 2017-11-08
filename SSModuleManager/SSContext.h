//
//  SSContext.h
//  SSModuleManager
//
//  Created by SunSet on 2017/10/30.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SSModule, SSService;

@interface SSContext : NSObject

// 全局统一上下文
+ (instancetype)shareContext;

@end

@interface SSContext(SSModule)

/**
 注册相应的模块

 @param moduleClass 相应的模块或Class
 */
- (void)registerModuleClass:(Class)moduleClass;

/**
 移除相应的模块

 @param moduleClass 相应的模块或Class
 */
- (void)unregisterModuleClass:(Class)moduleClass;

/**
 从本地查找相应的模块

 @param moduleClass 模块类名
 @return 模块
 */
- (id<SSModule>)findModuleClass:(Class)moduleClass;


/**
 本地已注册的所有模块

 @return 全部模块
 */
- (NSArray<SSModule> *)modules;

@end


@interface SSContext(SSService)

// 注册相应的服务
- (void)registerServiceClass:(Class)serviceClass;

// 查找相应的服务
- (id<SSService>)findServiceClass:(Class)ServiceClass;

@end
















