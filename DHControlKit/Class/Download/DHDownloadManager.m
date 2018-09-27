//
//  DHDownloadManager.m
//  DHControlKit
//
//  Created by daixinhui on 2018/6/28.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHDownloadManager.h"

@implementation DHDownloadManager

static DHDownloadManager *downloadManager = nil;
+ (DHDownloadManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    return downloadManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
