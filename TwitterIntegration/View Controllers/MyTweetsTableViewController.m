//
//  MyTweetsTableViewController.m
//  TwitterIntegration
//
//  Created by Meet Shah on 1/17/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "MyTweetsTableViewController.h"
#import <TwitterKit/TWTRTwitter.h>
#import <TwitterKit/TWTRAPIClient.h>
#import <TwitterKit/TWTRUser.h>
#import <TwitterKit/TWTRTweetTableViewCell.h>
#import <TwitterKit/TWTRComposer.h>


@interface MyTweetsTableViewController ()

@end

@implementation MyTweetsTableViewController
@synthesize appDelegate;
@synthesize tweetsArray;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  tweetsArray = [[NSMutableArray alloc] init];
  
  self.navigationItem.title = @"My Tweets";
  
  //Set Tweet compose button
  UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweet)];
  self.navigationItem.rightBarButtonItem = tweetButton;
  
  self.tableView.estimatedRowHeight = 150;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.allowsSelection = false;
  [self.tableView registerClass:TWTRTweetTableViewCell.class forCellReuseIdentifier:@"tweetTableReuseIdentifier"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self getTwitterOath2AccessToken];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return tweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TWTRTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetTableReuseIdentifier"];
  cell.tweetView.delegate= self;
//  cell.tweetView.style = TWTRTweetViewStyleRegular;
  cell.tweetView.showActionButtons = YES;
  [cell configureWithTweet:[tweetsArray objectAtIndex:indexPath.row]];
  return cell;
}


#pragma mark - Helpers

-(void) composeTweet {
  TWTRComposer *composer = [[TWTRComposer alloc] init];
  
  [composer setText:@"just setting up my Twitter iOS Kit"];
  [composer setImage:[UIImage imageNamed:@"Mickey_Mouse"]];
  
  // Called from a UIViewController
  [composer showFromViewController:self completion:^(TWTRComposerResult result) {
    if (result == TWTRComposerResultCancelled) {
      NSLog(@"Tweet composition cancelled");
    }
    else {
      NSLog(@"Sending Tweet!");
    }
  }];
}
-(void) getTwitterOath2AccessToken {
  __block NSString *accessToken = @"";
  
  //https://developer.twitter.com/en/docs/basics/authentication/overview/application-only
  
  //RFC 1738 encoding of consumerKey and consumerSecretKey
  NSString *encodedConsumerKeyString = [appDelegate.consumerKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  NSString *encodedConsumerSecretKeyString = [appDelegate.consumerSecretKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  
  //Combine both with :
  NSString *combinedString = [NSString stringWithFormat:@"%@:%@", encodedConsumerKeyString, encodedConsumerSecretKeyString];
  
  //Base64 encoding
  NSData *data = [combinedString dataUsingEncoding:NSUTF8StringEncoding];
  NSString *encodedString = [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:0]];
  
  //Create URL request
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"]];
  [request setHTTPMethod:@"POST"];
  [request setValue:encodedString forHTTPHeaderField:@"Authorization"];
  [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  NSData *bodyData = [@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:bodyData];
  
  //Create NSURLSession task
  NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (data) {
      NSError *error;
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      if (dict) {
        accessToken = [dict valueForKey:@"access_token"];
        
        [self getMyTweets:accessToken];
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
}

-(void) getMyTweets : (NSString *) accessToken {
  
  if (![accessToken isEqualToString:@""]) {
    
    //Create TWTRAPIClient
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
    
    //Get Twitter user
    [client loadUserWithID:userID completion:^(TWTRUser *user, NSError *error) {
      if (user) {
        
        //Get user's timeline tweets
        NSString *urlString = [NSString stringWithFormat:[appDelegate twitterAPIUrl], user.screenName];
        //        NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=10", user.screenName];
        NSURL *url = [NSURL URLWithString:urlString];
        
        //Create NSURLConnection
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
          if (data) {
            NSError *error;
            NSArray *dictItemsArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (dictItemsArray.count > 0) {
              NSMutableArray *tweetsIDsArray = [[NSMutableArray alloc] initWithCapacity:dictItemsArray.count];
              for (NSDictionary *tweetDict in dictItemsArray) {
                [tweetsIDsArray addObject: [NSString stringWithFormat:@"%@", [tweetDict valueForKey:@"id"]]];
              }
              
              [client loadTweetsWithIDs:tweetsIDsArray completion:^(NSArray<TWTRTweet *> * _Nullable tweets, NSError * _Nullable error) {
                if (tweets) {
                  for (TWTRTweet *tweet in tweets) {
                    [tweetsArray addObject:tweet];
                  }
                  [self.tableView reloadData];
                } else {
                  NSLog(@"Error loading Tweet: %@", [error localizedDescription]);
                }
              }];
              
            }
            
            if (error) {
              NSLog(@"%@", error.localizedDescription);
            }
            
            if (response) {
              //NSLog(@"%@", response.debugDescription);
            }
          }
        }];
        
        [dataTask resume];
      }
    }];
    
  }
}

@end
