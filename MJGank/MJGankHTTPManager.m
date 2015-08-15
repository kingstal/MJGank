//
//  MJGankHTTPManager.m
//
//
//  Created by WangMinjun on 15/8/15.
//
//

#define CATEGORYURL @"http://gank.avosapps.com/api/data/%@/%lu/%lu"

#import "MJGankHTTPManager.h"
#import "AFNetworking.h"

@implementation MJGankHTTPManager

+ (instancetype)sharedManager
{
    static MJGankHTTPManager* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (AFHTTPRequestOperationManager*)JSONRequestOperationManager
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

- (void)getDataWithType:(NSString*)type num:(NSUInteger)num pageNum:(NSUInteger)pageNum success:(MJGankHTTPManagerSuccessBlock)successBlock failure:(MJGankHTTPManagerErrorBlock)errorBlock
{
    NSString* url = [[NSString stringWithFormat:CATEGORYURL, type, (unsigned long)num, (unsigned long)pageNum] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[self JSONRequestOperationManager] GET:url
        parameters:nil
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            successBlock(self, responseObject[@"results"]);
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            errorBlock(self, error);
        }];
}

@end
