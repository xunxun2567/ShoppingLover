//
//  AppDelegate.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewSwitcher.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ViewSwitcher defaultSwitcher]start];
    return YES;
}

@end
