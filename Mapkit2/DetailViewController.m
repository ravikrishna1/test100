//
//  DetailViewController.m
//  Mapkit2
//
//  Created by Logictree on 22/06/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import "DetailViewController.h"
#import "MathController.h"
#import "Run.h"
#import "Location.h"
#import "MulticolorPolylineSegment.h"

@interface DetailViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation DetailViewController

- (void)setRun:(Run *)run
{
    if (_run != run) {
        _run = run;
        [self configureView];
    }
}

- (void)configureView
{
        self.distanceLabel.text = [MathController stringifyDistance:self.run.distance.floatValue];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    
        self.dateLabel.text = [formatter stringFromDate:self.run.timestamp];
    
        self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.run.duration.intValue usingLongFormat:YES]];
    
        self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    
         [self loadMap];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    
    Location *initialLoc =  (Location *)self.run.locations.firstObject;
    
    NSLog(@"Initial Location:%@",initialLoc);
    
    float minLat = initialLoc.latitude.floatValue;
    
    float minLng = initialLoc.longitude.floatValue;
    
    float maxLat = initialLoc.latitude.floatValue;
    
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.run.locations) {
        
        if (location.latitude.floatValue < minLat) {
            
            minLat = location.latitude.floatValue;
            
            NSLog(@"Minimum Latitude:%f",minLat);
            
        }
        
        if (location.longitude.floatValue < minLng) {
            
            minLng = location.longitude.floatValue;
            
            NSLog(@"Minimum Longitude:%f",minLng);

        }
        if (location.latitude.floatValue > maxLat) {
            
            maxLat = location.latitude.floatValue;
            
            NSLog(@"Maximum Latitude:%f",maxLat);

        }
        if (location.longitude.floatValue > maxLng) {
            
            maxLng = location.longitude.floatValue;
            
            NSLog(@"Maximum Longitude:%f",maxLng);

        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
    
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
    
        return region;
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MulticolorPolylineSegment class]]) {
        
        MulticolorPolylineSegment *polyLine = (MulticolorPolylineSegment *)overlay;
        
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        
        aRenderer.strokeColor = polyLine.color;
        
        aRenderer.lineWidth = 3;
        
        return aRenderer;
    }
    
    return nil;
}

- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coords[self.run.locations.count];
    
    for (int i = 0; i < self.run.locations.count; i++) {
        
       Location *location = (Location *) [self.run.locations objectAtIndex:i];
        
        coords[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
        
        NSLog(@"Lat:%f Long:%f", location.latitude.doubleValue, location.longitude.doubleValue);
        
    
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:self.run.locations.count];
    
}

- (void)loadMap
{
    if (self.run.locations.count > 0) {
        
        NSLog(@"Locations Count:%lu",self.run.locations.count);
        
        self.mapView.hidden = NO;
        
        // set the map bounds
        
        [self.mapView setRegion:[self mapRegion]];
        
        NSArray *colorSegmentArray = [MathController colorSegmentsForLocations:self.run.locations.array];
        
        [self.mapView addOverlays:colorSegmentArray];
        
    } else {
        
        // no locations were found!
        self.mapView.hidden = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }
    
}

@end
