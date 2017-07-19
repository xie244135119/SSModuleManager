//
//  SSModuleProtrol.h
//  AppMicroDistribution
//
//  Created by SunSet on 2017/6/19.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSModuleProtrol <NSObject>

@optional
// 模块预加载
- (void)loadModule;
// 模块卸载
- (void)unloadModule;

@end
