//
//  CoreDataManager.h
//  LiYouNote
//
//  Created by ChuanYou Xie on 1/6/15.
//  Copyright (c) 2015 CRF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persisstentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

+ (id)shareInstance;

@end
