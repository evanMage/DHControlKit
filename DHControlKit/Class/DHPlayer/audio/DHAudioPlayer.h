//
//  DHAudioPlayer.h
//  DHControlKit
//
//  Created by 代新辉 on 2018/2/26.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 音频播放
 */
@interface DHAudioPlayer : NSObject

/**
 音频播放单例
 @return DHAudioPlayer
 */
+ (instancetype)sharedInstance;
/**
 播放音频
 @param url 音频URL
 */
- (void)playWithUrl:(NSString *)url;
/**
 暂停
 */
-(void)pause;
/**
 继续
 */
-(void)resume;
/**
 停止
 */
-(void)stop;

@end
