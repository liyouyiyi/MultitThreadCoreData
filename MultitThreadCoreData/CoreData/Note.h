//
//  Note.h
//  LiYouNote
//
//  Created by ChuanYou Xie on 1/6/15.
//  Copyright (c) 2015 CRF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * noteid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;

@end
