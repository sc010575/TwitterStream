//
//  ViewController.m
//  StreamTwitt
//
//  Created by Suman Chatterjee on 16/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "TwitterViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TwitterStreamService.h"
#import "TwittTableViewCell.h"
#import "TwittUtil.h"


@interface TwitterViewController ()<UITableViewDataSource, UITableViewDelegate,TwitterSreamServiceDelegate,UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *twittTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndecator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)TwitterStreamService *twitterService;
@end

@implementation TwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self setupRefreshControl]; //Not fully implemented
    self.dataSource = [NSMutableArray array];
    self.busyIndecator.tintColor = [UIColor grayColor];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for post";
    self.searchBar.tintColor = [UIColor blueColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"Search"];
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.twittTableView addSubview:self.refreshControl]; //assumes tableView is @property

}

-(void)refresh {
 //   [self setupTwitterService]; //calls [taskDone] when finished
}

-(void)taskDone {
    [self.refreshControl endRefreshing];
    [self.refreshControl removeFromSuperview];
}
- (void)setupTwitterServiceWithText:(NSString*)string
{
    self.twitterService = [[TwitterStreamService alloc] initWithSearchString:string andNumberOfRequest:10 delegate:self];
    [self.busyIndecator startAnimating];
}

#pragma mark - TwitterSreamService delegate


- (void)twitterFeedAvailable:(NSDictionary *) twitterDict
{
    [self.dataSource addObject:twitterDict];
    if(self.dataSource.count != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.twittTableView reloadData];
        });
    }


}
- (void)twitterFeedLoadFinished
{
    //Twitter loading finished
    [self.busyIndecator stopAnimating];
}

- (void)twitterStreamServiceError
{
    //Handle error
    NSLog(@"Account not found");
    [self.busyIndecator stopAnimating];
    [self taskDone];

}

- (void)noTwitterAccountSetUp
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.busyIndecator stopAnimating];
        
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Twitter"
                                   message:@"Please ge to the settings and set up a Twitter account"
                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

    });


}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TwittTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TwittTableViewCell class]) forIndexPath:indexPath];
    
    NSDictionary * twittData = _dataSource[[indexPath row]];
    [cell configureCellWithText:twittData[@"text"] name:twittData[@"name"] ];
    return cell;
}


#pragma mark - search display controller delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
   
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
//    if(!searchText.length){
//        [self checkForRecentSearch];
//        return;
//    }
    
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}



- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if(![TwittUtil isEmptyString:searchBar.text]){
        
        [self setupTwitterServiceWithText:searchBar.text];
        
    }
}

- (void)searchWasCancelled
{
}



@end
