//
//  EditProfileViewController.m
//  PFC
//
//  Created by Felipe Rasinhas on 4/1/13.
//  Copyright (c) 2013 Felipe Rasinhas. All rights reserved.
//

#include "EditProfileViewController.h"


@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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
    [self.oldPassField setDelegate:self];
    [self.passwordField setDelegate:self];
    [self.confirmField setDelegate:self];
    [self.emailField setDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProfile:(id)sender
{
    if([_passwordField.text isEqualToString: @""] == YES )
    {
        [self showError:@"Password are required."];
    }
    else if([_passwordField.text isEqualToString: _confirmField.text] == NO)
    {
        [self showError:@"The password confirmation and password are different. Please correct it."];
    }
    else
    {
        NSString *server = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"Server IP"];
        NSString *full_url = [NSString stringWithFormat:@"http://%@:8000/webservice/edit_profile/", server];
        
        NSURL *url = [NSURL URLWithString:[full_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [request setPostValue:[data stringForKey:@"username"] forKey:@"username"];
        [request setPostValue:self.oldPassField.text forKey:@"old_password"];
        [request setPostValue:self.passwordField.text forKey:@"new_password"];
        [request setPostValue:self.emailField.text forKey:@"email"];
        [request startAsynchronous];
    }
}

-(void) requestFailed:(ASIHTTPRequest *)request
{
    [self showError:@"Network connection problem."];
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    if([[[[request responseString] JSONValue] valueForKey:@"success"] boolValue] == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Registered" message:@"The user was successfully updated" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showError:@"The old password does not match."];
    }
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
