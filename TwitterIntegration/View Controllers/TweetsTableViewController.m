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

#import "TweetItem.h"
#import "TweetItemTableViewCell.h"

@interface TweetsTableViewController ()


@end

@implementation TweetsTableViewController
@synthesize tweetsArray;
@synthesize appDelegate;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"My Tweets";
  UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweets)];
  self.navigationItem.rightBarButtonItem = twitterButton;
  
  tweetsArray = [[NSMutableArray alloc] init];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  //Register custom TweetItem UITableViewCell
  UINib *customCellNIB = [UINib nibWithNibName:@"TweetItemTableViewCell" bundle:nil];
  [self.tableView registerNib:customCellNIB forCellReuseIdentifier:@"customCell"];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self getTwitterOath2AccessToken];
  });
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

-(void) getMyTweets : (NSString *) accessToken {
  
  if (![accessToken isEqualToString:@""]) {
    
    //Create TWTRAPIClient
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
    
    //Get Twitter user
    [client loadUserWithID:userID completion:^(TWTRUser *user, NSError *error) {
      if (user) {
        
        //Get user's timeline tweets
        NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=%@&count=10", user.screenName];
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
              for (NSDictionary *tweetDict in dictItemsArray) {
                TweetItem *tweetItem = [self mapTweetItem:tweetDict];
                [tweetsArray addObject:tweetItem];
              }
              
              dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
              });
            }
            
            if (error) {
              NSLog(@"%@", error.localizedDescription);
            }
            
            if (response) {
              NSLog(@"%@", response.debugDescription);
            }
          }
        }];
        
        [dataTask resume];
      }
    }];
    
  }
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

-(TweetItem *) mapTweetItem : (NSDictionary *) dict {
  NSDictionary *user_dict = [dict valueForKey:@"user"];
  NSString *dateString = [dict valueForKey:@"created_at"];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  NSDate *date = [dateFormatter dateFromString:dateString];
  
  TweetItem *tweetItem = [[TweetItem alloc] initWithText:[dict valueForKey:@"text"] name:[user_dict valueForKey:@"name"] screen_name:[NSString stringWithFormat:@"@%@", [user_dict valueForKey:@"screen_name"]] created_at:[dateFormatter dateFromString: [dict valueForKey:@"created_at"]] image_url:[NSURL URLWithString:[user_dict valueForKey:@"profile_image_url_https"]]];
  
  return tweetItem;
}

-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
  CALayer *imageLayer = [CALayer layer];
  imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  imageLayer.contents = (id) image.CGImage;
  
  imageLayer.masksToBounds = YES;
  imageLayer.cornerRadius = radius;
  
  UIGraphicsBeginImageContext(image.size);
  [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return roundedImage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"TweetItemTableViewCell";
  TweetItemTableViewCell *customFeedCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (customFeedCell == nil) {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TweetItemTableViewCell" owner:self options:nil];
    
    for (id currentobject in objects) {
      if ([currentobject isKindOfClass:[UITableViewCell class]]) {
        customFeedCell = (TweetItemTableViewCell *) currentobject;
        break;
      }
    }
  }
  
  [customFeedCell setCustomTweetItemTableViewCell: [tweetsArray objectAtIndex:indexPath.row]];
  
  return customFeedCell;
}

@end
