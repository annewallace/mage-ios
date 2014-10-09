//
//  ObservationCheckboxTableViewCell.m
//  MAGE
//
//  Created by Dan Barela on 9/25/14.
//  Copyright (c) 2014 National Geospatial Intelligence Agency. All rights reserved.
//

#import "ObservationCheckboxTableViewCell.h"

@implementation ObservationCheckboxTableViewCell

- (void) populateCellWithFormField: (id) field andObservation: (Observation *) observation {
    id value = [observation.properties objectForKey:(NSString *)[field objectForKey:@"name"]];
    [self.checkboxSwitch setOn:[value boolValue]];
    [self.keyLabel setText:[field objectForKey:@"title"]];
}

- (CGFloat) getCellHeightForValue: (id) value {
    return self.bounds.size.height;
}

@end