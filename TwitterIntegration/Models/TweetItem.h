//
//  TweetItem.h
//  TwitterIntegration
//
//  Created by Meet Shah on 1/17/18.
//  Copyright © 2018 Meet Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetItem : NSObject

@property NSString *text;
@property NSString *name;
@property NSString *screen_name;
@property NSDate *created_at;
@property NSURL *image_url;

-(id) initWithText:(NSString *)text name:(NSString *)name screen_name:(NSString *)screen_name created_at:(NSDate *)created_at image_url:(NSURL *)image_url;

@end
