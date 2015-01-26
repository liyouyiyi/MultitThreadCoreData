//
//  NoteTableViewCell.m
//  LiYouNote
//
//  Created by ChuanYou Xie on 1/6/15.
//  Copyright (c) 2015 CRF. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "Note.h"

@implementation NoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setUpCell:(Note *)note;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *title = note.title;
    NSString *date = [dateFormatter stringFromDate:note.date];
    
    self.titleLabel.text = title;
    self.dateLabel.text = date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
