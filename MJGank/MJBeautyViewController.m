//
//  MJBeautyViewController.m
//  MJGank
//
//  Created by WangMinjun on 15/8/10.
//  Copyright (c) 2015年 WangMinjun. All rights reserved.
//

#import "MJBeautyViewController.h"
#import "MJBeautyDetailViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MJImageCollectionViewCell.h"
#import "MJGankHTTPManager.h"
#import "MJMagicMovePresentTransition.h"
#import "NormalDismissAnimation.h"

#define CELL_IDENTIFIER @"MJImageCollectionViewCell"

@interface MJBeautyViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, UIViewControllerTransitioningDelegate, MJBeautyDetailViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation MJBeautyViewController

#pragma mark - Accessors

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout* layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MJImageCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (NSMutableArray*)images
{
    if (!_images) {
        _images = [NSMutableArray new];
    }
    return _images;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MJGankHTTPManager sharedManager] getDataWithType:@"福利"
        num:10
        pageNum:1
        success:^(MJGankHTTPManager* manager, id data) {
            for (NSDictionary* dict in data) {
                MJImage* image = [[MJImage alloc] initWithURL:dict[@"url"]];
                [self.images addObject:image];
            }
            [self.collectionView reloadData];
        }
        failure:^(MJGankHTTPManager* manager, NSError* error) {
            NSLog(@"%@", error);
        }];

    [self.view addSubview:self.collectionView];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MJImageCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.image = self.images[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MJBeautyDetailViewController* detailVC = [MJBeautyDetailViewController new];
    //    detailVC.image = self.images[indexPath.row];
    detailVC.images = self.images;
    detailVC.currentIndex = indexPath.row;
    detailVC.transitioningDelegate = self;
    detailVC.delegate = self;
    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MJImage* image = self.images[indexPath.row];
    return image.size;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController*)presenting sourceController:(UIViewController*)source
{
    return [MJMagicMovePresentTransition new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController*)dismissed
{
    return [NormalDismissAnimation new];
}
#pragma mark - MJBeautyDetailViewControllerDelegate

- (void)beautyDetailViewControllerDidDismiss:(MJBeautyDetailViewController*)beautyDetailViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    CHTCollectionViewWaterfallLayout* layout = (CHTCollectionViewWaterfallLayout*)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

@end