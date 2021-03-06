//
//  MyUIViewController.m
//  PFC
//
//  Created by Felipe Rasinhas on 5/2/13.
//  Copyright (c) 2013 Felipe Rasinhas. All rights reserved.
//

#include "MyUIViewController.h"

@interface MyUIViewController ()

@end

@implementation MyUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //Declarando mensagens de erro
    self.neighbourhoodErrorMessage = @"Please enter the desired search Neighbourhood.";
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) isValid:(UITextField *)textField
{
    if([textField.text isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
    
}

- (void) showError:(NSString *)errorMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [alert show];
}

- (void)changeColor:(UIButton *)button
{
    button.selected = 1-button.selected;
    if (button.selected) {
        [self setNegativeButtonColor:button];
    } else {
        [self setDefaultButtonColor:button];
    }
}

- (void) setDefaultButtonColor:(UIButton *)button
{
    button.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [button setTitleColor:[UIColor colorWithRed:(50.0/255) green:(79.0/255) blue:(133.0/255) alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:(50.0/255) green:(79.0/255) blue:(133.0/255) alpha:1.0] forState:UIControlStateHighlighted];
}

- (void) setNegativeButtonColor:(UIButton *)button
{
    button.layer.backgroundColor = [UIColor colorWithRed:(50.0/255) green:(79.0/255) blue:(133.0/255) alpha:1.0].CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)updateColors:(id)sender {
    UIColor *newColor = [UIColor colorWithRed:(50.0/255) green:(79.0/255) blue:(133.0/255) alpha:1.0];
    UIColor *oldColor = [UIColor colorWithRed:(100.0/255) green:(129.0/255) blue:(183.0/255) alpha:1.0];
    for (int i=0; i<[sender numberOfSegments]; i++) {
        if ([[[sender subviews] objectAtIndex:i] isSelected]) {
            [[[sender subviews] objectAtIndex:i] setTintColor:newColor];
        } else {
            [[[sender subviews] objectAtIndex:i] setTintColor:oldColor];
        }
    }
}

- (void)prettify:(UIButton *)button
{
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 10.0f;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self setDefaultButtonColor:button];
}

- (void) notImplementedError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Feature not implemented yet." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [alert show];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void) makeRequest:(NSDictionary *)args
{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    NSString *server = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"Server IP"];
    NSString *full_url = [NSString stringWithFormat:@"http://%@:8000/webservice/query/?db=%@&dataset=%@&query_dict=%@&extras=%@&uid=%d", server, [args valueForKey:@"db"], [args valueForKey:@"dataset"], [[args valueForKey:@"query_dict"] JSONRepresentation], [[args valueForKey:@"extras"] JSONRepresentation], [data integerForKey:@"uid"]];
    
    NSURL *url = [NSURL URLWithString:[full_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
}

-(void) requestFailed:(ASIHTTPRequest *)request
{
    [self showError:@"Network connection problem."];
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    ShowResultViewController *resultsView = [[ShowResultViewController alloc] initWithNibName:@"ShowResultViewController" bundle:nil];
    resultsView.results = [[request responseString] JSONValue];
    [self presentViewController:resultsView animated:YES completion:nil];
}

@end
