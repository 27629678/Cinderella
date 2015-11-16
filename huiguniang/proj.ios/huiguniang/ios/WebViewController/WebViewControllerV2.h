//
//  WebViewControllerV2.h
//  Unity-iPhone
//
//  Created by H-YXH on 13-10-16.
//
//

#import <UIKit/UIKit.h>
#import "UrlQueryDecode.h"

@interface WebViewControllerV2 : UIViewController<UIWebViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    NSString* urlWebviewLoading;
    NSString* callbackBlock;
    NSString* titleName;
    NSInteger webViewWidth;
    NSInteger webViewHeight;
}
@property (retain, nonatomic) NSString* urlWebviewLoading;
@property (retain, nonatomic) NSString* callbackBlock;
@property (retain, nonatomic) NSString* titleName;
@property (retain, nonatomic) NSString* gameObject;
@property (readwrite, nonatomic) NSInteger webViewWidth;
@property (readwrite, nonatomic) NSInteger webViewHeight;

+ (WebViewControllerV2*)sharedController;

/* ************************
 *  Load Web View With Url
 *  使用URL加载WebView
 *  @for Lua
 * ***********************/
+ (void)LoadWebview:(NSString *)url;

+ (void)LoadWebviewWithTitle:(NSString*)title URL:(NSString*)url CallbackObject:(NSString*)object CallbackMethod:(NSString*)block;
- (void)LoadWebViewWithURL:(NSURL*)url;

/* ************************
 *  Close Web View
 *  关闭WebView
 *  @for Lua
 * ***********************/
+ (void)CloseWebView;

- (void)dismissWebview;

- (void)RefreshMarkCount:(NSInteger)count;

/* ************************
 *  Excute Java Script With Code Segment
 *  在WebView中执行JS代码
 *  @for Lua
 * ***********************/
+ (BOOL)excuteJavaScriptWithCodeSegment:(NSString*)code;
@end
