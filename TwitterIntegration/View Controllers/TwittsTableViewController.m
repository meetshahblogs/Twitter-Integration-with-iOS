//
//  TwittsTableViewController.m
//  TwitterIntegration
//
//  Created by Meet Shah on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "TwittsTableViewController.h"
#import <TwitterKit/TWTRComposer.h>

@interface TwittsTableViewController ()

@end

@implementation TwittsTableViewController
@synthesize tweetsArray;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"My Tweets";
  UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweets)];
  self.navigationItem.rightBarButtonItem = twitterButton;

  tweetsArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Helpers
-(void) composeTweets {
  TWTRComposer *composer = [[TWTRComposer alloc] init];
  
  [composer setText:@"just setting up my Twitter Kit"];
  [composer setImage:[UIImage imageNamed:@"twitterkit"]];
  [composer showFromViewController:self completion:^(TWTRComposerResult result) {
    if (result == TWTRComposerResultCancelled) {
      NSLog(@"Tweet composition cancelled");
    }
    else {
      NSLog(@"Sending Tweet!");
    }
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return NULL;
}

@end
