//
//  UpdateManager.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "UpdateManager.h"
#import "Reachability.h"
#import "JSONKit.h"
#import "Brand.h"
#import "Item.h"
#import "Activity.h"
#import "Shop.h"
#import <CoreData/CoreData.h>
#import <zlib.h>

@implementation UpdateManager

@synthesize objectContext;

UpdateManager* g_updateManager;

+(UpdateManager*)defaultManager {
    if (!g_updateManager)   {
        g_updateManager = [[UpdateManager alloc]init];
        
    }
    return g_updateManager;
}

-(id)init   {
    self = [super init];
    
    if (self != nil)    {
        NSString* configFile = [[NSBundle mainBundle]pathForResource:@"config" ofType:@"plist"];
        NSLog(@"configFile is :%@",configFile);
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:configFile];
        
        NSString* serverAddress = [dict objectForKey:@"server_address"];
        NSString* databaseFile = [dict objectForKey:@"database_file"];
        NSLog(@"Database file: %@", databaseFile);        
        
        documentDirectory = [[[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]objectAtIndex:0]retain];
        NSLog(@"documentDirectory is %@:",documentDirectory);
        NSURL* databaseFilepath = [documentDirectory URLByAppendingPathComponent:databaseFile];
        NSLog(@"databaseFilepath is :%@",databaseFilepath);
        serverURL = [[NSURL URLWithString:serverAddress]retain];
        NSLog(@"Server address:%@", serverURL);
        
        NSManagedObjectModel* objectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
        NSPersistentStoreCoordinator* coordinator = [[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:objectModel]retain];
        NSPersistentStore* store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseFilepath options:nil error:nil];
        if (!store)   {
            NSLog(@"Critical: cannot init persistence store, check the db file!");
            abort();
        }
        objectContext = [[NSManagedObjectContext alloc]init];
        [objectContext setPersistentStoreCoordinator:coordinator];
        NSLog(@"Database connection was setup successfully.");
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        cacheRoot = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]retain];
        NSLog(@"Cache root:%@", cacheRoot);
        
        internetReachability = [[Reachability reachabilityForInternetConnection]retain];
        [internetReachability startNotifier];
        
        NSLog(@"Watching for internet connection change.");
    }
    return self;
}

-(BOOL)isFirstRun   {
    return [userDefaults objectForKey:@"last_update"] == nil;
}

-(NSData *)uncompressZippedData:(NSData *)compressedData    
{    
    if ([compressedData length] == 0) return compressedData;    
    unsigned full_length = [compressedData length];    
    unsigned half_length = [compressedData length] / 2;    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];    
    BOOL done = NO;    
    int status;    
    z_stream strm;    
    strm.next_in = (Bytef *)[compressedData bytes];    
    strm.avail_in = [compressedData length];    
    strm.total_out = 0;    
    strm.zalloc = Z_NULL;    
    strm.zfree = Z_NULL;    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;    
    while (!done) {    
        if (strm.total_out >= [decompressed length]) {    
            [decompressed increaseLengthBy: half_length];    
        }    
        strm.next_out = [decompressed mutableBytes] + strm.total_out;    
        strm.avail_out = [decompressed length] - strm.total_out;    
        status = inflate (&strm, Z_SYNC_FLUSH);    
        if (status == Z_STREAM_END) {    
            done = YES;    
        } else if (status != Z_OK) {    
            break;    
        }    
        
    }    
    if (inflateEnd (&strm) != Z_OK) return nil;    
    if (done) {    
        [decompressed setLength: strm.total_out];    
        return [NSData dataWithData: decompressed];    
    } else {    
        return nil;    
    }    
} 

-(NSDate *)NSStringDateToNSDate:(NSString *)string { 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string]; 
    [dateFormatter release];
    return date;
}

-(void)addToDatabase:(NSMutableDictionary*)dict {
    NSArray* brands = [dict objectForKey:@"brands"];
    int brandIndex = 0;
    for (NSDictionary* dict in brands)  {
        Brand* newBrand = [NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:objectContext];            
        newBrand.collector = [dict objectForKey:@"name"];                     
        newBrand.logo = [dict objectForKey:@"logo"];;
        newBrand.display_name = [dict objectForKey:@"display_name"];
        newBrand.unread_count = [NSNumber numberWithInt:0];
        newBrand.head_index = [NSNumber numberWithInt:0];
        newBrand.total_count = [NSNumber numberWithInt:0];
        newBrand.visible = [NSNumber numberWithInt:1];        
        brandIndex++;
    }
    NSLog(@"%d brands added.", brandIndex);
    
    NSMutableDictionary* itemsDict = [NSMutableDictionary dictionary];
    NSArray* items = [dict objectForKey:@"items"];
    for (NSDictionary* dict in items)  {              
        Item* item = (Item*)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:objectContext];
        item.url = [dict objectForKey:@"url"];
        item.image_url = [dict objectForKey:@"image_url"];
        item.price = [dict objectForKey:@"price"];
        item.time = [dict objectForKey:@"time"];
        item.leibie = [dict objectForKey:@"category"];
        item.unread = [NSNumber numberWithInt:1];
        item.desire = [NSNumber numberWithInt:0];
        item.collector = [dict objectForKey:@"brand"];           
        item.desire_time = [NSDate date];
        item.cached = [NSNumber numberWithInt:0];
        if ([dict objectForKey:@"name"] == [NSNull null])   {
            item.title = @"";
        }
        else    {
            item.title = [dict objectForKey:@"name"];   
        }
        
        if (![itemsDict objectForKey:item.collector]) {
            [itemsDict setObject:[NSNumber numberWithInt:1] forKey:item.collector];
        }
        else    {
            NSNumber* oldValue = [itemsDict objectForKey:item.collector];
            [itemsDict setObject:[NSNumber numberWithInt:oldValue.intValue + 1] forKey:item.collector];
        }
    }
    NSLog(@"%d items added.", items.count);
    
    NSArray* shops = [dict objectForKey:@"shops"];
    for (NSDictionary* dict in shops)  {            
        Shop* shop = (Shop*)[NSEntityDescription insertNewObjectForEntityForName:@"Shop" inManagedObjectContext:objectContext];
        shop.collector = [dict objectForKey:@"brand"];
        shop.address = [dict objectForKey:@"name"];
        shop.lat = [dict objectForKey:@"lat"];
        shop.lng = [dict objectForKey:@"lng"];
    }
    NSLog(@"%d shops added.", shops.count);
    
    
    NSArray *activities = [dict objectForKey:@"activities"];
    for (NSDictionary *dict in activities){       
        Activity *activity = (Activity*)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:objectContext];
        NSString *startTime = [dict objectForKey:@"startTime"];
        NSString *endTime = [dict objectForKey:@"endTime"];
        activity.startTime = [self NSStringDateToNSDate:startTime];
        activity.endTime = [self NSStringDateToNSDate:endTime];
        activity.logo = [dict objectForKey:@"logo"];
        activity.text = [dict objectForKey:@"text"];
        activity.title = [dict objectForKey:@"title"];
    }
    NSLog(@"%d activities added.", activities.count);
    
//    for (Brand* brand in [[BrandManager defaultManager]allBrands])  {
//        NSNumber* unread = [itemsDict objectForKey:brand.collector];
//        brand.update_count=unread;
//        brand.unread_count = [NSNumber numberWithInt: brand.unread_count.intValue + unread.intValue];
//        brand.total_count = [NSNumber numberWithInt: brand.total_count.intValue + unread.intValue];
//        brand.head_index = [NSNumber numberWithInt:(brand.total_count.intValue-1)];
//    }
    
    [objectContext save:nil];        
    NSLog(@"Add to database succeed!");
}

-(BOOL)config   {
    NSLog(@"Configuring...");
        
    NSString* url = [NSString stringWithFormat:@"http://%@/shopping/api/", serverURL];
    NSLog(@"url: %@", url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSData* unzipData = [self uncompressZippedData:data];
        
    NSString* text = [[NSString alloc]initWithData:unzipData encoding:NSStringEncodingConversionAllowLossy]; 
        
    if ([text isEqualToString:@""])  {
        NSLog(@"cannot connect to data server..., init fail!");
        [text release];
        return NO;
    }
        
    NSMutableDictionary* dict = [text mutableObjectFromJSONString];
    [text release];
    NSLog(@"data loaded.");
    [self addToDatabase:dict];
        
    NSDate* today = [NSDate dateWithTimeIntervalSinceNow:0];
    [userDefaults setObject:today forKey:@"last_update"];
    [userDefaults synchronize];        
    return YES;    
}

-(BOOL)update   {
    NSDate* date = [userDefaults objectForKey:@"last_update"];
    if (!date)   {
        NSLog(@"not init yet. cannot update");
        return NO;
    }
    NSDate* today = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSDate* lastClear=[userDefaults objectForKey:@"last_clear"];
//    if ([self neededToClear:lastClear today:today]) {
//        [[ItemManager defaultManager]clearData];
//        [userDefaults setObject:today forKey:@"last_clear"];
//    }
//    [self commitBasket];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMd"];
    [formatter stringFromDate:date];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/shopping/api/%@", serverURL, [formatter stringFromDate:date]];
    NSLog(@"url: %@", url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSData* unzipData = [self uncompressZippedData:data];
    
    NSString* text = [[NSString alloc]initWithData:unzipData encoding:NSStringEncodingConversionAllowLossy];       
    if ([text isEqualToString:@""])  {
        NSLog(@"cannot connect to data server..., update fail!");
        [text release];
        return NO;
    }
    NSMutableArray* arr = [text mutableObjectFromJSONString];
    [text release];
    NSLog(@"data loaded.");
    for (NSMutableDictionary* dict in arr)  {
        [self addToDatabase:dict];
    }    
    [userDefaults setObject:today forKey:@"last_update"];
    [userDefaults synchronize];
    
    return YES;
}

@end
