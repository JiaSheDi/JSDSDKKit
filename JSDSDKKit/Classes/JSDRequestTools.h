//
//  JSDRequestTools.h
//  ceshi
//
//  Created by 假设敌 on 2021/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^response)(NSDictionary *data);
@interface JSDRequestTools : NSObject
-(void)JSDPostRequsetwithUrl:(NSString *)url parameters:(NSDictionary *)paraments response:(response)response;
@end

NS_ASSUME_NONNULL_END
