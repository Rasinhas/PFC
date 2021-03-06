//
//  MainViewController.m
//  PFC
//
//  Created by Felipe Rasinhas on 4/1/13.
//  Copyright (c) 2013 Felipe Rasinhas. All rights reserved.
//

#include "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

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
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    self.greetingLabel.text = [NSString stringWithFormat:@"Welcome, %@", [data stringForKey:@"username"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editProfile:(id)sender {
    UIViewController *editForm = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self presentViewController:editForm animated:YES completion:nil];
    
}

- (IBAction)managePreferences:(id)sender {
    UIViewController *preferencesView = [[ManagePreferencesViewController alloc] initWithNibName:@"ManagePreferencesViewController" bundle:nil];
    [self presentViewController:preferencesView animated:YES completion:nil];
}


- (IBAction)search:(id)sender {
    UIViewController *searchType = [[SearchTypeViewController alloc] initWithNibName:@"SearchTypeViewController" bundle:nil];
    [self presentViewController:searchType animated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    [data removeObjectForKey:@"username"];
    [data removeObjectForKey:@"uid"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
