//
//  FilePath.m
//  Copy91Home
//
//  Created by chen on 14-7-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "FilePath.h"

@implementation FilePath

+ (NSString *)getFilePath:(NSString *)fileNameAndType
{
    NSString *szFilename = [fileNameAndType stringByDeletingPathExtension];
    NSString *szFileext = [fileNameAndType pathExtension];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[szFilename stringByAppendingString:@"@2x"] ofType:szFileext];
    
    return path;
}

@end
