//
//  NEStoryAPI.m
//  NEStorySDK
//
//  Created by H-YXH on 14-4-17.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NEStoryAPI.h"
#import "NEStoryAPIDefines.h"
#import "NEStoryAPIObject.h"
#import "NEStoryAPIManager.h"

@implementation NEStoryAPI

/**
 *  @brief 注册同步学习进度完成后回调方法
 *
 *  @param dictionary eg:{listener = callback}
 */
+ (void)RegistSynchronousLearningProgressCallback:(NSDictionary*)dictionary {
    [[NEStoryAPIManager sharedManager] registeCourseSettingCallback:dictionary];
}

/**
 *  @brief 注册学习数据存储完成后开始读故事的回调方法
 *
 *  @param dictionary eg:{listener = callback}
 */
+ (void)RegistBeganReadStoryCallback:(NSDictionary*)dictionary {
    [[NEStoryAPIManager sharedManager] registeBeganReadStoryCallback:dictionary];
}

/**
 *  @brief 启动网易识字主App进行学习进度同步
 */
+ (void)SynchronousLearningProgressWithElearnApp {
    [[NEStoryAPIManager sharedManager] synchronousWitheLearnApp];
}

/**
 *  @brief 处理识字App打开故事App的URL_Scheme
 *
 *  @param url 故事App的Url_Scheme
 *
 *  @return 数据传递成功返回YES，失败返回NO
 */
+ (BOOL)handleOpenUrl:(NSURL*)url {
    return [[NEStoryAPIManager sharedManager] handleUrl:url];
}
@end
