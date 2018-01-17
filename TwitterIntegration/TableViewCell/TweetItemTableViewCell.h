//
//  TweetItemTableViewCell.h
//  TwitterIntegration
//
//  Created by Meet Shah on 1/17/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetItem.h"

@interface TweetItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar_image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *created_date;

-(void) setCustomTweetItemTableViewCell : (TweetItem *) item;

@end
