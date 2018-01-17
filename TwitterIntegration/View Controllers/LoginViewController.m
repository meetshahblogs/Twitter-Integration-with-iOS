//
//  LoginViewController.m
//  TwitterIntegration
//
//  Created by osxadmin on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "LoginViewController.h"
#import <TwitterKit/TWTRLogInButton.h>
#import "TweetsTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
    if (session) {
      NSLog(@"signed in as %@", [session userName]);
      
      //Go to TweetsTableViewController
      TweetsTableViewController *tweetsViewController = [[TweetsTableViewController alloc] initWithNibName:@"TweetsTableViewController" bundle:nil];
      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
      [self presentViewController:navController animated:YES completion:nil];
      
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
