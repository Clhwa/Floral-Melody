//
//  NetworkRequestManager.h
//  项目02_PCH头文件
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 BF. All rights reserved.
//

#import <Foundation/Foundation.h>



//定义一个请求结束时的block作为回调
typedef void(^RequestFinish) (NSData *data);
//定义一个请求失败时的block作为回调
typedef void(^RequestError) (NSError *error);

@interface NetworkRequestManager : NSObject


+(void)createPostRequestWithUrl:(NSString *)urlString withBody:(NSString *)body finish:(RequestFinish)finish error:(RequestError)err;


@end
