//
//  ViewSwitcher.h
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdateViewController;
@class BrandViewController;
@class ItemViewController;
@class SettingViewController;
@class DesireViewController;
@class ActivityViewController;
@class ShopLocationViewController;
@class OfficialWebsiteViewController;

@interface ViewSwitcher : NSObject  {
    UIWindow* mainWindow;
    UpdateViewController* updateViewController;
    BrandViewController* brandViewController;
    ItemViewController* itemViewController;
    SettingViewController* settingViewController;
    DesireViewController* desireViewController;
    ActivityViewController* activityViewController;
    ShopLocationViewController* shopLocationViewController;
    OfficialWebsiteViewController* officialWebsiteViewController;
}

+(ViewSwitcher*)defaultSwitcher;

-(void)start;
-(void)terminate;

-(void)switchToBrandView;
-(void)switchToItemView;
-(void)switchToSettingView;
-(void)switchToDesireView;
-(void)switchToActivityView;

@end
