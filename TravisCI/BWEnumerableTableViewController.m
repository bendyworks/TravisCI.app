//
//  BWJobConfigTableViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/13/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWEnumerableTableViewController.h"

@interface BWEnumerableTableViewController ()

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index; //for array-based tables
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtKey:(NSString *)key; // for dictionary-based tables

@end


@implementation BWEnumerableTableViewController


@synthesize data;

#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.data performSelector:@selector(count)];
}

// for array-based tables
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"JobConfigCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    id value = [self.data objectAtIndex:index];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([[value class] respondsToSelector:@selector(string)]) {
        [cell.textLabel setText:(NSString *)value];
    } else if ([value class] == [NSNumber class]) {
        [cell.textLabel setText:[(NSNumber *)value stringValue]];
    } else {
        @throw @"Deep arrays not supported";
    }

    return cell;
}

// for dictionary-based tables
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtKey:(NSString *)key
{
    static NSString *CellIdentifier = @"JobConfigCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText:key];
    id value = [self.data objectForKey:key];

    if ([[value class] respondsToSelector:@selector(dictionary)] || [[value class] respondsToSelector:@selector(array)]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.detailTextLabel setText:@""];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setText:[value description]];
    }
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.data class] respondsToSelector:@selector(dictionary)]) {
        NSArray *sortedKeys = [[self.data allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSString *key = [sortedKeys objectAtIndex:indexPath.row];

        return [self tableView:tableView cellForRowAtKey:key];
    } else {
        return [self tableView:tableView cellForRowAtIndex:indexPath.row];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        BWEnumerableTableViewController *nextController = [[self storyboard] instantiateViewControllerWithIdentifier:@"BWEnumerableTableViewController"];

        NSArray *sortedKeys = [[self.data allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSString *key = [sortedKeys objectAtIndex:indexPath.row];

        nextController.data = [self.data objectForKey:key];
        
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

@end
