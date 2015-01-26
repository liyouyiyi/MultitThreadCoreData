//
//  NoteListViewController.m
//  LiYouNote
//
//  Created by ChuanYou Xie on 1/6/15.
//  Copyright (c) 2015 CRF. All rights reserved.
//

#import "NoteListViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Note.h"
#import "NoteTableViewCell.h"

#define TABLE_NAME @"Note"

@interface NoteListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"Del" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithTitle:@"Upd" style:UIBarButtonItemStylePlain target:self action:@selector(update)];
    
    UIBarButtonItem *query = [[UIBarButtonItem alloc] initWithTitle:@"Que" style:UIBarButtonItemStylePlain target:self action:@selector(query)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:add, delete, update, query, nil];
}

static int indexn = 3;
- (void)add
{
    Note *note = (Note *)[NSEntityDescription insertNewObjectForEntityForName:TABLE_NAME inManagedObjectContext:[[CoreDataManager shareInstance] managedObjectContext]];
    note.title = [NSString stringWithFormat:@"记事%d", indexn];
    note.noteid = @"1003";
    note.date = [NSDate date];
    note.content = [NSString stringWithFormat:@"这是一个值得期待的记事本%d", indexn];
    
    NSError *error = nil;
    if ([[[CoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"添加成功");
    } else {
        NSLog(@"添加失败 Error = %@", error);
    }
    indexn++;
}

- (NSArray *)query
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *desption = [NSEntityDescription entityForName:TABLE_NAME inManagedObjectContext:[[CoreDataManager shareInstance] managedObjectContext]];
    [request setEntity:desption];
    
    NSError *error = nil;
    NSArray *result = [[[CoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:&error];
    if (!error) {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"--%lu,%@ -- /n",(unsigned long)idx, ((Note *)obj).title);
        }];
    } else {
        NSLog(@"error seach  = %@",error);
    }
    
    return result;
}

- (void)delete
{
    NSArray *result = [self query];
    __block Note *deletemp;
    [result enumerateObjectsUsingBlock:^(Note *note, NSUInteger idx, BOOL *stop) {
        if ([note.title isEqualToString:@"记事1"]) {
            deletemp = note;
            *stop = YES;
        }
    }];
    
    if (deletemp) {
        [[[CoreDataManager shareInstance] managedObjectContext] deleteObject:deletemp];
        
        NSError *error = nil;
        if ([[[CoreDataManager shareInstance] managedObjectContext] save:&error]) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败 Error = %@", error);
        }
    }
    
    
}

- (void)update
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        NSArray *result = [self query];
//        
//        for (Note *note in result) {
//            if ([note.title isEqualToString:@"记事34"]) {
//                note.title = @"记事35";
//                note.date = [NSDate date];
//                break;
//            }
//        }
//        NSError *error = nil;
//        error = nil;
//        if ([[CoreDataManager GetManagedObjectContext] save:&error]) {
//            NSLog(@"更新成功");
//        } else {
//            NSLog(@"更新失败 Error = %@", error);
//        }
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self query];
//        });
//    });
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[[CoreDataManager shareInstance] persisstentStoreCoordinator]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *desption = [NSEntityDescription entityForName:TABLE_NAME inManagedObjectContext:context];
        [request setEntity:desption];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!error) {
            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"--%lu,%@ -- /n",(unsigned long)idx, ((Note *)obj).title);
            }];
        } else {
            NSLog(@"error seach  = %@",error);
        }
        
        for (Note *note in result) {
            if ([note.title isEqualToString:@"记事1"]) {
                note.title = @"记事2";
                note.date = [NSDate date];
                break;
            }
        }
        error = nil;
        if ([context save:&error]) {
            NSLog(@"更新成功");
        } else {
            NSLog(@"更新失败 Error = %@", error);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self query];
        });
    });
    
    
//    if (updateTemp) {
//
//        NSError *error = nil;
//        if ([[CoreDataManager GetManagedObjectContext] save:&error]) {
//            NSLog(@"删除成功");
//        } else {
//            NSLog(@"删除失败 Error = %@", error);
//        }
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.fetchedResultsController sections].count > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteTableViewCell" forIndexPath:indexPath];
    
    Note *note = (Note *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setUpCell:note];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = [sectionInfo name];
    headLabel.backgroundColor = [UIColor lightGrayColor];
    
    return headLabel;
}

#pragma mark - Instance Method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *desption = [NSEntityDescription entityForName:TABLE_NAME inManagedObjectContext:[[CoreDataManager shareInstance] managedObjectContext]];
        [request setEntity:desption];
        
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"noteid" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
        
        NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[CoreDataManager shareInstance] managedObjectContext] sectionNameKeyPath:@"noteid" cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if ([_fetchedResultsController performFetch:&error]) {
            NSLog(@"success");
        } else {
            NSLog(@"error = %@", error);
        }
    }
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            NoteTableViewCell *cell = (NoteTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            Note *note = (Note *)[controller objectAtIndexPath:indexPath];
            [cell setUpCell:note];
        }
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
