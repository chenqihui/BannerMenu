//
//  ViewController.m
//  BannerMenuForView
//
//  Created by chen on 14/7/24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ViewController.h"

#import "QHBannerMenuView.h"

@interface ViewController ()<QHBannerMenuViewDelegate>
{
    NSArray *_ar;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    _ar = @[@"用户", @"游戏", @"论坛"];
    //这里由于图片即浮标的长宽限制在75以下，不然会变形，这是图片像数的限制
    //调用方式一
    /*
    QHBannerMenuView *bannerMV1 = [[QHBannerMenuView alloc] initWithFrame:CGRectMake(0, 60, isIpad?75:60, isIpad?75:60) menuWidth:isIpad?300:220 buttonTitle:_ar withBlock:^(NSUInteger index)
    {
        NSString *title = [_ar objectAtIndex:index];
//        NSLog(@"%@", title);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertV show];
        switch (index)
        {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:bannerMV1];
     */
    
    //调用方式二----此为通用方式
    QHBannerMenuView *bannerMV2 = [[QHBannerMenuView alloc] initWithFrame:CGRectMake(0, 60, isIpad?75:60, isIpad?75:60) menuWidth:isIpad?300:220 delegate:self];
    [self.view addSubview:bannerMV2];
}

#pragma mark - QHBannerMenuViewDelegate

- (NSInteger)bannerMenuView:(QHBannerMenuView *)bannerMenuView
{
    return _ar.count;
}

- (UIView *)bannerMenuView:(QHBannerMenuView *)bannerMenuView menuForRowAtIndexPath:(NSUInteger)index
{
    NSString *title = [_ar objectAtIndex:index];
    UILabel *l  = [[UILabel alloc] init];
    l.text = title;
    l.textColor = [UIColor blackColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    
    return l;
}

- (void)bannerMenuView:(QHBannerMenuView *)bannerMenuView didSelectRowAtIndexPath:(NSUInteger)index
{
    NSString *title = [_ar objectAtIndex:index];
    //        NSLog(@"%@", title);
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertV show];
}

@end
