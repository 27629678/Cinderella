//
//  NEStoryAPIManager.h
//  NEStorySDK
//
//  Created by H-YXH on 14-4-22.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NEStoryAPIManager : NSObject<NSURLConnectionDelegate,NSFileManagerDelegate>

+ (NEStoryAPIManager*)sharedManager;

/**
 *  网易识字学习流程设置
 */
- (void)synchronousWitheLearnApp;

/**
 *  处理向故事App请求的URL_Scheme
 *
 *  @param url 请求App的Url_Scheme
 *
 *  @return 数据传递成功返回YES，失败返回NO
 */
- (BOOL)handleUrl:(NSURL*)url;

/**
 *  注册课程设置完毕后回调方法
 *
 *  @param dict {listener = callback}
 */
- (void)registeCourseSettingCallback:(NSDictionary*)dict;

/**
 *  注册网易识字传递学习数据后进行读故事回调方法
 *
 *  @param dict {listener = callback}
 */
- (void)registeBeganReadStoryCallback:(NSDictionary*)dict;
@end
