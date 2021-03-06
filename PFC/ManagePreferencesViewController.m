//
//  ManagePreferencesViewController.m
//  PFC
//
//  Created by Jonathan Carvalhosa on 6/10/13.
//  Copyright (c) 2013 Felipe Rasinhas. All rights reserved.
//

#include "ManagePreferencesViewController.h"

@interface ManagePreferencesViewController ()

@end

@implementation ManagePreferencesViewController

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
    self.utilityNeighTextField.delegate = self;
    self.restaurantNeighTextField.delegate = self;
    self.restaurantTypeTextField.delegate = self;
    self.innNeighTextField.delegate = self;
    self.entertainmentNeighTextField.delegate = self;
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    
    self.preferences = [[NSUserDefaults standardUserDefaults] valueForKey:@"preferences"];
    self.utilityNeighTextField.text = [[self.preferences objectForKey:@"utility"] valueForKey:@"neighbourhood"];
    self.restaurantNeighTextField.text = [[self.preferences objectForKey:@"restaurant"] valueForKey:@"neighbourhood"];
    self.restaurantPriceControlField.selectedSegmentIndex = [[[self.preferences objectForKey:@"restaurant"] valueForKey:@"price"] length]-1;
    self.restaurantTypeTextField.text = [[self.preferences objectForKey:@"restaurant"] valueForKey:@"type"];
    self.innNeighTextField.text = [[self.preferences objectForKey:@"inn"] valueForKey:@"neighbourhood"];
    self.innPriceControlField.selectedSegmentIndex = [[[self.preferences objectForKey:@"inn"] valueForKey:@"price"] length]-1;
    self.entertainmentNeighTextField.text = [[self.preferences objectForKey:@"entertainment"] valueForKey:@"neighbourhood"];
    self.entertainmentPriceControlField.selectedSegmentIndex = [[[self.preferences objectForKey:@"entertainment"] valueForKey:@"price"] length]-1;

    
    self.restaurant_types = @[@"", @"fastfood", @"restaurants", @"bars"];
    self.restaurantTypeTextField.inputView = self.typePicker;
    [ self.typePicker selectRow:[self.restaurant_types indexOfObject:self.restaurantTypeTextField.text] inComponent:0 animated:NO];
    [ self.typePicker setHidden:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateColors:self.restaurantPriceControlField];
    [self updateColors:self.innPriceControlField];
    [self updateColors:self.entertainmentPriceControlField];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePreferences:(id)sender {
    self.preferences = @{
        @"utility": @{
            @"neighbourhood": self.utilityNeighTextField.text,
        },
        @"restaurant": @{
            @"neighbourhood": self.restaurantNeighTextField.text,
            @"price": [self.restaurantPriceControlField titleForSegmentAtIndex:[self.restaurantPriceControlField selectedSegmentIndex]],
            @"type": self.restaurantTypeTextField.text,
        },
        @"inn": @{
            @"neighbourhood": self.innNeighTextField.text,
            @"price": [self.innPriceControlField titleForSegmentAtIndex:[self.innPriceControlField selectedSegmentIndex]],
        },
        @"entertainment": @{
            @"neighbourhood": self.entertainmentNeighTextField.text,
            @"price": [self.entertainmentPriceControlField titleForSegmentAtIndex:[self.entertainmentPriceControlField selectedSegmentIndex]],
        },
    };
    
    NSString *server = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"Server IP"];
    NSString *full_url = [NSString stringWithFormat:@"http://%@:8000/webservice/save_preferences/", server];
    
    NSURL *url = [NSURL URLWithString:[full_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    [request setPostValue:[self.preferences JSONRepresentation] forKey:@"preferences"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"] forKey:@"uid"];
    [request startAsynchronous];
}


# pragma mark - ASIHttpRequest Delegate


-(void) requestFailed:(ASIHTTPRequest *)request
{
    [self showError:@"Network connection problem."];
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    if([[[[request responseString] JSONValue] valueForKey:@"success"] boolValue] == YES) {
        [[NSUserDefaults standardUserDefaults] setValue:self.preferences forKey:@"preferences"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Preference Update" message:@"Your preferences were successfully updated" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showError:@"Internal Server Error."];
    }
    
}


- (IBAction)enableRestaurantTypes:(id)sender {
    [self.typePicker setHidden:NO];
    //FIXME: o cursor do mouse teria que desaparecer, ja que o keyboard nao esta sendo usado
}


# pragma mark - PickerView DataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.restaurant_types count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (row == 0) {
        return @"-------------";
    }
    return [self.restaurant_types objectAtIndex:row];
}

# pragma mark - PickerView Delegate

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.restaurantTypeTextField.text = [self.restaurant_types objectAtIndex:row];
    [self.restaurantTypeTextField endEditing:YES];
    [self.typePicker setHidden:YES];
}

@end
