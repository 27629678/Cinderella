//
//  PostBoardViewController.m
//  Unity-iPhone
//
//  Created by H-YXH on 14-1-14.
//
//

#import "PostBoardViewController.h"

@interface PostBoardViewController ()

@end

@implementation PostBoardViewController
@synthesize urlString;
@synthesize webViewWidth;
@synthesize webViewHeight;

static PostBoardViewController* sInstance = nil;
+ (void)LoadWebViewWithURL:(NSString*)url
{
    PostBoardViewController* view = [[PostBoardViewController alloc] init];
    [view setUrlString:url];
    [view setWebViewWidth:800];
    [view setWebViewHeight:600];
    
    UIViewController* rootView = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [rootView presentViewController:view animated:NO completion:nil];
    sInstance = view;
    [view release];
}

+ (void)LoadWebViewWithDictioanary:(NSDictionary*) dict
{
    NSString* url   = [NSString stringWithFormat:@"%@", [dict objectForKey:@"url"]];
    NSInteger width = [[dict objectForKey:@"width"] integerValue];
    NSInteger height= [[dict objectForKey:@"height"] integerValue];
    
    [self LoadWebViewWithURL:url Width:width Height:height];
}

+ (void)LoadWebViewWithURL:(NSString*)url Width:(NSInteger)width Height:(NSInteger)height
{
    NSLog(@"%@", url);
    PostBoardViewController* view = [[PostBoardViewController alloc] init];
    [view setUrlString:url];
    [view setWebViewWidth:width];
    [view setWebViewHeight:height];
    
    UIViewController* rootView = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [rootView presentViewController:view animated:NO completion:^(){
        sInstance = view;
        NSLog(@"Load Finished");
    }];
    
    [view release];
}

- (IBAction)closeButtonAction:(id)sender {
    if (sInstance != nil) {
        [sInstance dismissViewControllerAnimated:NO completion:nil];
    }
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
    
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
    
    //  设置背景图片大小及位置
    CGRect frame = self.BGImageView.frame;
    frame.origin.x = self.view.frame.size.width/2 - self.webViewWidth/2;
    frame.origin.y = self.view.frame.size.height/2 - self.webViewHeight/2;
    frame.size.width = self.webViewWidth;
    frame.size.height = self.webViewHeight;
    [self.BGImageView setFrame:frame];
    
    //  设置WebView大小及位置
    frame = self.webView.frame;
    frame.origin.x = self.view.frame.size.width/2 - self.webViewWidth/2;
    frame.origin.y = self.view.frame.size.height/2 - self.webViewHeight/2;
    frame.size.width = self.webViewWidth;
    frame.size.height = self.webViewHeight;
    [self.webView setFrame:frame];
    
    //  设置关闭按钮的位置
    frame = self.closeButton.frame;
    frame.origin.x = self.webView.frame.origin.x + self.webViewWidth - self.closeButton.frame.size.width/2 - 5;
    frame.origin.y = self.webView.frame.origin.y - self.closeButton.frame.size.height/2 + 5;
    [self.closeButton setFrame:frame];
    
    for (id subview in self.webView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            ((UIScrollView *)subview).scrollEnabled = NO;
            ((UIScrollView *)subview).delegate = self;
        }
    }
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self.webView setHidden:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
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
    [_closeButton release];
    [_BGImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setCloseButton:nil];
    [super viewDidUnload];
}
@end
