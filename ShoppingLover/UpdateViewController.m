//
//  UpdateViewController.m
//  ShoppingLover
//
//  Created by Lingkai Kong on 12-7-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "UpdateViewController.h"
#import "UpdateManager.h"
#import "ViewSwitcher.h"

@implementation UpdateViewController

-(void)viewDidAppear:(BOOL)animated    {
    if ([[UpdateManager defaultManager]isFirstRun])  {
        if ([[UpdateManager defaultManager]config]) {
            [[ViewSwitcher defaultSwitcher]switchToBrandView];
        }
        else {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"需要联网初始化" message:@"请检查网络" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    NSLog(@"无法联网, 退出");
    abort();
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
