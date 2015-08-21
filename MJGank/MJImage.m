//
//  MJImage.m
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import "MJImage.h"

@implementation MJImage

- (instancetype)initWithURL:(NSString*)url
{
    if (self = [super init]) {
        _url = url;
        CGSize size = CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 50);
        _size = size;
    }
    return self;
}

@end
