//
//  AppDelegate.m
//  TwitterIntegration
//
//  Created by osxadmin on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "AppDelegate.h"
#import <TwitterKit/TWTRTwitter.h>
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize consumerSecretKey;
@synthesize consumerKey;
@synthesize twitterAPIUrl;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
  NSDictionary *propertyListDict = [[NSDictionary alloc] initWithContentsOfFile:path];

  consumerKey = [propertyListDict valueForKey:@"TwitterConsumerKey"];
  consumerSecretKey = [propertyListDict valueForKey:@"TwitterConsumerSecretKey"];
  twitterAPIUrl = [propertyListDict valueForKey:@"TwitterAPIUrl"];

  [[Twitter sharedInstance] startWithConsumerKey:consumerKey consumerSecret:consumerSecretKey];
  
  LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
  self.window.rootViewController = loginViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
  return [[Twitter sharedInstance] application:app openURL:url options:options];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
