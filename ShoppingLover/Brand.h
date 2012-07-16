//
//  Brand.h
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Brand : NSManagedObject

@property (nonatomic, retain) NSString * collector;
@property (nonatomic, retain) NSString * display_name;
@property (nonatomic, retain) NSNumber * head_index;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSNumber * total_count;
@property (nonatomic, retain) NSNumber * unread_count;
@property (nonatomic, retain) NSNumber * update_count;
@property (nonatomic, retain) NSNumber * visible;

@end
