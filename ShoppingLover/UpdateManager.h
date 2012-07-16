//
//  UpdateManager.h
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface UpdateManager : NSObject {
    NSURL* serverURL;
    NSUserDefaults* userDefaults;
    NSOperationQueue* queue;
    NSString* cacheRoot;
    NSURL* documentDirectory;
    Reachability* internetReachability;
}

@property (strong, nonatomic) NSManagedObjectContext* objectContext;

+(UpdateManager*)defaultManager;

-(BOOL)isFirstRun;

-(BOOL)config;
-(BOOL)update;

@end
