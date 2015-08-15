//
//  MJImageCollectionViewCell.m
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import "MJImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MJImageCollectionViewCell ()

@end

@implementation MJImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.clipsToBounds = false;
        self.layer.borderWidth = 10;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = ([UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1]).CGColor;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 6);

        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = true;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.alpha = 0.0;
}

- (void)setImage:(MJImage*)image
{
    _image = image;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image.url]
                             completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
                                 [UIView animateWithDuration:0.5
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      self.imageView.alpha = 1.0;
                                                  }
                                                  completion:nil];
                             }];
}

@end
