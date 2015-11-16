
#import <UIKit/UIKit.h>
#import "ObjConnector.h"


void copyFiles(){
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"huiguniang.sqlite"];
    NSLog(@"app path:%@",documentsDirectory);
    NSLog(@"file path:%@",filePath);
    NSLog(@"%@",[[NSBundle mainBundle] resourcePath]);
    NSString *path = [[NSBundle mainBundle] resourcePath];
    path = [path stringByAppendingString:@"/files/huiguniang.sqlite"];
    
//    NSLog(@"%@", path); // "one two"
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"txt"];
    //NSLog(@"app bundle path:%@",path);
    
    success = [fileManager fileExistsAtPath:filePath];
    NSLog(@"results:%d",success);
    if (!success) {
        NSLog(@"run into copy");
        success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
    }
}



int main(int argc, char *argv[]) {
    //ObjConnector *o = [[ObjConnector alloc] init];
    //
    //WebViewControllerV2 *w = [[WebViewControllerV2 alloc] init];
    //print all the fonts:
    copyFiles();
    
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }

    
    
    
    //[o listenRequest:1];
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    int retVal = UIApplicationMain(argc, argv, nil, @"AppController");
    [pool release];
    return retVal;
}
