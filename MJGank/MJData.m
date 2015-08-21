//
//  MJData.m
//
//
//  Created by WangMinjun on 15/8/16.
//
//

#import "MJData.h"

@implementation MJData

- (instancetype)initWithTitle:(NSString*)title URL:(NSString*)url
{
    if (self = [super init]) {
        self.title = title;
        self.url = url;
    }
    return self;
}
@end
