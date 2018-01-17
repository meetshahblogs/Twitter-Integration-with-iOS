//
//  TweetItem.m
//  TwitterIntegration
//
//  Created by Meet Shah on 1/17/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import "TweetItem.h"

@implementation TweetItem

@synthesize text;
@synthesize name;
@synthesize screen_name;
@synthesize created_at;
@synthesize image_url;


-(id) initWithText:(NSString *)text name:(NSString *)name screen_name:(NSString *)screen_name created_at:(NSDate *)created_at image_url:(NSURL *)image_url {
  if (self = [super init]) {
    self.text = text;
    self.name = name;
    self.screen_name= screen_name;
    self.created_at = created_at;
    self.image_url = image_url;
  }
  
  return self;
}
@end
