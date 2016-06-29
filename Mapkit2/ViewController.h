//
//  ViewController.h
//  Mapkit2
//
//  Created by Logictree on 22/06/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) IBOutlet UILabel *lastDistanceLbl;


@property (strong, nonatomic) IBOutlet UILabel *timeLbl;


@property (strong, nonatomic) IBOutlet UILabel *paceLbl;



@end

