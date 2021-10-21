//
//  AppDelegate.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/10.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [JPUtil createJperFolder];
    [JPUtil createJperFolderInDocument];
    [JPUtil loadCustomFont];
    
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = [[ViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}





@end
