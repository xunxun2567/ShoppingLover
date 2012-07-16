//
//  ViewSwitcher.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "ViewSwitcher.h"
#import "UpdateViewController.h"

@implementation ViewSwitcher

ViewSwitcher* g_viewSwithcerInstance;

+(ViewSwitcher*)defaultSwitcher {
    if (!g_viewSwithcerInstance) {
        g_viewSwithcerInstance = [[ViewSwitcher alloc]init];
    }
    return g_viewSwithcerInstance;
}

-(void)start    {
    mainWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    updateViewController = [[UpdateViewController alloc]initWithNibName:@"UpdateViewController" bundle:nil];
    
    mainWindow.rootViewController = updateViewController;
    [mainWindow makeKeyAndVisible];    
}

-(void)terminate    {
    [mainWindow release];
}

@end
