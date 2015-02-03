//
//  AppDelegate.m
//  LazyCode
//
//  Created by penghe on 15/1/4.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "AppDelegate.h"
#import "PHNetWorkClient.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    PHLog(@"%@",[[PHSandbox libCachePath]stringByAppendingPathComponent:@"QQ_V3.0.0.dmg"]);
    [PHNetWorkClient sharedClient].requestTimeoutInterval = 2.0;
    [[PHNetWorkClient sharedClient] GET:@"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V3.0.0.dmg" param:nil filePath:[[PHSandbox libCachePath]stringByAppendingPathComponent:@"QQ_V3.0.0.dmg"] shouldResume:YES downloadProgress:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
    NSLog(@"%ld",(long)bytesRead);

} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    PHLog(nil, @"Download succeed", @"ok");

} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    PHLog(nil, @"Download failed",  @"ok");

}];
    [self setURlCache];

    return YES;
}
- (void)setURlCache
{
    //10M 内存大小
    int cacheSizeMemory = 10*1024*1024;
    //硬盘 大小 100M
    int cacheSizeDisk = 100*1024*1024;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"LazyCodeURLCache"];
    [NSURLCache setSharedURLCache:sharedCache];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end
