//
//  BannerMenuView.h
//  Copy91Home
//
//  Created by chen on 14-7-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerMenuView : UIView

/*
 *frame设置浮标位置及长宽
 *nWidth设置展出后增加的菜单宽带，可以动态计算传值
 */
- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth;

@end
