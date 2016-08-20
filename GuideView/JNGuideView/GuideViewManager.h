//
//  GuideViewManager.h
//  GuideViewDemo
//
//  Created by Jn_Kindle on 16/7/17.
//  Copyright © 2016年 HuaDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GuideViewManager : NSObject

/**
 *  创建单例模式
 *
 *  @return 单例
 */
+ (instancetype)sharedInstance;

/**
 *  引导页图片
 *
 *  @param images                 引导页图片
 *  @param skipButtonTitle        跳过文字
 *  @param experienceButtonImage  立即体验按钮图片
 */
- (void)showGuideViewWithGuideImages:(NSArray *)guideImages
                 withSkipButtonTitle:(NSString *)skipButtonTitle
           withExperienceButtonImage:(UIImage *)experienceButtonImage;

@end
