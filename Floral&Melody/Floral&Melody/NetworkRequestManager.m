//
//  NetworkRequestManager.m
//  项目02_PCH头文件
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 BF. All rights reserved.
//

#import "NetworkRequestManager.h"

@implementation NetworkRequestManager

+(void)createPostRequestWithUrl:(NSString *)urlString withBody:(NSString *)body finish:(RequestFinish)finish error:(RequestError)err
{
    NetworkRequestManager *manager = [[NetworkRequestManager alloc]init];
    //通过参数的传递,在"-"号方法中进行数据处理
    [manager createPostRequestWithUrl:urlString withBody:body finish:finish error:err];
}
-(void)createPostRequestWithUrl:(NSString *)urlString withBody:(NSString *)body finish:(RequestFinish)finish error:(RequestError)err
{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//识别汉字
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url];
    [mRequest setHTTPMethod:@"POST"];
    if (body != nil) {
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        [mRequest setHTTPBody:data];
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:mRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            
            finish(data);
            
        }else{
            err(error);
        }
    }];
    
    [task resume];

}
                            
                            
@end
