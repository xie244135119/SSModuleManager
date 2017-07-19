//
//  SSModuleCenter.h
//  SSModuleManager
//
//  Created by SunSet on 2017/7/4.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSModuleProtrol.h"

@interface SSModuleCenter : NSObject



+ (instancetype)defaultCenter;



/**
 注册子模块

 @param module 模块
 */
+ (void)registerModule:(id<SSModuleProtrol>)module;


/**
 添加子模块
 
 @param module 模块实例
 */
- (void)addModule:(id<SSModuleProtrol>)module;

/**
 添加子模块
 
 @param moduleClass 模块实例Class
 */
- (void)addModuleClass:(Class)moduleClass;

/**
 减少子模块
 
 @param module 模块实例
 */
- (void)removeModule:(id<SSModuleProtrol>)module;

/**
 移除子模块Class
 
 @param moduleClass 子模块实例Class
 */
- (void)removeModuleClass:(Class)moduleClass;


/**
 所有的模块
 
 @return all
 */
- (NSArray<id<SSModuleProtrol>> *)allModule;



@end
