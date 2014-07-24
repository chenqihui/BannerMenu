//
//  ViewController.m
//  BannerMenuForView
//
//  Created by chen on 14/7/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ViewController.h"

#import "BannerMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    BannerMenuView *bannerMV = [[BannerMenuView alloc] initWithFrame:CGRectMake(0, 60, isIpad?80:60, isIpad?80:60) menuWidth:isIpad?300:200];
    [self.view addSubview:bannerMV];
}

@end
