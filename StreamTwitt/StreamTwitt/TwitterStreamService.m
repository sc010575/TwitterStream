//
//  TwitterStreamService.m
//  StreamTwitt
//
//  Created by Suman Chatterjee on 16/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "TwitterStreamService.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TwittUtil.h"

@interface TwitterStreamService ()

//Propertiy
@property (assign, nonatomic) NSInteger numberOfRecords;
@property (assign, nonatomic) NSInteger counter;

@end


@implementation TwitterStreamService

- (instancetype) initWithSearchString:(NSString*) text andNumberOfRequest:(NSInteger) numberOfRecords delegate:(id<TwitterSreamServiceDelegate>) delegate
{
    self = [super init];
    if (self){
        
        _numberOfRecords = numberOfRecords;
        _delegate = delegate;
        [self getTwitterStream:text];
    }
    return self;
}

- (void) getTwitterStream:(NSString*) text
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *accounts = [account accountsWithAccountType:accountType];
    
    if(accounts.count == 0)
    {
        if([self.delegate respondsToSelector:@selector(noTwitterAccountSetUp)])
        {
            [self.delegate noTwitterAccountSetUp];
        }
        return;
    }
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:
                                      @"https://stream.twitter.com/1.1/statuses/filter.json"];
                 
                 NSDictionary *params = @{@"track":text}; //This is not working @{@"track":@"banking", @"count":@"10"};!!!
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:params];
                 
                 postRequest.account = twitterAccount;
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSURLConnection *aConn = [NSURLConnection connectionWithRequest:[postRequest preparedURLRequest] delegate:self];
                     [aConn start];
                 });
                 
             }
         } else {
             // Handle failure to get account access
             if(self.delegate)
             {
                 [self.delegate twitterStreamServiceError];
             }
         }
     }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //Dubug Purpose Only
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dataString: %@", dataString);
    
    NSError *error;
    NSDictionary * object = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&error];
    //Feed Text
    NSString * text = object[@"text"];
    if(![TwittUtil isEmptyString:text]){
        
        //User dict to find out who post it
        NSDictionary *userDict = object[@"user"];
   
        NSString * name = ([TwittUtil isEmptyString:userDict[@"name"]])? @"Twitter":userDict[@"name"];
        NSString *imageUrl = userDict[@"profile_image_url"];
        NSString *createdAt = userDict[@"created_at"];
        NSString *backgroundColor = userDict[@"profile_background_color"];
        NSString *url = userDict[@"url"];
        NSString *description = userDict[@"description"];
        NSDictionary * twittDict = @{@"text":text,@"name":name};
        if([self.delegate respondsToSelector:@selector(twitterFeedAvailable:)])
        {
            [self.delegate twitterFeedAvailable:twittDict];
            self.counter ++ ;
            
        }
    }
    if(self.counter >= self.numberOfRecords) {
        
        if(self.delegate)
        {
            [self.delegate twitterFeedLoadFinished];
            self.counter = 0;
        }
        [connection cancel];
    }
    
}




@end
