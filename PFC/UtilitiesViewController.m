//
//  UtilitiesViewController.m
//  PFC
//
//  Created by Felipe Rasinhas on 4/30/13.
//  Copyright (c) 2013 Felipe Rasinhas. All rights reserved.
//

#import "UtilitiesViewController.h"

@interface UtilitiesViewController ()

@end

@implementation UtilitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.neighTextField setDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)policeFilter:(id)sender {
    if([self isValid:self.neighTextField]) {
        [self showResults:nil];
    } else {
        [self showError:self.NeighbourhoodErrorMessage];
    }
}

- (IBAction)firemanFilter:(id)sender {
    if([self isValid:self.neighTextField]) {
        [self showResults:nil];
    } else {
        [self showError:self.NeighbourhoodErrorMessage];
    }
}

- (IBAction)hospitalFilter:(id)sender {
    if([self isValid:self.neighTextField]) {
        [self showResults:nil];   
    } else {
        [self showError:self.NeighbourhoodErrorMessage];
    }
}


@end
