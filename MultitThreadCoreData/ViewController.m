//
//  ViewController.m
//  MultitThreadCoreData
//
//  Created by ChuanYou Xie on 1/26/15.
//  Copyright (c) 2015 Liyouyiyi. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "Note.h"

#define TABLE_NAME @"Note"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addNote:(id)sender {
    [self add];
}
- (IBAction)queryNote:(id)sender {
    [self searchResult];
}
- (IBAction)goUp:(id)sender {
    
}

- (void)add
{
    Note *note = (Note *)[NSEntityDescription insertNewObjectForEntityForName:TABLE_NAME inManagedObjectContext:[[CoreDataManager shareInstance] managedObjectContext]];
    note.title = @"记事1";
    note.noteid = @"1003";
    note.date = [NSDate date];
    note.content = @"这是一个值得期待的记事本";
    
    NSError *error = nil;
    if ([[[CoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"添加成功");
    } else {
        NSLog(@"添加失败 Error = %@", error);
    }
}

- (NSArray *)searchResult
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


@end
