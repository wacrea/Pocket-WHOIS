//
//  PWMainViewController.m
//  Pocketwhois
//
//  Created by William AGAY on 27/02/13.
//  CC BY-SA 2013 William AGAY. All rights reserved.
//

#import "PWMainViewController.h"
#import "SBJson.h"

@interface PWMainViewController ()

@end

@implementation PWMainViewController

@synthesize json, searchField, searchButton, SearchStatus, status, codeDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Cantarell" size:23.0f];
        label.textAlignment = NSTextAlignmentCenter;
        // ^-Use UITextAlignmentCenter for older SDKs.
        label.textColor = [UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:1.0]; // Hexa : 404040
        self.navigationItem.titleView = label;
        label.text = @"Pocket WHOIS";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navbar custom
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.827 green:0 blue:0.106 alpha:1];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [searchButton setTitle:NSLocalizedString(@"search", nil) forState:UIControlStateNormal];
    
    adView.delegate=self;    
    SearchStatus.hidesWhenStopped = TRUE;
    searchField.delegate = self;
    self.view.userInteractionEnabled = YES;
    status.hidden = YES;
    codeDetails.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.searchField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self Search];
    
    return YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    adView.hidden = YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    adView.hidden = NO;
}

- (IBAction)Search {
    
    // NETWORK : GET DATA FROM API
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [SearchStatus startAnimating];
    [searchField resignFirstResponder];
    
    NSString *postString = [@"domain=" stringByAppendingString:searchField.text];
     
    // Get data from server
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://pocketwhois.williamagay.com/api.php"]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
     
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    json = nil;
    json = [parser objectWithString:jsonString error:nil];
    
    [SearchStatus stopAnimating];
    
    int statusWHOIS = [[json valueForKey:@"status"] intValue];
    
    if(statusWHOIS == 1)
    {
        status.image = [UIImage imageNamed:@"ok"];
        status.hidden = NO;
    }
    else{
        status.image = [UIImage imageNamed:@"no"];
        status.hidden = NO;
    }
    
    codeDetails.hidden = FALSE;
    int codeDetailsNumber = [[json valueForKey:@"code"] intValue];
    
    if(codeDetailsNumber == 1){
        codeDetails.text = NSLocalizedString(@"falsedomain", nil);
    }
    else if (json == nil){
        codeDetails.text = NSLocalizedString(@"invalidrequest", nil);
    }
    else if (codeDetailsNumber == 3){
        codeDetails.text = NSLocalizedString(@"available", nil);
    }
    else if (codeDetailsNumber == 4){
        codeDetails.text = NSLocalizedString(@"taken", nil);
    }
    
    //NSLog(@"%@", json);
}

@end
