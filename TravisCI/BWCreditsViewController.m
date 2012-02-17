//
//  BWCreditsViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCreditsViewController.h"

@interface BWCreditsViewController ()
- (void)goToGithub;
@end

@implementation BWCreditsViewController
@synthesize credits, forkMe;

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

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (UIEventSubtypeMotionShake == motion) {
        if (YES == self.forkMe.hidden) {
            self.forkMe.hidden = NO;
            [UIView animateWithDuration:1.0f animations:^{
                self.forkMe.alpha = 1.0f;
            }];
        } else {
            [UIView animateWithDuration:1.0f animations:^{
                self.forkMe.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.forkMe.hidden = YES;
            }];
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.forkMe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forkme.png"]];
    self.forkMe.hidden = YES;
    self.forkMe.alpha = 0.0f;
    self.forkMe.frame = CGRectMake(0.0f, 0.0f, 149.0f, 149.0f);

    self.forkMe.userInteractionEnabled = YES;
    UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToGithub)];
    [self.forkMe addGestureRecognizer:gestureRecognizer];

    [self.view addSubview:self.forkMe];
    [self.view bringSubviewToFront:self.forkMe];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.forkMe removeFromSuperview];
    self.forkMe = nil;
}

- (void)goToGithub
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/bendyworks/TravisCI.app"]];
}

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
    cell.accessibilityTraits |= UIAccessibilityTraitLink;

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
