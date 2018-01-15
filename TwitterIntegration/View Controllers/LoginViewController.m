//
//  LoginViewController.m
//  TwitterIntegration
//
//  Created by osxadmin on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize twitterLoginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
