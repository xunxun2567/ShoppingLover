//
//  BrandManager.h
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandManager : NSObject

+(BrandManager*)defaultManager;

-(NSArray*)allUnvisibleBrands;
-(NSArray*)allVisibleBrands;
-(NSArray*)allBrands;

@end
