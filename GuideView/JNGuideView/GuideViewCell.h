//
//  GuideViewCell.h
//  GuideViewDemo
//
//  Created by Jn_Kindle on 16/7/17.
//  Copyright © 2016年 HuaDa. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kCellIdentifier_GuideViewCell = @"GuideViewCell";

@interface GuideViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *guideImageView;

@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, strong) UIButton *experienceButton;

@end
