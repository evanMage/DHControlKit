//
//  DHSwipeViewProtocol.h
//  headerDemo
//
//  Created by 代新辉 on 2018/1/9.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHSwipeView.h"

/** 默认滑动后的判断条件 （可以直接修改或者实现 DHSwipeViewSwipingDeterminatorProtocol） */
@interface DHSwipeViewDefaultDeterminator : NSObject <DHSwipeViewSwipingDeterminatorProtocol>

@end

/** 默认滑动方向 （可以直接修改或者实现 DHSwipeViewDirectionProtocol）*/
@interface DHSwipeViewDefaultDirection : NSObject <DHSwipeViewDirectionProtocol>

@end

