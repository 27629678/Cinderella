//
//  NEStoryAPIDefines.h
//  NEStorySDK
//
//  Created by H-YXH on 14-4-17.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#ifndef NEStorySDK_NEStoryAPIDefines_h
#define NEStorySDK_NEStoryAPIDefines_h

/**
 *  Debug开关
 *
 *  @param ... 与NSLog使用方法一致
 *
 *  @return Debug开关开启则终端打印Log，否则什么都不做
 */
#define ENABLE_DEBUG_LOG 0

#ifdef ENABLE_DEBUG_LOG
#define DMLog(...) NSLog(@"\n\t日志:\n\t方法:%s \n\t行号:%d \n\t内容:%@\n\n", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DMLog(...) {}
#endif

/**
 *  故事App的Url_Scheme
 */
#define URL_SCHEME_STORY_APP                        @"cinderella"

/**
 *  与网易识字进行同步学习进度所使用的url_scheme
 */
#define URL_SCHEME_MAIN_APP                         @"elearn"

/**
 *  故事App的URL中的Host字段
 */
#define URL_HOST_FOR_STORY_BOOK                     @"61.163.com"

/**
 *  网易识字的URL中的Host字段
 */
#define URL_HOST_FOR_MAIN_APP                       @"61.163.com"

/**
 *  同步学习进度的lastPathComponent
 */
#define LAST_PATH_COMPONENT_FOR_SYNCHRONOUS         @"settingstorybook"

/**
 *  存储学习进度数据的lastPathComponent
 */
#define LAST_PATH_COMPONENT_FOR_STORE_DATA          @"readstory"

/**
 *  网易识字设置学习流程返回状态的lastPathComponent
 */
#define LAST_PATH_COMPONENT_FOR_SETTING_STATUS      @"coursesetting"

/**
 *  对网易识字App最低版本号需求
 */
#define kMainAppSDKRequireVersion                   @"2.0.0"

/**
 *  供故事书使用的数据在粘贴板中的索引
 */
#define kPasteBoardType_AudioFile                   @""

/**
 *  粘贴板-音频文件数据Key
 */
#define kDictionaryAudioFilePath                    @"StoryBookAudioFilePathKey"

/**
 *  由网易识字传递过来的章节信息
 */
#define kDictionaryChapterInfo                      @"ChapterInfoKey"

/**
 *  故事书设置成功后的回调的Url.lastPathComponent
 */
#define kSettingStoryStatus                         @"settingstatus"
#endif
