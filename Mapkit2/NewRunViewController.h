//
//  NewRunViewController.h
//  Mapkit2
//
//  Created by Logictree on 22/06/16.
//  Copyright © 2016 Logictree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRunViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) IBOutlet UILabel *distLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


@property (strong, nonatomic) IBOutlet UILabel *paceLabel;

@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;



@end
