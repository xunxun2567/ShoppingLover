//
//  BrandManager.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "BrandManager.h"
#import "UpdateManager.h"
#import "Brand.h"
#import <CoreData/CoreData.h>

@implementation BrandManager

BrandManager* g_brandManager;

+(BrandManager*)defaultManager  {
    if (!g_brandManager)    {
        g_brandManager = [[BrandManager alloc]init];
    }
    return g_brandManager;
}

-(NSManagedObjectContext*)context   {
    return [[UpdateManager defaultManager]objectContext];
}

-(Brand*)getBrand:(NSString*)collector    {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collector == %@", collector];
    [request setPredicate:predicate];
    
    NSMutableArray* mutableFetchResults = [[[self context] executeFetchRequest:request error:nil] mutableCopy];        
    [request release];    
    
    if (mutableFetchResults.count == 0)
        return nil;
    else
        return [mutableFetchResults objectAtIndex:0];
}

-(NSArray*)allBrands    {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];    
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    return results;
}

-(NSArray*)allVisibleBrands {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visible == 1"];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    return results;
}

-(NSArray*)allUnvisibleBrands {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visible == 0"];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    return results;
}

-(int)getCount:(Brand *)brand
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand == %@", brand.collector];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    return results.count;
}



@end
