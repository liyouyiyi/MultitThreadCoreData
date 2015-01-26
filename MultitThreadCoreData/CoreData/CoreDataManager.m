//
//  CoreDataManager.m
//  LiYouNote
//
//  Created by ChuanYou Xie on 1/6/15.
//  Copyright (c) 2015 CRF. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()



@end

@implementation CoreDataManager


+ (id)shareInstance
{
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        //mergedModelFromBundles: 搜索工程中所有的.xcdatamodeld文件，并加载所有的实体到一个NSManagedObjectModel  实例中。这样托管对象模型知道所有当前工程中用到的托管对象的定义
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persisstentStoreCoordinator
{
    if (_persisstentStoreCoordinator == nil) {
        _persisstentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filepath = [path stringByAppendingPathComponent:@"LiYouNote.sqlite"];
        NSError *error = nil;
        [_persisstentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:filepath] options:nil error:&error];
        NSLog(@"error = %@", error);
    }
    
    return _persisstentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persisstentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return _managedObjectContext;
}

- (void)_mocDidSaveNotification:(NSNotification *)notification
{
    NSLog(@"NSManagedObjectContext 有变化");
    NSManagedObjectContext *savedContext = [notification object];
    
    
    if (self.managedObjectContext == savedContext)
    {
        return;
    }
    
    if (self.managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

@end
