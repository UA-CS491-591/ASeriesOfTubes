//
//  RequestsViewController.m
//  ASeriesOfTubes
//
//  Created by Matthew York on 5/14/14.
//  Copyright (c) 2014 Center for Advanced Public Safety. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation RequestsViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didSelectGo:(id)sender {
    //Hide keyboard
    [self.view endEditing:YES];
    
    //Make request
    [self makeRequest];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //Hide keyboard
    [self.view endEditing:YES];
    
    //Make request
    [self makeRequest];
    
    return YES;
}

-(void)makeRequest{
    
}
@end
