//
//  TwittTableViewCell.m
//  StreamTwitt
//
//  Created by Suman Chatterjee on 17/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "TwittTableViewCell.h"

@interface TwittTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *twittLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation TwittTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWithText:(NSString *)text name:(NSString*)name{
    self.twittLabel.text = text;
    self.nameLabel.text = [NSString stringWithFormat:@"Posted by: %@", name];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.twittLabel.text = @"";
    self.nameLabel.text = @"";
}


@end
