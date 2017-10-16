//
//  SSModuleCenter.m
//  SSModuleManager
//
//  Created by SunSet on 2017/7/4.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "SSModuleCenter.h"

@interface SSModuleCenter()
{
    NSMutableArray *_allModules;        //所有的模块
}
@end


@implementation SSModuleCenter

- (void)dealloc
{
    _allModules = nil;
}


+ (instancetype)defaultCenter
{
    static SSModuleCenter *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SSModuleCenter alloc]init];
    });
    return _manager;
}


+ (void)registerModule:(id<SSModuleProtrol>)module
{
    //
}


- (void)addModule:(id<SSModuleProtrol>)module
{
    if (_allModules == nil) {
        _allModules = [[NSMutableArray alloc]init];
    }
    
    if (module) {
        [_allModules addObject:module];
    }
    
    if ([module respondsToSelector:@selector(loadModule)]) {
        [module loadModule];
    }
}

- (void)addModuleClass:(Class)moduleClass
{
    id module = [[moduleClass alloc]init];
//    NSAssert(module, @"当前模块不存在");
    if (module == nil) {
        NSLog(@" warnings: %@ 模块不存在 ",moduleClass);
        return;
    }
    [self addModule:module];
}


- (void)removeModule:(id<SSModuleProtrol>)module
{
    [_allModules removeObject:module];
    if ([module respondsToSelector:@selector(unloadModule)]) {
        [module unloadModule];
    }
}

- (void)removeModuleClass:(Class)moduleClass
{
    for (id<SSModuleProtrol> protrol in _allModules) {
        if ([protrol isKindOfClass:moduleClass]) {
            [self removeModule:protrol];
        }
    }
}


- (NSArray<id<SSModuleProtrol>> *)allModule
{
    return _allModules;
}




@end





