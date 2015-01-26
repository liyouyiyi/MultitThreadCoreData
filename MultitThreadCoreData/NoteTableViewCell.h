//
//  NoteTableViewCell.h
//  LiYouNote
//
//  Created by ChuanYou Xie on 1/6/15.
//  Copyright (c) 2015 CRF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface NoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setUpCell:(Note *)note;

@end
