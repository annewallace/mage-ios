//
//  FormPickerViewController.m
//  MAGE
//
//  Created by Dan Barela on 8/10/17.
//  Copyright © 2017 National Geospatial Intelligence Agency. All rights reserved.
//

#import "FormPickerViewController.h"
#import "FormCollectionViewCell.h"
#import <MapKit/MapKit.h>
#import <GeometryUtility.h>
#import <KTCenterFlowLayout.h>

@interface FormPickerViewController ()

@property (strong, nonatomic) id<FormPickedDelegate> delegate;
@property (strong, nonatomic) NSArray *forms;
@property (strong, nonatomic) WKBGeometry *location;
@property (nonatomic) BOOL newObservation;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation FormPickerViewController

static NSString *CellIdentifier = @"FormCell";

- (instancetype) initWithDelegate: (id<FormPickedDelegate>) delegate andForms: (NSArray *) forms andLocation: (WKBGeometry *) location andNewObservation: (BOOL) newObservation {
    self = [super init];
    if (!self) return nil;
    
    _delegate = delegate;
    _forms = forms;
    _location = location;
    _newObservation = newObservation;
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMapBackground];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.newObservation) {
        _headerLabel.text = @"What type of observation would you like to create?";
    } else {
        _headerLabel.text = @"What tyep of form would you like to add to this observation?";
    }
    [self setupCollectionView];
}

- (void) setupCollectionView {
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FormCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 25.f;
    layout.itemSize = CGSizeMake(90.f, 120.f);
    
    [self.collectionView setCollectionViewLayout:layout];
}

- (void) setupMapBackground {
    if (self.location != nil) {
        WKBPoint *point = [GeometryUtility centroidOfGeometry:self.location];
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake([point.y doubleValue], [point.x doubleValue]), MKCoordinateSpanMake(.03125, .03125));
        MKCoordinateRegion viewRegion = [self.mapView regionThatFits:region];
        [self.mapView setRegion:viewRegion animated:NO];
    }
    
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.blurView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.blurView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurEffectView.alpha = .95;
        
        [self.blurView addSubview:blurEffectView];
    } else {
        self.blurView.backgroundColor = [UIColor whiteColor];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.forms count];
}

- (FormCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FormCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureCellForForm:[self.forms objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate formPicked: [self.forms objectAtIndex:[indexPath row]]];
}

@end
