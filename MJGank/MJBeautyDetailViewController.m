//
//  MJBeautyDetailViewController.m
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import "MJBeautyDetailViewController.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MJBeautyDetailViewController ()

@end

@implementation MJBeautyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    MJImage* image = self.images[_currentIndex];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image.url]];

    // 双击 dismiss
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];

    // 右滑 下一张
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeGesture];

    // 左划 上一张
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft; //不设置默认是右
    [self.view addGestureRecognizer:swipeLeftGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyDetailViewControllerDidDismiss:)]) {
        [self.delegate beautyDetailViewControllerDidDismiss:self];
    }
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer*)swipeGesture
{
    UISwipeGestureRecognizerDirection direction = [swipeGesture direction];

    switch (direction) {
    case UISwipeGestureRecognizerDirectionLeft:
        [self nextImage];
        break;
    case UISwipeGestureRecognizerDirectionRight:
        [self preImage];
        break;
    default:
        break;
    }
}

- (void)preImage
{
    if (_currentIndex == 0) {
        return;
    }

    _currentIndex--;

    [self changeImageWithIndex:_currentIndex];
}

- (void)nextImage
{
    if (_currentIndex == _images.count - 1) {
        return;
    }

    _currentIndex++;

    [self changeImageWithIndex:_currentIndex];
}

- (void)changeImageWithIndex:(NSInteger)index
{
    UIView* snapshotView = [self.imageView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = self.imageView.frame;
    [self.view addSubview:snapshotView];

    MJImage* image = self.images[_currentIndex];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image.url]];
    self.imageView.alpha = 0.0;

    [UIView animateWithDuration:0.4
        delay:0.0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            snapshotView.alpha = 0.0;
            self.imageView.alpha = 1.0;
        }
        completion:^(BOOL finished) {
            [snapshotView removeFromSuperview];
        }];
}

@end
