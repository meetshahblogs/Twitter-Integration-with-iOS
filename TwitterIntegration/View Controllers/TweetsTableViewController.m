//
//  TwittsTableViewController.m
//  TwitterIntegration
//
//  Created by Meet Shah on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "TweetsTableViewController.h"
#import <TwitterKit/TWTRComposer.h>
#import <TwitterKit/TWTRAPIClient.h>
#import <TwitterKit/TWTRTwitter.h>
#import <TwitterKit/TWTRTweetView.h>


@interface TweetsTableViewController ()

@end

@implementation TweetsTableViewController
@synthesize tweetsArray;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"My Tweets";
  UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweets)];
  self.navigationItem.rightBarButtonItem = twitterButton;

  tweetsArray = [[NSMutableArray alloc] init];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self getMyTweets];
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

-(void) getMyTweets {
  NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
  TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
  [client loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
    if (tweet) {
      self.tableView confi
      TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
      [self.view addSubview:tweetView];
    } else {
      NSLog(@"Error loading Tweet: %@", [error localizedDescription]);
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
