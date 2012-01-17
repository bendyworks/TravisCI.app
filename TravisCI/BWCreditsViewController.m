//
//  BWCreditsViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWCreditsViewController.h"

@implementation BWCreditsViewController
@synthesize credits;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.credits = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Bendyworks", @"name", @"developed this app", @"why", @"http://bendyworks.com", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Heroku", @"name", @"application platform", @"why", @"http://heroku.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Enterprise Rails", @"name", @"3 worker boxes", @"why", @"http://enterprise-rails.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Engine Yard", @"name", @"2 worker boxes", @"why", @"http://engineyard.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Railslove", @"name", @"a worker box", @"why", @"http://railslove.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Shopify", @"name", @"a worker box & shop", @"why", @"http://shopify.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Pusher", @"name", @"\"big boy\" account for realtime messaging", @"why", @"http://pusherapp.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Postmark", @"name", @"unlimited email delivery", @"why", @"http://postmarkapp.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"thoughtbot", @"name", @"large airbrake plan", @"why", @"http://thoughtbot.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"ServerGrove", @"name", @"php worker box", @"why", @"http://servergrove.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"RedisToGo", @"name", @"hosting redis", @"why", @"http://redistogo.com/", @"site", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Site5", @"name", @"hosting amqp broker", @"why", @"http://gk.site5.com/t/393", @"site", nil],
                    nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.credits = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation { return YES; }

#pragma mark - Dismissal

- (IBAction)closeModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.credits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sponsor = [self.credits objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"Value1Style";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [cell.textLabel setText:[sponsor valueForKey:@"name"]];
    [cell.detailTextLabel setText:[sponsor valueForKey:@"why"]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = (NSString *)[[self.credits objectAtIndex:indexPath.row] valueForKey:@"site"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"open: %@", url);
    [[UIApplication sharedApplication] openURL:url];
}

@end
