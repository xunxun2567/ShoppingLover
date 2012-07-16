//
//  Activity.h
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;

@end
