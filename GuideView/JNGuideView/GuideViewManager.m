//
//  GuideViewManager.m
//  GuideViewDemo
//
//  Created by Jn_Kindle on 16/7/17.
//  Copyright © 2016年 HuaDa. All rights reserved.
//

#import "GuideViewManager.h"
#import "GuideView.h"

@interface GuideViewManager ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UICollectionView *view;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImage *experienceButtonImage;
@property (nonatomic, copy  ) NSString *skipButtonTitle;

@end




@implementation GuideViewManager

+ (instancetype)sharedInstance {
    static GuideViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [GuideViewManager new];
    });
    return instance;
}

/**
 *  引导页界面
 *
 *  @return 引导页界面
 */
- (UICollectionView *)view {
    if (!_view) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = kScreenViewBounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _view = [[UICollectionView alloc] initWithFrame:kScreenViewBounds collectionViewLayout:layout];
        _view.bounces = NO;
        _view.backgroundColor = [UIColor whiteColor];
        _view.showsHorizontalScrollIndicator = NO;
        _view.showsVerticalScrollIndicator = NO;
        _view.pagingEnabled = YES;
        _view.dataSource = self;
        _view.delegate = self;
        
        [_view registerClass:[GuideViewCell class] forCellWithReuseIdentifier:kCellIdentifier_GuideViewCell];
    }
    return _view;
}

/**
 *  初始化pageControl
 *
 *  @return pageControl
 */
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, kScreenViewBounds.size.width, 44.0f);
        _pageControl.center = CGPointMake(kScreenViewBounds.size.width / 2, kScreenViewBounds.size.height - 60);
    }
    return _pageControl;
}

- (void)showGuideViewWithGuideImages:(NSArray *)guideImages
                 withSkipButtonTitle:(NSString *)skipButtonTitle
           withExperienceButtonImage:(UIImage *)experienceButtonImage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
    BOOL show = [userDefaults boolForKey:[NSString stringWithFormat:@"version_%@", version]];
    
    if (!show && nil == self.window) {
        
    }
    
    self.images = guideImages;
    self.skipButtonTitle = skipButtonTitle;
    self.experienceButtonImage = experienceButtonImage;
    //self.pageControl.numberOfPages = guideImages.count;
    self.window = [UIApplication sharedApplication].keyWindow;
    [self.window addSubview:self.view];
    //[self.window addSubview:self.pageControl];
    
    [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"version_%@", version]];
    [userDefaults synchronize];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GuideViewCell forIndexPath:indexPath];
    
    UIImage *guideImage = [UIImage imageNamed:self.images[indexPath.row]];
    CGSize size = [self adapterSizeImageSize:guideImage.size compareSize:kScreenViewBounds.size];
    
    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
    cell.guideImageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.guideImageView.image = guideImage;
    cell.guideImageView.center = CGPointMake(kScreenViewBounds.size.width / 2, kScreenViewBounds.size.height / 2);
    
    if (indexPath.row == self.images.count - 1) {
        [cell.skipButton setHidden:YES];
        [cell.experienceButton setHidden:NO];
        [cell.experienceButton addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.experienceButton setImage:self.experienceButtonImage forState:UIControlStateNormal];
        [cell.experienceButton setImage:self.experienceButtonImage forState:UIControlStateHighlighted];
        
    } else {
        [cell.experienceButton setHidden:YES];
        [cell.skipButton setHidden:NO];
        [cell.skipButton addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.skipButton setTitle:self.skipButtonTitle forState:UIControlStateNormal];
        [cell.skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

/**
 *  计算自适应的图片
 *
 *  @param is 需要适应的尺寸
 *  @param cs 适应到的尺寸
 *
 *  @return 适应后的尺寸
 */
- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / kScreenViewBounds.size.width);
}

/**
 *  点击立即体验按钮响应事件
 *
 *  @param sender sender
 */
- (void)nextButtonHandler:(id)sender {
    
    [self.view removeFromSuperview];
    [self setWindow:nil];
    [self setView:nil];
    [self setPageControl:nil];
}

@end
