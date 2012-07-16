//
//  UpdateViewController.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "UpdateViewController.h"
#import "UpdateManager.h"

@implementation UpdateViewController

-(void)viewDidAppear:(BOOL)animated    {
    if ([[UpdateManager defaultManager]isFirstRun])  {
        [[UpdateManager defaultManager]config];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
