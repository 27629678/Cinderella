//
//  PostBoardViewController.h
//  Unity-iPhone
//
//  Created by H-YXH on 14-1-14.
//
//  添加如下两个方法for Lua
//  + (void)LoadWebViewWithDictioanary:(NSDictionary*) dict;
//  + (void)LoadWebViewWithURL:(NSString*)url Width:(NSInteger)width Height:(NSInteger)height;
//  by:sddz_yuxiaohua@corp.netease.com
//  at:2014-03-10

#import <UIKit/UIKit.h>

@interface PostBoardViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSString* urlString;
    NSInteger webViewWidth;
    NSInteger webViewHeight;
}

@property (nonatomic, retain) NSString* urlString;
@property (readwrite, nonatomic) NSInteger webViewWidth;
@property (readwrite, nonatomic) NSInteger webViewHeight;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UIImageView *BGImageView;

+ (void)LoadWebViewWithURL:(NSString*)url;

/* *******************************
 *  Load Web View With Dictionary
 *  使用字典加载WebView
 *  @for Lua
 * ******************************/
+ (void)LoadWebViewWithDictioanary:(NSDictionary*) dict;

+ (void)LoadWebViewWithURL:(NSString*)url Width:(NSInteger)width Height:(NSInteger)height;

- (IBAction)closeButtonAction:(id)sender;
@end
