//
//  PWMainViewController.h
//  Pocketwhois
//
//  Created by William AGAY on 27/02/13.
//  CC BY-SA 2013 William AGAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface PWMainViewController : UIViewController<UITextFieldDelegate, ADBannerViewDelegate>{
    NSMutableArray *json;
    IBOutlet UITextField *searchField;
    IBOutlet UIButton *searchButton;
    IBOutlet UIActivityIndicatorView *SearchStatus;
    IBOutlet UIImageView *status;
    IBOutlet UILabel *codeDetails;
    IBOutlet ADBannerView *adView;
}

@property (nonatomic, retain) NSMutableArray *json;
- (IBAction)Search;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *SearchStatus;
@property (nonatomic, retain) IBOutlet UIImageView *status;
@property (nonatomic, retain) IBOutlet UILabel *codeDetails;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

@end
