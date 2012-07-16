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
#import "ItemViewController.h"
#import "SettingViewController.h"
#import "DesireViewController.h"
#import "ActivityViewController.h"

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
    itemViewController = [[ItemViewController alloc]initWithNibName:@"ItemViewController" bundle:nil];
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    desireViewController = [[DesireViewController alloc]initWithNibName:@"DesireViewController" bundle:nil];
    activityViewController = [[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
    
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

-(void)switchToBrandView    {
    mainWindow.rootViewController = brandViewController;
}

-(void)switchToItemView {
    mainWindow.rootViewController = itemViewController;
}

-(void)switchToSettingView  {
    mainWindow.rootViewController = settingViewController;
}

-(void)switchToDesireView   {
    mainWindow.rootViewController = desireViewController;
}

-(void)switchToActivityView {
    mainWindow.rootViewController = activityViewController;
}


@end
