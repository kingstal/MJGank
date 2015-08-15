//
//  MJBeautyDetailViewController.h
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import <UIKit/UIKit.h>
#import "MJImage.h"

@class MJBeautyDetailViewController;
@protocol MJBeautyDetailViewControllerDelegate <NSObject>

- (void)beautyDetailViewControllerDidDismiss:(MJBeautyDetailViewController*)beautyDetailViewController;

@end

@interface MJBeautyDetailViewController : UIViewController

@property (nonatomic, strong) NSArray* images;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, weak) id<MJBeautyDetailViewControllerDelegate> delegate;

@end
