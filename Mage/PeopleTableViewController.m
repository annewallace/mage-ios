//
//  PeopleViewController.m
//  Mage
//
//  Created by Billy Newman on 7/14/14.
//

#import "PeopleTableViewController.h"
#import "PersonImage.h"
#import "User+helper.h"
#import "Location+helper.h"
#import "NSDate+DateTools.h"
#import "PersonTableViewCell.h"
#import "MeViewController.h"
#import "MageRootViewController.h"

@implementation PeopleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.peopleDataStore startFetchController];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([[segue identifier] isEqualToString:@"DisplayPersonSegue"]) {
        MeViewController *destination = (MeViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Location *location = [self.peopleDataStore locationAtIndexPath:indexPath];
		[destination setUser:location.user];
    }
}


@end
