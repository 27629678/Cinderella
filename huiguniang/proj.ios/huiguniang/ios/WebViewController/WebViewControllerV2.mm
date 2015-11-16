//
//  WebViewControllerV2.m
//  Unity-iPhone
//
//  Created by H-YXH on 13-10-16.
//
//
#import "WebViewControllerV2.h"
void UnityPause( bool pause );

@interface WebViewControllerV2 ()

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIView *loadingView;
- (IBAction)returnButtonAction:(id)sender;
@end

@implementation WebViewControllerV2
@synthesize webView = _webView;
@synthesize titleLabel = _titleLabel;
@synthesize loadingView = _loadingView;
@synthesize urlWebviewLoading;
@synthesize callbackBlock;
@synthesize titleName;
@synthesize webViewWidth;
@synthesize webViewHeight;

static WebViewControllerV2* _instance = nil;

+ (WebViewControllerV2*)sharedController
{
//    if (!_instance) {
//        static dispatch_once_t oncePredicate;
//        dispatch_once(&oncePredicate, ^{
//            _instance = [[super allocWithZone:nil]init];
//        });
//    }
    
    return _instance;
}

//+ (void)LoadWebview:(NSString *)url Width:(NSInteger)width Height:(NSInteger)height
+ (void)LoadWebview:(NSDictionary*)dict
{
    NSString* url = @"http://61.163.com";
    NSInteger width = 0;
    NSInteger height = 0;
    
    if ([dict objectForKey:@"url"])
    {
        url = [NSString stringWithFormat:@"%@", [dict objectForKey:@"url"]];
    }
    else
    {
        return;
    }
    
    if ([dict objectForKey:@"width"])
    {
        width = [[dict objectForKey:@"width"] integerValue];
    }
    else
    {
        width = 1024;
    }
    
    if ([dict objectForKey:@"height"])
    {
        height = [[dict objectForKey:@"height"] integerValue];
    }
    else
    {
        height = 768;
    }
    
    [self LoadWebviewWithTitle:url Width:width Height:height];
}

+ (void)LoadWebviewWithTitle:(NSString *)url Width:(NSInteger)width Height:(NSInteger)height
{
    WebViewControllerV2* view = [[WebViewControllerV2 alloc]init];
    
    _instance               = view;
    view.titleName          = @"";
    view.urlWebviewLoading  = url;
    view.gameObject         = @"";
    view.callbackBlock      = @"";
    view.webViewWidth       = width;
    view.webViewHeight      = height;
    
    UIViewController* rootView = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [rootView presentViewController:view animated:NO completion:nil];
    [view release];
}

+ (void)LoadWebviewWithTitle:(NSString*)title URL:(NSString*)url CallbackObject:(NSString*)object CallbackMethod:(NSString*)block
{
    WebViewControllerV2* view = [[WebViewControllerV2 alloc]init];
    
    _instance               = view;
    view.titleName          = title;
    view.urlWebviewLoading  = url;
    view.gameObject         = object;
    view.callbackBlock      = block;
    view.webViewWidth       = 1024;
    view.webViewHeight      = 768;
    
    UIViewController* rootView = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [rootView presentViewController:view animated:NO completion:nil];
    [view release];
}

+ (void)CloseWebView
{
    [[WebViewControllerV2 sharedController] returnButtonAction:nil];
}

- (void)dismissWebview
{
    [self returnButtonAction:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //webview config
    
    [self.webView setFrame:CGRectMake(0, 0, self.webViewWidth, self.webViewHeight)];
    
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
    [self.view addSubview:self.loadingView];
    
    self.titleLabel.text = self.titleName;
    
    if (!self.urlWebviewLoading) {
        self.urlWebviewLoading = @"http://61.163.com";
    }
    [self LoadWebViewWithURL:[NSURL URLWithString:self.urlWebviewLoading]];
    
    for (id subview in self.webView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            ((UIScrollView *)subview).scrollEnabled = NO;
            ((UIScrollView *)subview).delegate = self;
        }
    }
}


- (void)LoadWebViewWithURL:(NSURL*)url
{
    self.urlWebviewLoading = url.description;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)returnButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    _instance = nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Web View Did Finish Load:\nRequest Url:%@\t Width:%d, Height:%d", self.urlWebviewLoading, self.webViewWidth, self.webViewHeight);
    
    [self.loadingView removeFromSuperview];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"URL:%@",request.URL.description);
    
    if ([@"ios" isEqualToString:request.URL.scheme] && request.URL.query != nil)
    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        _instance = nil;
        
        [UrlQueryDecode decode:request.URL.query];
        
        return NO;
    }
    
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSError* errorDic = error;
    NSLog(@"%@",[errorDic userInfo]);
    NSString* message = [errorDic localizedDescription];
    switch ([errorDic code]) {
        case -999:
        case -1100:
        case -1012:
            //The operation couldn’t be completed
            message = @"请求无法完成";
            break;
            
        case -1000:
            //bad URL
            message = @"URL不完整";
            break;
            
        case -1001:
            //The request timed out
            message = @"请求超时，网络不给力啊，加油";
            break;
            
        case -1002:
            //unsupported URL
            message = @"URL地址无效";
            break;
            
        case -1003:
            //A server with the specified hostname could not be found
            message = @"无法连接到服务器";
            break;
            
        case -1004:
            //couldn't connect to the server
            message = @"无法连接到服务器,请检查网络设置";
            break;
            
        default:
            message = @"服务器正在偷懒，请稍候再试";
            break;
    }
    
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [view show];
    [view release];
}

- (void)RefreshMarkCount:(int)count
{
    NSLog(@"Mark Count:%d", count);
    
    NSString* js = [NSString stringWithFormat:@"downloadCounting(%d)",count];
    
    NSString* result = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    NSLog(@"JS Excute Result:%@", result);
}

+ (BOOL)excuteJavaScriptWithCodeSegment:(NSString*)code
{
    NSString* result = [[[WebViewControllerV2 sharedController] webView] stringByEvaluatingJavaScriptFromString:code];
    
    if (![result isEqualToString:NULL]) {
        return YES;
    }
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self returnButtonAction:nil];
            break;
        case 1:
            [self LoadWebViewWithURL:[NSURL URLWithString:self.urlWebviewLoading]];
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationPortrait && toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#ifdef __IPHONE_6_0
-(BOOL)shouldAutorotate
{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
#endif

- (void)dealloc {
    [_webView release];
    [_titleLabel release];
    [_loadingView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setTitleLabel:nil];
    [self setLoadingView:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
