//
//  DetailViewController.m
//  SearchFlickr
//
//  Created by Rathish Krish T on 25/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import "DetailViewController.h"

#import "FlickrService.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, strong) FlickrService *fService;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation DetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.fService = [[FlickrService alloc]init];
    
    [self.imageView setImage:self.imageDetails.flickImage];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.activityIndicator.center = self.view.center;
    [self.view addSubview: self.activityIndicator];
    
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    [self.fService searchFlickrImage:self.imageDetails blockComplition:^(NSDictionary *results, NSError *error) {
        [self.textView setText:[[results valueForKey:@"description"] valueForKey:@"_content"]];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }];
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
