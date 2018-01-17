//
//  TwittsTableViewController.h
//  TwitterIntegration
//
//  Created by Meet Shah on 1/15/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TweetsTableViewController : UITableViewController<NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property AppDelegate *appDelegate;

@end
