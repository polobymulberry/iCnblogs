//
//  ICNetworkTool.m
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICNetworkTool.h"
#import "ICOAuthTool.h"
#import "ICOAuth.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"

#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@implementation ICNetworkTool

+ (void)monitorNetworkStatus
{
    // 监控网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    // 当网络状态改变了，就会调用
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
            {
                ICLog(@"没有网络(断网)");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.labelText = @"网络异常，请检查网络设置";
                [hud hide:YES afterDelay:1.0];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                ICLog(@"有网络");
                break;
            }
            default:
                break;
        }
    }];
}

+ (void)loadDataWithURL:(NSString *)requestURL parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 如果client credentials授权的oauth已经存储在本地了
    // 那么就查看access_token是否过期了，如果过期了，那么还需要重新请求
    if ([ICClientCredentialsOAuthTool isOAuthInfoExistedInStoredData] && ![ICClientCredentialsOAuthTool isAccessTokenExpired:[ICClientCredentialsOAuthTool oauthByStoredData]]) {
        
        ICClientCredentialsOAuth *oauth = [ICClientCredentialsOAuthTool oauthByStoredData];
        
        NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", oauth.access_token];
        [session.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
        
        [session GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            // empty
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [ICClientCredentialsOAuthTool oauthWithClientID:ICClientID clientSecret:ICClientSecret success:^(id responseObject) {
            ICClientCredentialsOAuth *oauth = [ICClientCredentialsOAuth initWithAttribute:responseObject];
            [ICClientCredentialsOAuthTool save:oauth];
            
            NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", oauth.access_token];
            [session.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
            
            [session GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                // empty
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSError *error) {
            ICLog(@"loadDataWithURL failure:%@", error);
        }];
    }

}

+ (void)loadDataWithURL:(NSString *)requestURL success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 如果client credentials授权的oauth已经存储在本地了
    // 那么就查看access_token是否过期了，如果过期了，那么还需要重新请求
    if ([ICClientCredentialsOAuthTool isOAuthInfoExistedInStoredData] && ![ICClientCredentialsOAuthTool isAccessTokenExpired:[ICClientCredentialsOAuthTool oauthByStoredData]]) {
        
        ICClientCredentialsOAuth *oauth = [ICClientCredentialsOAuthTool oauthByStoredData];
        
        NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", oauth.access_token];
        [session.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
        
        [session GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // empty
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [ICClientCredentialsOAuthTool oauthWithClientID:ICClientID clientSecret:ICClientSecret success:^(id responseObject) {
            ICClientCredentialsOAuth *oauth = [ICClientCredentialsOAuth initWithAttribute:responseObject];
            [ICClientCredentialsOAuthTool save:oauth];
            
            NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", oauth.access_token];
            [session.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
            
            [session GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                // empty
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSError *error) {
            ICLog(@"loadDataWithURL failure:%@", error);
        }];
    }
}

+ (void)loadContentWithURL:(NSString *)requestURL success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    // 如果client credentials授权的oauth已经存储在本地了
    // 那么就查看access_token是否过期了，如果过期了，那么还需要重新请求
    if ([ICClientCredentialsOAuthTool isOAuthInfoExistedInStoredData] && ![ICClientCredentialsOAuthTool isAccessTokenExpired:[ICClientCredentialsOAuthTool oauthByStoredData]]) {
        
        ICClientCredentialsOAuth *oauth = [ICClientCredentialsOAuthTool oauthByStoredData];
        
        NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", oauth.access_token];
        [session.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
        
        [session GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // empty
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [ICClientCredentialsOAuthTool oauthWithClientID:ICClientID clientSecret:ICClientSecret success:^(id responseObject) {
            ICClientCredentialsOAuth *oauth = [ICClientCredentialsOAuth initWithAttribute:responseObject];
            [ICClientCredentialsOAuthTool save:oauth];
            
            NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", oauth.access_token];
            [session.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
            
            [session GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                // empty
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSError *error) {
            ICLog(@"loadContentWithURL failure:%@", error);
        }];
    }
}

// 调用此方法之前要自己判断
+ (void)loadUserInfoWithURL:(NSString *)requestURL
    accessTokenSuccessBlock:(void (^)(id))accessTokenSuccessBlock
    accessTokenFailureBlock:(void (^)(NSError *))accessTokenFailureBlock
   refreshTokenSuccessBlock:(void (^)(id))refreshTokenSuccessBlock
   refreshTokenFailureBlock:(void (^)(NSError *))refreshTokenFailureBlock
         noAccessTokenBlock:(void (^)())noAccessTokenBlock
{
    if ([ICOAuthTool isOAuthInfoExistedInStoredData]) {
        ICOAuth *oauth = [ICOAuthTool oauthByStoredData];
        
        if (![ICOAuthTool isAccessTokenExpired:oauth]) {
            [ICNetworkTool loadUserInfoWithURL:requestURL success:^(id responseObject) {
                if (accessTokenSuccessBlock) {
                    accessTokenSuccessBlock(responseObject);
                }
            } failure:^(NSError *error) {
                if (accessTokenFailureBlock) {
                    accessTokenFailureBlock(error);
                }
            }];
        } else if ([ICOAuthTool isRefreshTokenExistedInStoredData:oauth]) {
            [ICOAuthTool oauthWithRefreshToken:oauth.refresh_token success:^(id  _Nullable responseObject) {
                if (refreshTokenSuccessBlock) {
                    refreshTokenSuccessBlock(responseObject);
                }
            } failure:^(NSError * _Nonnull error) {
                if (refreshTokenFailureBlock) {
                    refreshTokenFailureBlock(error);
                }
            }];
        }
    } else {
        if (noAccessTokenBlock) {
            noAccessTokenBlock();
        }
    }
}

+ (void)loadUserInfoWithURL:(NSString *)requestURL success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 请求用户数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", [ICOAuthTool oauthByStoredData].access_token];
    [manager.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    
    [manager GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
