//
//  Locations.m
//  MAGE
//
//

#import "Locations.h"
#import "Location.h"
#import "Server.h"
#import "TimeFilter.h"

@implementation Locations

NSString * const kHideInactiveFilterKey = @"hideInactiveFilterKey";

+ (BOOL) getHideInactiveFilter {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kHideInactiveFilterKey];
}

+ (void) setHideInactivedFilter:(BOOL) filter {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:filter forKey:kHideInactiveFilterKey];
    [defaults synchronize];
}

+ (id) locationsForAllUsers {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *predicates = [NSMutableArray arrayWithObjects:
                                  [NSPredicate predicateWithFormat:@"eventId == %@", [Server currentEventId]],
                                  [NSPredicate predicateWithFormat:@"user.remoteId != %@", [prefs valueForKey:@"currentUserId"]],
                                  nil];
    
    if ([Locations getHideInactiveFilter]) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:-30*60];
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K>= %@", @"timestamp", date]];
    } else {
        NSPredicate *timePredicate = [TimeFilter getTimePredicateForField:@"timestamp"];
        if (timePredicate) {
            [predicates addObject:timePredicate];
        }
    }
    
    NSFetchedResultsController *fetchedResultsController = [Location MR_fetchAllSortedBy:@"timestamp"
                        ascending:NO
                    withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]
                          groupBy:nil
                         delegate:nil
                        inContext:[NSManagedObjectContext MR_defaultContext]];
    
    
    return [[Locations alloc] initWithFetchedResultsController:fetchedResultsController];
}

+ (id) locationsForUser:(User *) user {
    NSFetchedResultsController *fetchedResultsController = [Location MR_fetchAllSortedBy:@"timestamp"
                                                                               ascending:NO
                                                                           withPredicate:[NSPredicate predicateWithFormat:@"user = %@ AND eventId == %@", user, [Server currentEventId]]
                                                                                 groupBy:nil
                                                                                delegate:nil
                                                                               inContext:[NSManagedObjectContext MR_defaultContext]];
    
    return [[Locations alloc] initWithFetchedResultsController:fetchedResultsController];
}

- (id) initWithFetchedResultsController:(NSFetchedResultsController *) fetchedResultsController {
    if (self = [super init]) {
        self.fetchedResultsController = fetchedResultsController;
    }
    
    return self;
}

- (void) setDelegate:(id<NSFetchedResultsControllerDelegate>)delegate {
    self.fetchedResultsController.delegate = delegate;
}

@end
