//
//  Item.h
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * cached;
@property (nonatomic, retain) NSNumber * check;
@property (nonatomic, retain) NSString * collector;
@property (nonatomic, retain) NSNumber * desire;
@property (nonatomic, retain) NSDate * desire_time;
@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSString * leibie;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSString * url;

@end
