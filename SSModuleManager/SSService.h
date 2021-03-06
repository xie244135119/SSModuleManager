//
//  SSService.h
//  SSModuleManager
//  注册相关服务(如 推送 友盟等)
//  Created by SunSet on 2017/10/30.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSService <NSObject>

@optional
// 启动服务的时候
- (void)loadService;
// 卸载服务的时候
- (void)unloadService;


@end

