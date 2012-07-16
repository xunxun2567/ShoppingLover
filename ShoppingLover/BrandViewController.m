//
//  BrandViewController.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "BrandViewController.h"
#import "Brand.h"
#import "BrandManager.h"

@implementation BrandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* brands = [[BrandManager defaultManager]allBrands];
    
    NSLog(@"%@", brands);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
