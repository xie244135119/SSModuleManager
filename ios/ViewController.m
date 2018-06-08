//
//  ViewController.m
//  ios
//
//  Created by SunSet on 2017/7/4.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "ViewController.h"
#import "SSModuleStorage.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@" 数据 :%@ ",[SSModuleStorage module]);
    [self performSelector:@selector(test) withObject:nil afterDelay:1];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@" 测试 ");
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    NSLog(@" 数据 :%@ ",[SSModuleStorage module]);
}


@end
