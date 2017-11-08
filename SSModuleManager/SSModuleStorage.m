//
//  SSModuleStorage.m
//  SSModuleManager
//
//  Created by SunSet on 2017/11/8.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "SSModuleStorage.h"
#import <objc/runtime.h>

@implementation SSModuleStorage


+ (instancetype)module
{
    static const NSString *key = nil;
    if(key == nil) {
        key = [[self class] description];
    }
    UIApplication *app = [UIApplication sharedApplication];
    id sender = objc_getAssociatedObject(app, [key cStringUsingEncoding:30]);
    // 保存内容
    if(sender == nil) {
        SSModuleStorage *storage = [[[self class] alloc]init];
        objc_setAssociatedObject(app, [key cStringUsingEncoding:30], storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        sender = storage;
    }
    return sender;
}




@end






