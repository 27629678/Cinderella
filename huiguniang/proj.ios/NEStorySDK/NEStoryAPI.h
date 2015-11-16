//
//  NEStoryAPI.h
//  NEStorySDK
//
//  Created by H-YXH on 14-4-17.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NEStoryAPI : NSObject
+ (BOOL)handleOpenUrl:(NSURL*)url;

+ (void)SynchronousLearningProgressWithElearnApp;

+ (void)RegistBeganReadStoryCallback:(NSDictionary*)dictionary;

+ (void)RegistSynchronousLearningProgressCallback:(NSDictionary*)dictionary;
@end
