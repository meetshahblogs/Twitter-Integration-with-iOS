//
//  LoginViewController.h
//  TwitterIntegration
//
//  Created by osxadmin on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TWTRLogInButton.h>
@interface LoginViewController : UIViewController

@property (nonatomic, copy) TWTRLogInButton *twitterLoginButton;

@end
