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
#import <TwitterKit/TWTRUser.h>


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
  
  //Load multiple tweets
//  NSArray *tweetIDs = @[@"953333786233720833", @"953118892607537152"];
//  [client loadTweetsWithIDs:tweetIDs completion:^(NSArray<TWTRTweet *> * _Nullable tweets, NSError * _Nullable error) {
//    if (tweets.count != 0) {
//      tweetsArray = [[NSMutableArray alloc] initWithArray:tweets];
//      for (TWTRTweet *tweet in tweets) {
//        TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
//        [self.view addSubview:tweetView];
//      }
//    }
//  }];
  
//  //Load single Tweet
//  [client loadTweetWithID:@"953333786233720833" completion:^(TWTRTweet *tweet, NSError *error) {
//    if (tweet) {
//      TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
//      [self.view addSubview:tweetView];
//    } else {
//      NSLog(@"Error loading Tweet: %@", [error localizedDescription]);
//    }
//  }];

   //https://developer.twitter.com/en/docs/basics/authentication/overview/application-only

  NSString *consumerKeyString = @"0Xjp7X7Ju32ciTg8HQdozCNRA";
  NSString *encodedConsumerKeyString = [consumerKeyString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  
  NSString *consumerSecretKeyString = @"Q1CZkcVNI54Rc9KZXzU1aMRk9xTim1eqoz8T2hVR2yQeM4LN3k";
  NSString *encodedConsumerSecretKeyString = [consumerSecretKeyString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  
  NSString *combinedString = [NSString stringWithFormat:@"%@:%@", encodedConsumerKeyString, encodedConsumerSecretKeyString];
  NSData *data = [combinedString dataUsingEncoding:NSUTF8StringEncoding];
  NSString *encodedString = [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:0]];

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"]];
  [request setHTTPMethod:@"POST"];
  [request setValue:encodedString forHTTPHeaderField:@"Authorization"];
  [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  
  NSData *bodyData = [@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];

  [request setHTTPBody:bodyData];
  
  NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (data) {
      NSError *error;
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      if (dict) {
        NSLog(@"%@", dict);
        NSLog(@""%@, [dict valueForKey:@"access_token"]);
      }
    }
    if (error) {
      NSLog(@"%@", error.localizedDescription);
    }
    if (response) {
      NSLog(@"%@", response.debugDescription);
    }
  }];
  
  [dataTask resume];
  
  //Load Twitter user
//  [client loadUserWithID:userID completion:^(TWTRUser *user, NSError *error) {
//    if (user) {
//
//      NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=10", user.screenName];
//      NSURL *url = [NSURL URLWithString:urlString];
//
//      NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        if (data) {
//          NSError *error;
//          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//          if (dict.allValues.count > 0) {
//
//          }
//        }
//        if (response) {
//        }
//        if (error) {
//
//        }
//      }];
//
//      [downloadTask resume];
//    }
//
//  }];

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
