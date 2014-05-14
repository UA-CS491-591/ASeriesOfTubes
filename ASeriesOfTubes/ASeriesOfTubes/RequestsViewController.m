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
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property NSOperationQueue *operationQueue;
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
    
    //Set up operation queue to handle background tasks.
    //This will be used in asyncronous method calls
    _operationQueue = [[NSOperationQueue alloc] init];
    
    //[self login];
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
    //Send synchronous request
    //[self sendSynchronousRequest];
    
    //Send asynchronous request
    [self sendAsynchronousRequest];
}

-(void)sendSynchronousRequest{
    //1. Create request object
    //Create url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", _urlTextField.text]];
    
    //Create request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    
    //Add header
    //[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //Specify verb
    [request setHTTPMethod:@"GET"];
    
    //Create response variables that will be used by the synchronous request
    NSURLResponse *response;
    NSError *error;
    
    //Send synchronous request
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Handle response
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    _responseTextView.text = responseString;
}

-(void)sendAsynchronousRequest{
    //Create url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", _urlTextField.text]];
    
    //Create request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    
    //Make request
    [NSURLConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //3. Handle response
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        //Hop back to main thread to update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            _responseTextView.text = responseString;
        });
        
    }];
}

-(void)login{
    //Create url
    NSURL *url = [NSURL URLWithString:@"https://mobileweb.caps.ua.edu/cs491/api/Account/login"];
    
    //Create request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    //Let the server know that we want to interact in JSON
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //Set http method
    [request setHTTPMethod:@"POST"];
    
    //Specify the string to get sent to the server
    NSString *loginString = @"{\"username\": \"zbarnes\",\"password\": \"password\"}";
    //Make that string into raw data
    NSData *loginData = [loginString dataUsingEncoding:NSUTF8StringEncoding];
    //Set that raw data as the HTTP Body for the request
    [request setHTTPBody:loginData];
    
    //Send asynchronous request
    [NSURLConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //Decode to string
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //Log out response
        NSLog(@"%@", responseString);
    }];
}
@end
