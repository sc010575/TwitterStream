//
//  TwitterStreamService.h
//  StreamTwitt
//
//  Created by Suman Chatterjee on 16/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterSreamServiceDelegate <NSObject>

- (void)twitterFeedAvailable:(NSDictionary *) twitterData;
- (void)twitterFeedLoadFinished;
- (void)twitterStreamServiceError;

@optional

- (void)noTwitterAccountSetUp;

@end

@interface TwitterStreamService : NSObject

//Delegate
@property (weak, nonatomic) id<TwitterSreamServiceDelegate> delegate;

- (instancetype)initWithSearchString:(NSString*) text andNumberOfRequest:(NSInteger) numberOfRecords delegate:(id<TwitterSreamServiceDelegate>) delegate;

@end
