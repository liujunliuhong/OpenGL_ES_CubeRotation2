//
//  AppDelegate.m
//  OpenGL_ES_CubeRotation2
//
//  Created by apple on 2020/7/28.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    
    return YES;
}

@end
