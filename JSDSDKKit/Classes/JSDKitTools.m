//
//  JSDKitTools.m
//  ceshi
//
//  Created by 假设敌 on 2021/10/22.
//

#import "JSDKitTools.h"
#import "JSDMarcoHeader.h"
#import "HTTPServer.h"
#import "SSZipArchive.h"


@interface JSDKitTools ()

@property (nonatomic, strong) HTTPServer *localHttpServer;
@property (nonatomic, copy) NSString *JSDPort;


@end
@implementation JSDKitTools

-(BOOL)JSDisYueyuji{
    #ifdef DEBUG
        return NO;
    #else
        if ([self JSDisSimulators]) return NO; // Dont't check simulator
        
        NSArray *paths = @[@"/Applications/Cydia.app",
                           @"/private/var/lib/apt/",
                           @"/private/var/lib/cydia",
                           @"/private/var/stash"];
        for (NSString *path in paths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
        }
        
        FILE *bash = fopen("/bin/bash", "r");
        if (bash != NULL) {
            fclose(bash);
            return YES;
        }
        
        NSString *path = [NSString stringWithFormat:@"/private/%@", [self JSDcfWithUUID]];
        if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            return YES;
        }
        
        return NO;
    #endif
}

- (BOOL)JSDisSimulators
{
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        return YES;
    }else{
        //真机
        return NO;
    }
}

- (NSString *)JSDcfWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}


-(void)JSDisYueyu{
    if ([self JSDisYueyuji]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *wenjianPath = [NSString stringWithFormat:@"%@%@",[self JSDStoreDir],[self base64Decode:Marco_FilePath]];
        if ([fileManager fileExistsAtPath:wenjianPath]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:wenjianPath error:nil];
        }
    }
}

- (NSString *)JSDStoreDir{
    NSString *path = [NSString stringWithFormat:@"%@/%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      @""];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

- (NSString *)base64Decode:(NSString *)str{
    //注意：该字符串是base64编码后的字符串
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)JSDsetupLocalHttpServer{
    _localHttpServer = [[HTTPServer alloc]init];
    [_localHttpServer setType:@"_http.tcp"];
    NSString *webPath = [self JSDUSSZipArchive];
    if (webPath.length > 0) {
        [_localHttpServer setDocumentRoot:webPath];
        [self JSDStarServer];
    }
    
}

- (void)JSDStarServer{
    NSError *error = nil;
    if ([_localHttpServer start:&error]) {
        self.JSDPort = [NSString stringWithFormat:@"%d",[_localHttpServer listeningPort]];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:self.JSDPort forKey:@"webPort"];
        [accountDefaults synchronize];
    }
}

- (NSString *)JSDUSSZipArchive{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
   // 获取zip文件的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:Marco_ZipName ofType:@"zip"];
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *destinationPath =[cachesPath stringByAppendingPathComponent:@"SSZipArchive"];

    BOOL isSuccess = [SSZipArchive unzipFileAtPath:filePath toDestination:destinationPath overwrite:YES password:Maraco_ZipPasswd error:nil];

    if (isSuccess) {
        NSString *path = [destinationPath stringByAppendingPathComponent:@"yuanqisanguo/Web"];
        if ([fileManager fileExistsAtPath:path]) {
            return path;
        }
    }
    return @"";
}





@end
