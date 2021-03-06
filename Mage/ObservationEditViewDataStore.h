//
//  ObservationEditViewDataStore.h
//  MAGE
//
//

#import <Foundation/Foundation.h>
#import <Observation.h>
#import "ObservationEditListener.h"
#import "AttachmentSelectionDelegate.h"
#import "ObservationAnnotationChangedDelegate.h"

@interface ObservationEditViewDataStore : NSObject <UITableViewDelegate, UITableViewDataSource, ObservationEditListener>

@property (strong, nonatomic) Observation *observation;

@property (weak, nonatomic) IBOutlet UITableView *editTable;
@property (nonatomic, weak) IBOutlet NSObject<AttachmentSelectionDelegate> *attachmentSelectionDelegate;
@property (nonatomic, strong) NSObject<ObservationAnnotationChangedDelegate> *annotationChangedDelegate;

- (BOOL) validate;

@end
