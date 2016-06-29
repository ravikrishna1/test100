//
//  ViewController.m
//  Mapkit2
//
//  Created by Logictree on 22/06/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import "ViewController.h"
#import "NewRunViewController.h"
#import "Run.h"
#import <CoreLocation/CoreLocation.h>
#import "MathController.h"
#import "Location.h"
#import "AppDelegate.h"

@interface ViewController ()

@property int seconds;

@property float distance;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *nextController = [segue destinationViewController];
    
    if ([nextController isKindOfClass:[NewRunViewController class]]) {
        
        ((NewRunViewController *) nextController).managedObjectContext = self.managedObjectContext;
        
    }
}

@end
