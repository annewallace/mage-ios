//
//  TimeFilter.h
//  MAGE
//
//  Created by William Newman on 5/12/16.
//  Copyright © 2016 National Geospatial Intelligence Agency. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TimeFilterType) {
    TimeFilterAll,
    TimeFilterLastHour,
    TimeFilterLast6Hours,
    TimeFilterLast12Hours,
    TimeFilterLast24Hours,
    TimeFilterToday
};

@interface TimeFilter : NSObject

extern NSString * const kTimeFilterKey;



+ (TimeFilterType) getTimeFilter;
+ (void) setTimeFilter:(TimeFilterType) timeFilter;
+ (UIAlertController *) createFilterActionSheet;


+ (NSString *) getTimeFilterString;

@end
