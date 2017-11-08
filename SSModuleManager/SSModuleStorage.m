//
//  SSModuleStorage.m
//  SSModuleManager
//
//  Created by SunSet on 2017/11/8.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "SSModuleStorage.h"
#import <objc/runtime.h>

@interface SSModuleStorage()
{
    //本地所有存储的模块 key {className:Key(不变的)}
//    NSMutableDictionary *_moduleStorageDict;
}
@end

@implementation SSModuleStorage

//- (void)dealloc
//{
//    _moduleStorageDict = nil;
//}


+ (instancetype)module
{
    // 本地查询相应的key值
    NSString *modulesDictKey = @"_AMDModulesStorageDict";
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableDictionary *moduledict = objc_getAssociatedObject(app, &modulesDictKey);
    if (moduledict == nil) {
        moduledict = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(app, &modulesDictKey, moduledict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSString *className = [[self class] description];
    if (![moduledict.allKeys containsObject:className]) {
        SSModuleStorage *storage = [[[self class] alloc]init];
        [moduledict setObject:storage forKey:className];
    }
    return moduledict[className];
}




@end






