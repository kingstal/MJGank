//
//  MJGankHTTPManager.h
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#import <Foundation/Foundation.h>
@class MJGankHTTPManager;

typedef void (^MJGankHTTPManagerErrorBlock)(MJGankHTTPManager* manager, NSError* error);
typedef void (^MJGankHTTPManagerSuccessBlock)(MJGankHTTPManager* manager, id data);

@interface MJGankHTTPManager : NSObject

+ (instancetype)sharedManager;

- (void)getDataWithType:(NSString*)type num:(NSUInteger)num pageNum:(NSUInteger)pageNum success:(MJGankHTTPManagerSuccessBlock)successBlock failure:(MJGankHTTPManagerErrorBlock)errorBlock;

- (void)getDataWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MJGankHTTPManagerSuccessBlock)successBlock failure:(MJGankHTTPManagerErrorBlock)errorBlock;

@end
