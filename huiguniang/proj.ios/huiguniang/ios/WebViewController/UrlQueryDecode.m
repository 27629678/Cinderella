//
//  UrlQueryDecode.m
//  WebViewDemo
//
//  Created by H-YXH on 13-12-6.
//  Copyright (c) 2013年 H-YXH. All rights reserved.
//

#import "UrlQueryDecode.h"

#define GameObjListener             @"Download"
#define CallbackFunction            @"WebViewControllerDismissedDidFinished"

#define Callback_BabyInfo           @"WebViewBabyInfoSetting"
#define Callback_StudentIDApply     @"WebViewStudentIDCreate"
#define callback_CourseSetting      @"WebViewCourseSetting"

#define kProp                       @"prop"             //宝物页面
#define kApply                      @"apply"            //申请学号
#define kBabyInfo                   @"babyinfo"         //宝宝资料

@implementation UrlQueryDecode

+ (void)decode:(NSString*)query
{
    NSString* message = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",message);
    //UnitySendMessage([GameObjListener UTF8String], [CallbackFunction UTF8String], [message UTF8String]);
    return;
    
//    NSArray* components = [query componentsSeparatedByString:@"&"];
//    NSMutableDictionary* parameters = [[[NSMutableDictionary alloc] init] autorelease];
//    
//    for (NSString* component in components)
//    {
//        NSArray* subComponents = [component componentsSeparatedByString:@"="];
//        [parameters setObject:[subComponents objectAtIndex:1] forKey:[subComponents objectAtIndex:0]];
//    }
//    
//    NSString* type      = [parameters valueForKey:@"type"];
//    NSString* action    = [parameters valueForKey:@"action"];
//    
//    if (type != nil && action != nil)
//    {
//        NSLog(@"Type:%@,Action:%@",type,action);
//        
//        if ([type isEqualToString:kProp])
//        {
//            if ([action isEqualToString:@"1"])
//            {
//                
//            }
//            else if ([action isEqualToString:@"0"])
//            {
//                //do nothing
//            }
//            
//            return;
//        }
//        
//        if ([type isEqualToString:kApply])
//        {
//            if ([action isEqualToString:@"1"])
//            {
//                NSString* nick = [NSString stringWithFormat:@"%@",[parameters valueForKey:@"nick"]];
//                nick = [nick stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSString* message = [NSString stringWithFormat:@"%@|%@|%@", [parameters valueForKey:@"num"], nick, [parameters valueForKey:@"gender"]];
//                UnitySendMessage([GameObjListener UTF8String], [Callback_StudentIDApply UTF8String], [message UTF8String]);
//            }
//            else if ([action isEqualToString:@"0"])
//            {
//                //do nothing
//            }
//            
//            return;
//        }
//        
//        if ([type isEqualToString:kBabyInfo])
//        {
//            if ([action isEqualToString:@"1"])
//            {
//                NSString* nick = [NSString stringWithFormat:@"%@",[parameters valueForKey:@"nick"]];
//                nick = [nick stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSString* message = [NSString stringWithFormat:@"%@|%@|%@", [parameters valueForKey:@"num"], nick, [parameters valueForKey:@"gender"]];
//                UnitySendMessage([GameObjListener UTF8String], [Callback_BabyInfo UTF8String], [message UTF8String]);
//            }
//            else if ([action isEqualToString:@"0"])
//            {
//                //do nothing
//            }
//            
//            return;
//        }
//    }
    
    
}
@end
