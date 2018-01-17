//
//  TweetItemTableViewCell.m
//  TwitterIntegration
//
//  Created by Meet Shah on 1/17/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "TweetItemTableViewCell.h"

@implementation TweetItemTableViewCell
@synthesize avatar_image;
@synthesize name;
@synthesize screen_name;
@synthesize tweet_text;
@synthesize created_date;

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  //https://developer.twitter.com/en/developer-terms/display-requirements
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

-(void) setCustomTweetItemTableViewCell:(TweetItem *)item {
  NSData *imageData = [NSData dataWithContentsOfURL: item.image_url];
  [avatar_image setImage:[UIImage imageWithData:imageData]];
  name.text = item.name;
  screen_name.text = item.screen_name;
  tweet_text.text = item.text;
  created_date.text = item.created_at;
}

@end
