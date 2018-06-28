//
//  DHAttributedLabel.h
//  DHControlKit
//
//  Created by daixinhui on 2018/4/25.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef NS_ENUM(NSInteger, DHAttributedLabelVerticalAlignment) {
    DHAttributedLabelVerticalAlignmentCenter    = 0,
    DHAttributedLabelVerticalAlignmentTop       = 1,
    DHAttributedLabelVerticalAlignmentBottom    = 2,
};

@protocol DHAttributedLable <NSObject>

@property (nonatomic, copy) id text;

@end

//NS_ASSUME_NONNULL_BEGIN

@interface DHAttributedLabel : UILabel<DHAttributedLable>

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, strong) NSDictionary *link;


@end

//NS_ASSUME_NONNULL_END
