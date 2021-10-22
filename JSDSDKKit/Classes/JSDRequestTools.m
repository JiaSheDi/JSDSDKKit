//
//  JSDRequestTools.m
//  ceshi
//
//  Created by 假设敌 on 2021/10/22.
//

#import "JSDRequestTools.h"
#import "AFNetworking.h"

@interface JSDRequestTools ()

@property(nonatomic, strong) AFHTTPSessionManager *JSDHttpManager;

@end

@implementation JSDRequestTools

-(instancetype)init{
    if (self == [super init]) {
        
        _JSDHttpManager = [AFHTTPSessionManager manager];
        _JSDHttpManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _JSDHttpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _JSDHttpManager.responseSerializer = [AFJSONResponseSerializer serializer];

        _JSDHttpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"application/xml",@"application/xhtml_xml",@"text/xml",@"*/*", nil];
        [_JSDHttpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _JSDHttpManager.requestSerializer.timeoutInterval = 17.0f;
        [_JSDHttpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:YES];
        _JSDHttpManager.securityPolicy = securityPolicy;
        
    }
    return self;
}


-(void)JSDPostRequsetwithUrl:(NSString *)url parameters:(NSDictionary *)paraments response:(response)response{
    NSString *urlString=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [_JSDHttpManager POST:urlString parameters:paraments headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        response(dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}


@end
