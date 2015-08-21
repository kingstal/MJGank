//
//  MJData.h
//
//
//  Created by WangMinjun on 15/8/16.
//
//

#import <Foundation/Foundation.h>

@interface MJData : NSObject

@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* title;

- (instancetype)initWithTitle:(NSString*)title URL:(NSString*)url;

@end
