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








