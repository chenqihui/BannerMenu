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
    //这里由于图片即浮标的长宽限制在75以下，不然会变形，这是图片像数的限制
    BannerMenuView *bannerMV = [[BannerMenuView alloc] initWithFrame:CGRectMake(0, 60, isIpad?75:60, isIpad?75:60) menuWidth:isIpad?300:200];
    [self.view addSubview:bannerMV];
}

@end
