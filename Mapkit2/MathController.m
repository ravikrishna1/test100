//
//  MathController.m
//  Mapkit2
//
//  Created by Logictree on 22/06/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import "MathController.h"
#import "Location.h"
#import "MulticolorPolylineSegment.h"


static bool const isMetric = YES;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation MathController

+ (NSString *)stringifyDistance:(float)meters
{
    float unitDivider;
    
    NSString *unitName;
    
    // metric
    if (isMetric) {
        
        unitName = @"km";
        // to get from meters to kilometers divide by this
        unitDivider = metersInKM;
        // U.S.
    } else {
        unitName = @"mi";
        // to get from meters to miles divide by this
        unitDivider = metersInMile;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (meters / unitDivider), unitName];
}

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat
{
    int remainingSeconds = seconds;
    
    NSLog(@"%d",remainingSeconds);
    
    int hours = remainingSeconds / 3600;
    
    NSLog(@"%d",hours);
    
    remainingSeconds = remainingSeconds - hours * 3600;
    
    NSLog(@"%d",remainingSeconds);

    int minutes = remainingSeconds / 60;
    
    NSLog(@"%d",minutes);
    
    remainingSeconds = remainingSeconds - minutes * 60;
    
    NSLog(@"%d",remainingSeconds);
    
    if (longFormat) {
        
        if (hours > 0) {
            
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
            
        } else {
            
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        
        if (hours > 0) {
            
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
            
        } else {
            
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds
{
    if (seconds == 0 || meters == 0) {
        
        return @"0";
        
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    NSLog(@"%f",avgPaceSecMeters);
    
    float unitMultiplier;
    
    NSString *unitName;
    
    // metric
    if (isMetric) {
        
        unitName = @"min/km";
        
        unitMultiplier = metersInKM;
        // U.S.
    } else {
        
        unitName = @"min/mi";
        
        unitMultiplier = metersInMile;
    }
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
    
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations
{
    NSMutableArray *speeds = [NSMutableArray array];
    
    double slowestSpeed = DBL_MAX;
    
    double fastestSpeed = 0.0;
    
    for (int i = 1; i < locations.count; i++) {
        
   NSLog(@"%lu",(unsigned long)locations.count);
        
    Location *firstLoc = [locations objectAtIndex:(i-1)];
        
    NSLog(@"%@",[locations objectAtIndex:(i-1)]);
    
    Location *secondLoc = [locations objectAtIndex:i];
        
    NSLog(@"%@",[locations objectAtIndex:i]);
        
    CLLocation *firstLocCL = [[CLLocation alloc] initWithLatitude:firstLoc.latitude.doubleValue longitude:firstLoc.longitude.doubleValue];
        
    CLLocation *secondLocCL = [[CLLocation alloc] initWithLatitude:secondLoc.latitude.doubleValue longitude:secondLoc.longitude.doubleValue];
        
        double distance = [secondLocCL distanceFromLocation:firstLocCL];
        
        double time = [secondLoc.timestamp timeIntervalSinceDate:firstLoc.timestamp];
        
        double speed = distance/time;
        
        NSLog(@"%f",speed);
        
        slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed;
        
        fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed;
        
        [speeds addObject:@(speed)];
        
    }
    
    // now knowing the slowest+fastest, we can get mean too
    
    double meanSpeed = (slowestSpeed + fastestSpeed)/2;
    
    // RGB for red (slowest)
    CGFloat r_red = 1.0f;
    CGFloat r_green = 20/255.0f;
    CGFloat r_blue = 44/255.0f;
    
    // RGB for yellow (middle)
    CGFloat y_red = 1.0f;
    CGFloat y_green = 215/255.0f;
    CGFloat y_blue = 0.0f;
    
    // RGB for green (fastest)
    CGFloat g_red = 0.0f;
    CGFloat g_green = 146/255.0f;
    CGFloat g_blue = 78/255.0f;
    
    NSMutableArray *colorSegments = [NSMutableArray array];
    
    for (int i = 1; i < locations.count; i++) {
        
        Location *firstLoc = [locations objectAtIndex:(i-1)];
        
        NSLog(@"%@",firstLoc);
        
        Location *secondLoc = [locations objectAtIndex:i];
        
        NSLog(@"%@",secondLoc);

        
        CLLocationCoordinate2D coords[2];
        
        coords[0].latitude = firstLoc.latitude.doubleValue;
        
        coords[0].longitude = firstLoc.longitude.doubleValue;
        
        coords[1].latitude = secondLoc.latitude.doubleValue;
        
        coords[1].longitude = secondLoc.longitude.doubleValue;
        
        NSNumber *speed = [speeds objectAtIndex:(i-1)];
        
        NSLog(@"%@",speed);
        
        UIColor *color = [UIColor clearColor];
        
        // between red and yellow
        
        if (speed.doubleValue < meanSpeed) {
            
            double ratio = (speed.doubleValue - slowestSpeed) / (meanSpeed - slowestSpeed);
            
            NSLog(@"%f",ratio);
            
            CGFloat red = r_red + ratio * (y_red - r_red);
            
            NSLog(@"%f",red);
            
            CGFloat green = r_green + ratio * (y_green - r_green);
            
            NSLog(@"%f",green);
            
            CGFloat blue = r_blue + ratio * (y_blue - r_blue);
            
            NSLog(@"%f",blue);
            
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            
            // between yellow and green
            
        } else {
            
            double ratio = (speed.doubleValue - meanSpeed) / (fastestSpeed - meanSpeed);
            
            NSLog(@"%f",ratio);

            CGFloat red = y_red + ratio * (g_red - y_red);
            
            NSLog(@"%f",red);

            CGFloat green = y_green + ratio * (g_green - y_green);
            
            NSLog(@"%f",green);

            CGFloat blue = y_blue + ratio * (g_blue - y_blue);
            
            NSLog(@"%f",blue);

            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            
        }
        
        MulticolorPolylineSegment *segment = [MulticolorPolylineSegment polylineWithCoordinates:coords count:2];
        
        segment.color = color;
        
        [colorSegments addObject:segment];
        
    }
    
    return colorSegments;
}


@end
