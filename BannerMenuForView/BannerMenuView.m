//
//  BannerMenuView.m
//  Copy91Home
//
//  Created by chen on 14-7-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "BannerMenuView.h"

//点击后扩大的大小
#define SCALESIZE 5

//展开菜单view的标记
#define MENUBGTAG 1

typedef NS_ENUM (NSUInteger, LocationTag)
{
    kLocationTag_top = 1,
    kLocationTag_left,
    kLocationTag_bottom,
    kLocationTag_right
};

@interface BannerMenuView ()
{
    UIView *_bannerMenuV;//展开菜单的view
    UIImageView *_bannerIV;//浮标的imageview
    
    BOOL _bShowMenu;//是否在展开了菜单，展开时不允许移动浮标
    BOOL _bMoving;//是否在移动浮标
    
    float _nLogoWidth;//浮标的宽度
    float _nLogoHeight;//浮标的高度
    float _nMenuWidth;//菜单栏的宽度
    float _nMenuHeight;//菜单栏的高度＝＝浮标的宽度
    
    LocationTag _locationTag;
    float _w;
    float _h;
    UIDeviceOrientation _lastOrientation;
}

@end

@implementation BannerMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initV:frame menuWidth:200];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initV:frame menuWidth:nWidth];
    }
    return self;
}

- (void)initV:(CGRect)frame menuWidth:(float)nWidth
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    _bShowMenu = NO;
    _bMoving = NO;
    
    //使用图片的size
//    UIImage *img = [UIImage imageWithContentsOfFile:[FilePath getFilePath:@"ass_common_icon_hide.png"]];
//    _nLogoWidth = img.size.width;
//    _nMenuHeight = _nLogoHeight = img.size.height;
    
    _locationTag = kLocationTag_bottom;
    _lastOrientation = (int)[UIDevice currentDevice].orientation;
    _w = [self superview].frame.size.width;
    _h = [self superview].frame.size.height;
    
    _locationTag = kLocationTag_bottom;
    _nLogoWidth = frame.size.width;
    _nMenuHeight = _nLogoHeight = frame.size.height;
    _nMenuWidth = nWidth;
    
    _bannerMenuV = [[UIView alloc] initWithFrame:CGRectMake(_nLogoWidth, 0, 0, 0)];
    [_bannerMenuV setClipsToBounds:YES];
    UIImageView *menuBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _nMenuWidth, _nMenuHeight)];
    [menuBgIV setTag:MENUBGTAG];
    [_bannerMenuV addSubview:menuBgIV];
    [_bannerMenuV setHidden:YES];
    
    UILabel *welcomeL = [[UILabel alloc] initWithFrame:menuBgIV.bounds];
    [welcomeL setText:@" welcome to chen's world"];
    [welcomeL setTextColor:[UIColor whiteColor]];
    [menuBgIV addSubview:welcomeL];
    
    _bannerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _nLogoWidth, _nLogoHeight)];
    [self setBannerImageView:YES];
    [self addSubview:_bannerIV];
    [self addSubview:_bannerMenuV];
//    _bannerMenuV.userInteractionEnabled = YES;
//    _bannerIV.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
}

- (void)setBannerImageView:(BOOL)bHide
{
    NSString *path = nil;
    if (bHide)
    {
        path = [FilePath getFilePath:@"ass_common_icon_hide.png"];
    }else
    {
        path = [FilePath getFilePath:@"ass_common_icon.png"];
    }
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    [_bannerIV setImage:img];
}

- (void)showMenu:(BOOL)bShow time:(float)times complete:(void(^)())complete
{
    self.userInteractionEnabled = NO;
    NSString *path = nil;
    if (bShow)
    {
        [_bannerMenuV setHidden:NO];
        if (self.frame.origin.x == 0)
        {
            UIImage *img = [UIImage imageWithContentsOfFile:[FilePath getFilePath:@"ass_tb_bg_left.png"]];
            [((UIImageView *)[_bannerMenuV viewWithTag:MENUBGTAG]) setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
            path = [FilePath getFilePath:@"ass_tb_return_left.png"];
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _nMenuWidth + _nLogoWidth, _nMenuHeight)];
            [_bannerIV setFrame:CGRectMake(0, 0, _nLogoWidth, _nLogoHeight)];
            [_bannerMenuV setFrame:CGRectMake(_nLogoWidth, 0, 0, _nMenuHeight)];
            [UIView animateWithDuration:times animations:^
            {
                [_bannerMenuV setFrame:CGRectMake(_nLogoWidth, 0, _nMenuWidth, _nMenuHeight)];
            } completion:^(BOOL finished)
            {
                self.userInteractionEnabled = YES;
                complete();
            }];
        }else
        {
            UIImage *img = [UIImage imageWithContentsOfFile:[FilePath getFilePath:@"ass_tb_bg_right.png"]];
            [((UIImageView *)[_bannerMenuV viewWithTag:MENUBGTAG]) setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
            path = [FilePath getFilePath:@"ass_tb_return_right.png"];
            [self setFrame:CGRectMake(self.frame.origin.x - _nMenuWidth, self.frame.origin.y, _nMenuWidth + _nLogoWidth, _nMenuHeight)];
            [_bannerIV setFrame:CGRectMake(_nMenuWidth, 0, _nLogoWidth, _nLogoHeight)];
            [_bannerMenuV setFrame:CGRectMake(_nMenuWidth, 0, 0, _nMenuHeight)];
            [UIView animateWithDuration:times animations:^
             {
                 [_bannerMenuV setFrame:CGRectMake(0, 0, _nMenuWidth, _nMenuHeight)];
             } completion:^(BOOL finished)
             {
                 self.userInteractionEnabled = YES;
                 complete();
             }];
        }
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
    }else
    {
        path = [FilePath getFilePath:@"ass_common_icon_hide.png"];
        if (self.frame.origin.x == 0)
        {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _nLogoWidth, _nMenuHeight)];
            [_bannerIV setFrame:CGRectMake(0, 0, _nLogoWidth, _nLogoHeight)];
            [UIView animateWithDuration:times animations:^
             {
                 [_bannerMenuV setFrame:CGRectMake(_nLogoWidth, 0, 0, _nLogoHeight)];
             } completion:^(BOOL finished)
             {
                 UIImage *img = [UIImage imageWithContentsOfFile:path];
                 [_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
                 [_bannerMenuV setHidden:YES];
                 self.userInteractionEnabled = YES;
                 complete();
             }];
        }else
        {
            [UIView animateWithDuration:times animations:^
             {
                 [_bannerMenuV setFrame:CGRectMake(_nMenuWidth, 0, 0, _nMenuHeight)];
             } completion:^(BOOL finished)
             {
                 [self setFrame:CGRectMake(self.frame.origin.x + _nMenuWidth, self.frame.origin.y, _nLogoWidth, _nMenuHeight)];
                 [_bannerIV setFrame:CGRectMake(0, 0, _nLogoWidth, _nLogoHeight)];
                 UIImage *img = [UIImage imageWithContentsOfFile:path];
                 [_bannerIV setImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)]];
                 [_bannerMenuV setHidden:YES];
                 self.userInteractionEnabled = YES;
                 complete();
             }];
        }
    }
}

- (void)shakeMenu:(UIView *)view
{
    self.userInteractionEnabled = NO;
    
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    [animation setValue:@"toViewValue" forKey:@"toViewKey"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.1];
    [animation setRepeatCount:2];
    [lbl addAnimation:animation forKey:nil];
}

- (void)computeOfLocation:(void(^)())complete
{
    
    //    float w = [self superview].frame.size.width;
    //    float h = [self superview].frame.size.height;
    
    float x = self.center.x;
    float y = self.center.y;
    CGPoint m = CGPointZero;
    m.x = x;
    m.y = y;
    
    //这里是可以根据上左下右边距，取近的位置靠边-------------------
    //    if (x < w/2 && y <= h/2)
    //    {
    //        if (x < y)
    //            locationTag = kLocationTag_left;
    //        else
    //            locationTag = kLocationTag_top;
    //    }else if (x > w/2 && y < h/2)
    //    {
    //        if (w - x < y)
    //            locationTag = kLocationTag_right;
    //        else
    //            locationTag = kLocationTag_top;
    //    }else if (x < w/2 && y > h/2)
    //    {
    //        if (x < h - y)
    //            locationTag = kLocationTag_left;
    //        else
    //            locationTag = kLocationTag_bottom;
    //    }else //if (x > _w/2 && y > _h/2)//在中间就归为第四象限
    //    {
    //        if (w - x < h - y)
    //            locationTag = kLocationTag_right;
    //        else
    //            locationTag = kLocationTag_bottom;
    //    }
    
    //由于这里要展开菜单，所以只取两边就好--------------------------
    if (x < _w/2)
    {
        _locationTag = kLocationTag_left;
    }else
    {
        _locationTag = kLocationTag_right;
    }
    
    //---------------------------------------------------------
    
    switch (_locationTag)
    {
        case kLocationTag_top:
            m.y = 0 + _bannerIV.frame.size.width/2 + 20;
            break;
        case kLocationTag_left:
            m.x = 0 + _bannerIV.frame.size.height/2;
            break;
        case kLocationTag_bottom:
            m.y = _h - _bannerIV.frame.size.height/2;
            break;
        case kLocationTag_right:
            m.x = _w - _bannerIV.frame.size.width/2;
            break;
    }
    
    //这个是在旋转是微调浮标出界时
    if (m.x > _w - _bannerIV.frame.size.width/2)
        m.x = _w - _bannerIV.frame.size.width/2;
    if (m.y > _h - _bannerIV.frame.size.height/2)
        m.y = _h - _bannerIV.frame.size.height/2;
    
    [UIView animateWithDuration:0.1 animations:^
     {
         [self setCenter:m];
     } completion:^(BOOL finished)
     {
         complete();
     }];
}

#pragma mark - action

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _bMoving = NO;
    if (!_bShowMenu)
    {
        [_bannerIV setFrame:CGRectMake(_bannerIV.frame.origin.x, _bannerIV.frame.origin.y, _bannerIV.frame.size.width + SCALESIZE, _bannerIV.frame.size.height + SCALESIZE)];
        NSString *path = [FilePath getFilePath:@"ass_common_icon.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [_bannerIV setImage:img];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_bShowMenu)
        [_bannerIV setFrame:CGRectMake(_bannerIV.frame.origin.x, _bannerIV.frame.origin.y, _bannerIV.frame.size.width - SCALESIZE, _bannerIV.frame.size.height - SCALESIZE)];
    if (!_bMoving)
    {
        _bShowMenu = !_bShowMenu;
        [self showMenu:_bShowMenu time:0.3 complete:^
        {
            [self shakeMenu:self];
        }];
        return;
    }
    
    [self computeOfLocation:^
    {
        [self setBannerImageView:YES];
        _bMoving = NO;
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_bShowMenu)
    {
        return;
    }
    _bMoving = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint movedPT = [touch locationInView:[self superview]];
    
    if (movedPT.x - self.frame.size.width/2 < 0.f ||
        movedPT.x + self.frame.size.width/2 > _w ||
        movedPT.y - self.frame.size.height/2 < isIos7?20.f:0.f ||
        movedPT.y + self.frame.size.height/2 > _h)
    {
        return;
    }
    
    [self setCenter:movedPT];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"toViewKey"] isEqualToString:@"toViewValue"])
    {
        __async_main__, ^
        {
            self.userInteractionEnabled = YES;
        });
    }
}

#pragma mark - NSNotification

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation currentOrientation = (int)[UIDevice currentDevice].orientation;
    
    if(currentOrientation == UIDeviceOrientationPortraitUpsideDown ||
       currentOrientation == UIDeviceOrientationFaceUp ||
       currentOrientation == UIDeviceOrientationFaceDown ||
       _lastOrientation == currentOrientation)
    {
        return;
    }
    
    void(^func)(BOOL b) = ^(BOOL b)
    {
        switch ((int)[UIDevice currentDevice].orientation)
        {
            case UIDeviceOrientationPortrait:
            {
                _w = [self superview].frame.size.width;
                _h = [self superview].frame.size.height;
                break;
            }
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
            {
                _w = [self superview].frame.size.height;
                _h = [self superview].frame.size.width;
                break;
            }
        }
        [self computeOfLocation:^
         {
            if (b)
            {
                _bShowMenu = YES;
                [self showMenu:_bShowMenu time:0 complete:^
                {
                    _bMoving = NO;
                }];
            }
         }];
    };
    
    BOOL bS = _bShowMenu;
    if(bS)
    {
        _bShowMenu = NO;
        [self showMenu:_bShowMenu time:0 complete:^
        {
            func(bS);
        }];
    }else
    {
        func(bS);
    }
    _lastOrientation = currentOrientation;
}

@end
