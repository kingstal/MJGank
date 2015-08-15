//
//  MJImage.h
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJImage : NSObject

@property (nonatomic, copy) NSString* url;
@property (nonatomic, assign) CGSize size;

- (instancetype)initWithURL:(NSString*)url;

@end
