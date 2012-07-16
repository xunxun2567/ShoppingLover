//
//  ViewSwitcher.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "ViewSwitcher.h"
#import "UpdateManager.h"
#import "UpdateViewController.h"
#import "BrandViewController.h"


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
    brandViewController = [[BrandViewController alloc]initWithNibName:@"BrandViewController" bundle:nil];
    
    if ([[UpdateManager defaultManager]isFirstRun]) {
        mainWindow.rootViewController = updateViewController;
    }
    else {
        mainWindow.rootViewController = brandViewController;
    }
    
    [mainWindow makeKeyAndVisible];    
}

-(void)terminate    {
    [mainWindow release];
}

@end
