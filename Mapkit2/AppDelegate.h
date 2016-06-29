//
//  AppDelegate.h
//  Mapkit2
//
//  Created by Logictree on 22/06/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LocationTracker.h"
#import "Run.h"
#import "Run+CoreDataProperties.h"
#import "Location.h"
#import "Location+CoreDataProperties.h"
#import "MathController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@property(nonatomic) UIBackgroundTaskIdentifier bgTask;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

