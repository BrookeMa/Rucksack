//
//  CandidCameraViewController.m
//  Rucksack
//
//  Created by MaYe on 14-2-22.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "CandidCameraViewController.h"
#import "CandidCollectionViewCell.h"
#import "CandidCollectionReusableView.h"
#import "CandidShowPhotoViewController.h"
#import "DejalActivityView.h"
#import "Utility.h"

#define CAMERA_OVERLAY_VIEW IS_IPHONE ? @"CameraOverlayView" : @"CameraOverlayView_iPad"

@interface CandidCameraViewController ()
@property (strong, nonatomic) NSMutableArray *imageSaveArray;
@property (assign, nonatomic) BOOL isDeviceFront;
@property (weak, nonatomic) IBOutlet UILabel *showDismissWayLabel;

@end

@implementation CandidCameraViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)createCamera:(id)sender
{
    imagePicker = [[UIImagePickerController alloc] init];

    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    if (_isDeviceFront) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    
    imagePicker.allowsEditing = YES;
    imagePicker.showsCameraControls = NO;
    
    imagePicker.cameraViewTransform = CGAffineTransformIdentity;
    imagePicker.delegate = self;
    
    [[NSBundle mainBundle] loadNibNamed:CAMERA_OVERLAY_VIEW owner:self options:nil];
    [cameraOverlayView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    imagePicker.cameraOverlayView = cameraOverlayView;

    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)cancelCapture:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)capture:(id)sender
{
    [UIView animateWithDuration:0.5f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.captureButton.hidden = YES;
                         self.showDismissWayLabel.hidden = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
            self.showDismissWayLabel.alpha = 0.0;
        } completion:NULL];
        }];
    // repeats capture deley
    [NSTimer scheduledTimerWithTimeInterval:1.2f
                                     target:imagePicker
                                   selector:@selector(takePicture)
                                   userInfo:nil
                                    repeats:YES];
}

// location to chinese
#define ALTER_LOCATION_SAVE_FAIL NSLocalizedStringFromTable(@"ALTER_LOCATION_SAVE_FAIL", @"CandidCameraViewController", @"Save fail")
#define ALTER_LOCATION_SAVE_FAIL_MESSAGE NSLocalizedStringFromTable(@"ALTER_LOCATION_SAVE_FAIL_MESSAGE", @"CandidCameraViewController", @"Please choose photo what you want")
#define ALTER_LOCATION_OK NSLocalizedStringFromTable(@"ALTER_LOCALION_OK", @"CandidCameraViewController", @"OK")
- (IBAction)SavePhoto:(id)sender
{
    if (!_imageSaveArray) {
        _imageSaveArray = [[NSMutableArray alloc] init];

    }
 
    // The imageArray is similar to cell.photoView.image
    for (int index = 0; index < [imagesArray count]; index++) {
        NSIndexPath *itemPath = [NSIndexPath indexPathForItem:index inSection:0];
        CandidCollectionViewCell *cell = (CandidCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:itemPath];
        
        // Determine the photos whether by selected
        if (cell.photoSelectButton.selected == YES) {
            [_imageSaveArray addObject:[imagesArray objectAtIndex:itemPath.row]];
        }
    }
    
    if ([_imageSaveArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALTER_LOCATION_SAVE_FAIL //@"Save fail"
                                                        message:ALTER_LOCATION_SAVE_FAIL_MESSAGE //@"Please choose photo what you want"
                                                       delegate:nil
                                              cancelButtonTitle:ALTER_LOCATION_OK //@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    } else {
        
        // show activity
        [self activityShow];
        
        // Save mutiple images
        UIImageWriteToSavedPhotosAlbum([_imageSaveArray objectAtIndex:0], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (IBAction)changeDevice:(id)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.isDeviceFront = NO;
            break;
        case 1:
            self.isDeviceFront = YES;
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (!imagesArray) {
        imagesArray = [[NSMutableArray alloc] init];
    }
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [imagesArray addObject:image];
    [self addNewCellWithImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UINavigationControllerDelegate
#pragma mark UINavigationControllerDelegate hidden status bar

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


#pragma mark -
#pragma mark UICollectionViewDataSource 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imagesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CandidCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"candid cell" forIndexPath:indexPath];
    if (!cell.photoImageView.image) {
        UIImage *image = [imagesArray objectAtIndex:indexPath.row];
        [cell.photoImageView setImage:image];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)aCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        CandidCollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"candid header" forIndexPath:indexPath];
        header.title.text = @"rear";
        return header;
    }
    return nil;
}


#pragma mark - 
#pragma add method

- (void)addNewCellWithImage:(UIImage *)image
{
    NSIndexPath *itemPath = [NSIndexPath indexPathForItem:[imagesArray count] - 1 inSection:0];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[itemPath]];
    } completion:NULL];
}

// Compress the image for we need

- (UIImage *)imageWithImageCompression:(UIImage *)image scaleToSize:(CGSize)targetSize
{
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(targetSize);
    
    // Tell the old image to draw in the new context, with the target size
    
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    // Get the new image from the context
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}

#define ACTIVITY_LOCATION_SAVING NSLocalizedStringFromTable(@"ACTIVITY_LOCATION_SAVING", @"CandidCameraViewController", @"Saving")
- (void)activityShow
{
    UIView *viewToUse = self.view;
    [DejalBezelActivityView activityViewForView:viewToUse withLabel:ACTIVITY_LOCATION_SAVING width:80.0f];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
}


#pragma mark -
#pragma mark save image callback recursive

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error)
    {
        NSLog(@"error: %@", [error description]);
    }
    else  // No errors
    {
        
        [self.imageSaveArray removeObjectAtIndex:0];
    }
    [self saveNext];
}

#define ACTIVITY_LOCATION_SAVE_SUCCESSFUL NSLocalizedStringFromTable(@"ACTIVITY_LOCATION_SAVE_SUCCESSFUL", @"CandidCameraViewController", @"Save sucessful")
#define ACTIVITY_LOCATION_SAVE_SUCCESSFUL_MESSAGE NSLocalizedStringFromTable(@"ACTIVITY_LOCATION_SAVE_SUCCESSFUL_MESSAGE", @"CandidCameraViewController", @"Image has been saved to the album")

-(void) saveNext
{
	if (self.imageSaveArray.count > 0) {
        
		UIImage *image = [_imageSaveArray objectAtIndex:0];
		UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
	} else {
        [DejalBezelActivityView removeViewAnimated:YES];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ACTIVITY_LOCATION_SAVE_SUCCESSFUL //@"Save Sucessful"
                                                        message:ACTIVITY_LOCATION_SAVE_SUCCESSFUL_MESSAGE //@"Image has been saved to the album"
                                                       delegate:nil
                                              cancelButtonTitle:ALTER_LOCATION_OK //@"OK"
                                              otherButtonTitles:nil];
        [alert show];
	}
}


#pragma mark -
#pragma mark storyboard segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"candidShowPhoto"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        CandidShowPhotoViewController *destinationViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];

        
        // set show photoImageView image which selected
        destinationViewController.showPhotoImage = [imagesArray objectAtIndex:indexPath.row];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}


@end

