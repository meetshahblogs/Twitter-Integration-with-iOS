//
//  AppDelegate.h
//  TwitterIntegration
//
//  Created by osxadmin on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *consumerKey;
@property (strong, nonatomic) NSString *consumerSecretKey;
@property (strong, nonatomic) NSString *twitterAPIUrl;

@end

