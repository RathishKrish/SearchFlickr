//
//  ViewController.m
//  SearchFlickr
//
//  Created by Rathish Krish T on 15/07/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"

#import "AppDelegate.h"
#import "FlickrFlowLayout.h"
#import "FlickrCell.h"
#import "FlickrService.h"
#import "FlickrImage.h"
#import "FavoriteFlick.h"

#define CELL_IDENTIFIER @"Cell"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, flickrLayoutDelegate, UITextFieldDelegate, favoriteDelegate>

@property(nonatomic, strong) UICollectionView *flickerCollectionView;

@property (nonatomic, strong) FlickrFlowLayout *layout;

@property(nonatomic, weak) IBOutlet UIView *titleView;

@property(nonatomic, weak) IBOutlet UITextField *searchField;

@property(nonatomic, weak) IBOutlet UIButton *cancelButton;

@property(strong,nonatomic) NSURLSession *session;

@property (nonatomic, strong) FlickrService *fService;

@property (nonatomic, strong) NSMutableArray *flickrStack;

@property (nonatomic, strong) NSMutableArray *favFlickStack;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HomeViewController

- (UICollectionView *)collectionView {
    if (!self.flickerCollectionView) {
        FlickrFlowLayout *layout = [[FlickrFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(70, 15, 15, 15);
        layout.minimumColumnSpacing = 15;
        layout._minimumInteritemSpacing = 15;
        
        self.flickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:layout];
        self.flickerCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.flickerCollectionView.dataSource = self;
        self.flickerCollectionView.delegate = self;
        self.flickerCollectionView.backgroundColor = [UIColor clearColor];
        [self.flickerCollectionView registerClass:[FlickrCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return self.flickerCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.collectionView];
    
    [self.view bringSubviewToFront:self.titleView];
    
    [self.view bringSubviewToFront:self.activityIndicator];
    
    self.fService = [[FlickrService alloc]init];
    
    self.favFlickStack = [self getAllFavz];
    
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    [conf setHTTPMaximumConnectionsPerHost:4];
    self.session = [NSURLSession sessionWithConfiguration:conf delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [self.activityIndicator setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchField becomeFirstResponder];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}


#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    [self.fService searchFlickrForKeyWord:textField.text blockComplition:^(NSString *searchKeyWord, NSArray *results, NSError *error) {
        if (error!=nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self.flickrStack removeAllObjects];
            self.flickrStack = [results mutableCopy];
            [self.flickerCollectionView reloadData];
        }
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }];
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancel:(id)sender{
    [self.searchField resignFirstResponder];
    [self.searchField setText:@""];
    [self cancelTasks];
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    [self.flickrStack removeAllObjects];
    [self.collectionView reloadData];
}

- (void)cancelTasks {
    [self.fService cancelTasks];
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}


#pragma mark - UICollectionView Datasource

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    self.layout.columnCount = 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.flickrStack count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FlickrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell setDelegate:self];
    
    FlickrImage *photo = (FlickrImage *)self.flickrStack[indexPath.row];
    cell.imageView.image = photo.flickImage;
    [cell.titleLabel setText:photo.title];
    [cell.tagLabel setText:[NSString stringWithFormat:@"#%@",photo.tag]];
    
    if([self.favFlickStack containsObject:photo.photoID]){
        [cell.favoriteBtn setSelected:YES];
    }else{
        [cell.favoriteBtn setSelected:NO];
    }
    
    if (photo.flickImage == nil) {
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:photo.imageURL]];
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if (error == nil) {
                UIImage *image = [UIImage imageWithData:data];
                photo.flickImage = image;
                if ([self.flickrStack count]>0) {
                    [collectionView performBatchUpdates:^{
                        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
                    } completion:^(BOOL finished) {
                    }];
                }
                
            }
        }];
        
        [dataTask resume];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrImage *photo = self.flickrStack[indexPath.row];
    return CGSizeMake(photo.flickImage.size.width, photo.flickImage.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"Detail";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DetailViewController * controller = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [controller setImageDetails:self.flickrStack[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - FavoriteDelegate methods
- (void) favoriteFlick:(UIButton *)sender{
    
    FlickrCell *cell = (FlickrCell *) sender.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FlickrImage *photo = self.flickrStack[indexPath.row];
    
    if ([sender isSelected]) {
        [sender setSelected:NO];
        [self removeFavorite:photo.photoID];
    }else{
        [sender setSelected:YES];
        
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        theAnimation.duration=0.2;
        theAnimation.repeatCount=1;
        theAnimation.autoreverses=NSNotFound;
        theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
        theAnimation.toValue=[NSNumber numberWithFloat:1.5];
        theAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [sender.layer addAnimation:theAnimation forKey:@"animateOpacity"];
        
        [self addFavorite:photo.photoID];
    }
}

- (void)addFavorite:(NSString *)favId {
    
    NSManagedObjectContext *context = [AppDelegate instance].managedObjectContext;
    FavoriteFlick *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteFlick" inManagedObjectContext:context];
    [favorite setObject_id:favId];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    self.favFlickStack = [self getAllFavz];
}

- (void) removeFavorite:(NSString *)favId{
    
    NSManagedObjectContext *context = [AppDelegate instance].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"object_id = %@", favId];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"FavoriteFlick" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSMutableArray *fetchedObjects = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    for(FavoriteFlick *favorite in fetchedObjects) {
        [context deleteObject:favorite];
    }
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    self.favFlickStack = [self getAllFavz];
}

-(NSMutableArray*) getAllFavz{
    
    NSManagedObjectContext *managedObjectContext = [AppDelegate instance].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteFlick"];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *favId = [NSMutableArray array];
    
    for (FavoriteFlick *favorite in fetchedObjects) {
        [favId addObject:favorite.object_id];
    }
    
    return favId;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
