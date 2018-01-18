//
//  MyTweetsTableViewController.h
//  TwitterIntegration
//
//  Created by Meet Shah on 1/17/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <TwitterKit/TWTRTweetViewDelegate.h>

@interface MyTweetsTableViewController : UITableViewController<TWTRTweetViewDelegate>

@property AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray*tweetsArray;

@end
