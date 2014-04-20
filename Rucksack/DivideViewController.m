//
//  DivideViewController.m
//  Rucksack
//
//  Created by MaYe on 14-1-28.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>

#import "UIImage+CWAdditions.h"
#import "DivideViewController.h"
#import "DejalActivityView.h"
#import "Utility.h"

#define SUBIMAGE_NINE_AND_SIX_WIDTH 74.0f
#define SUBIMAGE_NINE_AND_SIX_HEIGHT 74.0f
#define SUBIMAGE_FOUR_WIDTH 112.0f
#define SUBIMAGE_FOUR_HEIGHT 112.0f
#define SPACING_DIVIDE_FOUR 6.0f
#define SPACING 4.0f

#define ENTIRE_IMAGE_WIDTH  (IS_IPHONE ? 74.0f : 148.0f)
#define ENTIRE_IMAGE_HEIGHT (IS_IPHONE ? 74.0f : 148.0f)
#define ENTIRE_IMAGE_X (IS_IPHONE ? 45.0f : 158.0f)
#define ENTIRE_IMAGE_Y (IS_IPHONE ? 100.0f : 200.0f)

#define ORIGINAL_MAX_WIDTH 2440.0f

#define DIVIDE_IMAGE_EDITOR_VIEW IS_IPHONE ? @"DivideImageEditor" : @"DivideImageEditor_iPad"

typedef NS_ENUM(NSInteger, DivideCounts)
{
    DivideFourParts = 4,
    DivideSixParts = 6,
    DivideNineParts = 9
};

@interface DivideViewController ()
{
    NSArray *imageChoices;
}
@property(nonatomic,strong) DivideImageEditor *imageEditor;
@property(nonatomic,strong) ALAssetsLibrary *library;

@property (nonatomic, retain) UIActionSheet *imageSourceOption;
@property (nonatomic, strong) UIImageView *portraitImageView;

@property (nonatomic, assign) CGFloat portionImageWidth;
@property (nonatomic, assign) CGFloat portionImageHeight;
@property (nonatomic, assign) CGFloat imagePortionRatio;

@property (nonatomic, strong) UIImageView *imageViewPortion0;
@property (nonatomic, strong) UIImageView *imageViewPortion1;
@property (nonatomic, strong) UIImageView *imageViewPortion2;
@property (nonatomic, strong) UIImageView *imageViewPortion3;
@property (nonatomic, strong) UIImageView *imageViewPortion4;
@property (nonatomic, strong) UIImageView *imageViewPortion5;
@property (nonatomic, strong) UIImageView *imageViewPortion6;
@property (nonatomic, strong) UIImageView *imageViewPortion7;
@property (nonatomic, strong) UIImageView *imageViewPortion8;

@property (nonatomic, assign) NSInteger divideCounts; // remember portion count
@property (nonatomic, strong) NSMutableArray *imageArray;// save image
@end

@implementation DivideViewController

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
    [self initSubimage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseImage:(id)sender
{
    if ([self isPhotoLibraryAvailable]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        
        [self presentViewController:picker
                             animated:YES
                           completion:NULL];
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.imageEditor = [[DivideImageEditor alloc] initWithNibName:DIVIDE_IMAGE_EDITOR_VIEW bundle:nil];
        self.imageEditor.checkBounds = YES;
        self.imageEditor.rotateEnabled = YES;
        self.imageEditor.delegate = self;
        self.library = library;
        self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
            if(!canceled) {
                
            }
            [picker popToRootViewControllerAnimated:YES];
            [picker setNavigationBarHidden:NO animated:YES];
        };
    
    }

}

- (IBAction)saveImage:(id)sender
{
    if (_divideCounts == DivideFourParts) {
        
        [self saveFourImages];
        
    } else if (_divideCounts == DivideSixParts) {
        
        [self saveSixImages];
    
    } else if (_divideCounts == DivideNineParts) {
    
        [self saveNineImages];
    
    }
}

- (IBAction)clearSubimageAction:(id)sender
{
    [self clearSubimageView];
    
    self.imageViewPortion0.image = NULL;
}

//
//      ____________________
//      |  0  |   1  |  2  |
//      |_____|______|_____|
//      |  3  |   4  |  5  |
//      |_____|______|_____|
//      |  6  |   7  |  8  |
//      |_____|______|_____|
//      Four = 0, 1, 3, 4
//      Six  = 0~5
//      Nine = 0~8

#define ALTER_LOCATION_SAVE_FAIL NSLocalizedStringFromTable(@"ALTER_LOCATION_SAVE_FAIL", @"DivideViewController", @"Save fail")
#define ALTER_LOCATION_SAVE_FAIL_MESSAGE NSLocalizedStringFromTable(@"ALTER_LOCATION_SAVE_FAIL_MESSAGE", @"DivideViewController", @"Please choose photo what you want")
#define ALTER_LOCATION_OK NSLocalizedStringFromTable(@"ALTER_LOCALION_OK", @"DivideViewController", @"OK")
#define ALTER_LOCATION_SAVING NSLocalizedStringFromTable(@"ALTER_LOCATION_SAVING", @"DivideViewController", @"saving")
- (void) saveFourImages
{
    if (_imageViewPortion0.image) {
        
        [self clearImageArray];
        
        self.imageArray = [[NSMutableArray alloc] initWithArray:@[_imageViewPortion0.image,
                                                                  _imageViewPortion1.image,
                                                                  _imageViewPortion2.image,
                                                                  _imageViewPortion3.image]];
        
        UIImageWriteToSavedPhotosAlbum(_imageViewPortion0.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALTER_LOCATION_SAVE_FAIL //@"Save fail"
                                                        message:ALTER_LOCATION_SAVE_FAIL_MESSAGE
                                                       delegate:nil
                                              cancelButtonTitle:ALTER_LOCATION_OK
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)saveSixImages
{
    if (_imageViewPortion0.image) {
        
        [self clearImageArray];
        
        self.imageArray = [[NSMutableArray alloc] initWithArray:@[_imageViewPortion0.image,
                                                                  _imageViewPortion1.image,
                                                                  _imageViewPortion2.image,
                                                                  _imageViewPortion3.image,
                                                                  _imageViewPortion4.image,
                                                                  _imageViewPortion5.image]];
        
        UIImageWriteToSavedPhotosAlbum(_imageViewPortion0.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALTER_LOCATION_SAVE_FAIL //@"Save fail"
                                                        message:ALTER_LOCATION_SAVE_FAIL_MESSAGE
                                                       delegate:nil
                                              cancelButtonTitle:ALTER_LOCATION_OK
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)saveNineImages
{

    
    if (_imageViewPortion0.image) {
        
        // show activity
        [self activityShow];
        
        [self clearImageArray];
        
        self.imageArray = [[NSMutableArray alloc] initWithArray:@[_imageViewPortion0.image,
                                                                     _imageViewPortion1.image,
                                                                     _imageViewPortion2.image,
                                                                     _imageViewPortion3.image,
                                                                     _imageViewPortion4.image,
                                                                     _imageViewPortion5.image,
                                                                     _imageViewPortion6.image,
                                                                     _imageViewPortion7.image,
                                                                     _imageViewPortion8.image]];
        
        UIImageWriteToSavedPhotosAlbum(_imageViewPortion0.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALTER_LOCATION_SAVE_FAIL //@"Save fail"
                                                        message:ALTER_LOCATION_SAVE_FAIL_MESSAGE
                                                       delegate:nil
                                              cancelButtonTitle:ALTER_LOCATION_OK
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

#pragma mark -
#pragma Method
- (void)activityShow
{
    UIView *viewToUse = self.view;
    [DejalBezelActivityView activityViewForView:viewToUse withLabel:ALTER_LOCATION_SAVING width:80.0f];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
}


#pragma mark - save image recursive

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
        
        [_imageArray removeObjectAtIndex:0];
    }
    [self saveNext];
}


#define ACTIVITY_LOCATION_SAVE_SUCCESSFUL NSLocalizedStringFromTable(@"ACTIVITY_LOCATION_SAVE_SUCCESSFUL", @"DivideViewController", @"Save sucessful")
#define ACTIVITY_LOCATION_SAVE_SUCCESSFUL_MESSAGE NSLocalizedStringFromTable(@"ACTIVITY_LOCATION_SAVE_SUCCESSFUL_MESSAGE", @"DivideViewController", @"Image has been saved to the album")
-(void) saveNext
{
	if (self.imageArray.count > 0) {
        
		UIImage *image = [_imageArray objectAtIndex:0];
		UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
	} else {
        
        // cancel activity
        [DejalBezelActivityView removeViewAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ACTIVITY_LOCATION_SAVE_SUCCESSFUL //@"Save sucessful"
                                                        message:ACTIVITY_LOCATION_SAVE_SUCCESSFUL_MESSAGE //@"Image has been saved to the album"
                                                       delegate:nil
                                              cancelButtonTitle:ALTER_LOCATION_OK //@"OK"
                                              otherButtonTitles:nil];
        [alert show];
	}
}

#pragma mark -

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark -
#pragma mark clear Array

- (void)clearImageArray
{
    if (_imageArray) {
        [self.imageArray removeAllObjects];
    }
}
#pragma mark - 
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        self.imageEditor.sourceImage = image;
        self.imageEditor.previewImage = preview;
        [self.imageEditor reset:NO];
        
        
        [picker pushViewController:self.imageEditor animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get asset from library");
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark -
#pragma mark HFImageEditorViewDelegate

- (void)imageCropper:(HFImageEditorViewController *)cropperViewController divideCounts:(NSInteger)divideCounts didFinished:(UIImage *)editedImage;
{
    
    self.divideCounts = divideCounts; // setting divide counts
    [self clearSubimageView];
    switch (divideCounts) {
        case DivideFourParts:
            [self imageDivideFour:editedImage];
            break;
        case DivideSixParts:
            [self imageDivideSix:editedImage];
            break;
        case DivideNineParts:
            [self imageDivideNine:editedImage];
        default:
            NSLog(@"error");
            break;
    }
    [self addSubimageView];
    [cropperViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - image divide

- (void)imageDivideFour:(UIImage *)prepareDivideImage
{
    self.portionImageWidth = prepareDivideImage.size.width * (112.0f / 230.0f);  // 74 is a subimage width
    self.portionImageHeight = prepareDivideImage.size.height * (112.0f / 230.0f);
    
    self.imagePortionRatio = prepareDivideImage.size.width / 230.0f;            // 230 = 112 + 6 +112
    
    // row 0
    self.imageViewPortion0.image = [prepareDivideImage subimageWithRect:CGRectMake(0, 0, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion1.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_FOUR_WIDTH + SPACING_DIVIDE_FOUR) * _imagePortionRatio, 0, _portionImageWidth, _portionImageHeight)];
    
    // row 1
    self.imageViewPortion3.image = [prepareDivideImage subimageWithRect:CGRectMake(0, (SUBIMAGE_FOUR_HEIGHT + SPACING_DIVIDE_FOUR) * _imagePortionRatio , _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion4.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_FOUR_WIDTH + SPACING_DIVIDE_FOUR) * _imagePortionRatio, (SUBIMAGE_FOUR_HEIGHT + SPACING_DIVIDE_FOUR) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
}

- (void)imageDivideSix:(UIImage *)prepareDivideImage
{
    self.portionImageWidth = prepareDivideImage.size.width * (74.0f / 230.0f);  // 74 is a subimage width
    self.portionImageHeight = prepareDivideImage.size.height * (74.0f / 152.0f);
    
    self.imagePortionRatio = prepareDivideImage.size.width / 230.0f;            // 230 = 74 + 4 + 74 + 4 +74
    
    // row 0
    self.imageViewPortion0.image = [prepareDivideImage subimageWithRect:CGRectMake(0, 0, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion1.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * _imagePortionRatio, 0, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion2.image = [prepareDivideImage subimageWithRect:CGRectMake(((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * 2) * _imagePortionRatio, 0, _portionImageWidth, _portionImageHeight)];
    
    // row 1
    self.imageViewPortion3.image = [prepareDivideImage subimageWithRect:CGRectMake(0, (SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * _imagePortionRatio , _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion4.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * _imagePortionRatio, (SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion5.image = [prepareDivideImage subimageWithRect:CGRectMake(((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * 2) * _imagePortionRatio, (SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
}

- (void)imageDivideNine:(UIImage *)prepareDivideImage
{
    self.portionImageWidth = prepareDivideImage.size.width * (74.0f / 230.0f);  // 74 is a subimage width
    self.portionImageHeight = prepareDivideImage.size.height * (74.0f / 230.0f);
    
    self.imagePortionRatio = prepareDivideImage.size.width / 230.0f;            // 230 = 74 + 4 + 74 + 4 +74
    
    // row 0
    self.imageViewPortion0.image = [prepareDivideImage subimageWithRect:CGRectMake(0, 0, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion1.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * _imagePortionRatio, 0, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion2.image = [prepareDivideImage subimageWithRect:CGRectMake(((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * 2) * _imagePortionRatio, 0, _portionImageWidth, _portionImageHeight)];
    
    // row 1
    self.imageViewPortion3.image = [prepareDivideImage subimageWithRect:CGRectMake(0, (SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * _imagePortionRatio , _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion4.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * _imagePortionRatio, (SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion5.image = [prepareDivideImage subimageWithRect:CGRectMake(((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * 2) * _imagePortionRatio, (SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
    
    // row 2
    self.imageViewPortion6.image = [prepareDivideImage subimageWithRect:CGRectMake(0, ((SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * 2) * _imagePortionRatio , _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion7.image = [prepareDivideImage subimageWithRect:CGRectMake((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * _imagePortionRatio, ((SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * 2) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
    self.imageViewPortion8.image = [prepareDivideImage subimageWithRect:CGRectMake(((SUBIMAGE_NINE_AND_SIX_WIDTH + SPACING) * 2) * _imagePortionRatio,  ((SUBIMAGE_NINE_AND_SIX_HEIGHT + SPACING) * 2) * _imagePortionRatio, _portionImageWidth, _portionImageHeight)];
    
}

- (void)addSubimageView
{
    if (_divideCounts == DivideFourParts) {
        
        [self.view addSubview:_imageViewPortion0];
        [self.view addSubview:_imageViewPortion1];
        [self.view addSubview:_imageViewPortion3];
        [self.view addSubview:_imageViewPortion4];
        
    } else if (_divideCounts == DivideSixParts) {
        
        [self.view addSubview:_imageViewPortion0];
        [self.view addSubview:_imageViewPortion1];
        [self.view addSubview:_imageViewPortion2];
        [self.view addSubview:_imageViewPortion3];
        [self.view addSubview:_imageViewPortion4];
        [self.view addSubview:_imageViewPortion5];

    } else if (_divideCounts == DivideNineParts) {
        
        [self.view addSubview:_imageViewPortion0];
        [self.view addSubview:_imageViewPortion1];
        [self.view addSubview:_imageViewPortion2];
        [self.view addSubview:_imageViewPortion3];
        [self.view addSubview:_imageViewPortion4];
        [self.view addSubview:_imageViewPortion5];
        [self.view addSubview:_imageViewPortion6];
        [self.view addSubview:_imageViewPortion7];
        [self.view addSubview:_imageViewPortion8];
        
    }
}

- (void)clearSubimageView
{
    
    [_imageViewPortion0 removeFromSuperview];
    [_imageViewPortion1 removeFromSuperview];
    [_imageViewPortion2 removeFromSuperview];
    [_imageViewPortion3 removeFromSuperview];
    [_imageViewPortion4 removeFromSuperview];
    [_imageViewPortion5 removeFromSuperview];
    [_imageViewPortion6 removeFromSuperview];
    [_imageViewPortion7 removeFromSuperview];
    [_imageViewPortion8 removeFromSuperview];
   
}

// show image frame
- (void)initSubimage
{
    self.imageViewPortion0 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X, ENTIRE_IMAGE_Y, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion1 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_WIDTH + SPACING + ENTIRE_IMAGE_X, ENTIRE_IMAGE_Y, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion2 = [[UIImageView alloc] initWithFrame:CGRectMake((ENTIRE_IMAGE_WIDTH + SPACING) * 2 + ENTIRE_IMAGE_X, ENTIRE_IMAGE_Y, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion3 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X, ENTIRE_IMAGE_Y + ENTIRE_IMAGE_HEIGHT + SPACING , ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion4 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X + ENTIRE_IMAGE_WIDTH + SPACING, ENTIRE_IMAGE_Y + ENTIRE_IMAGE_HEIGHT + SPACING, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion5 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X + (ENTIRE_IMAGE_WIDTH + SPACING) * 2, ENTIRE_IMAGE_Y + ENTIRE_IMAGE_HEIGHT + SPACING, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion6 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X, ENTIRE_IMAGE_Y + (ENTIRE_IMAGE_HEIGHT + SPACING) * 2 , ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion7 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X + ENTIRE_IMAGE_WIDTH + SPACING, ENTIRE_IMAGE_Y + (ENTIRE_IMAGE_HEIGHT + SPACING) * 2, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
    self.imageViewPortion8 = [[UIImageView alloc] initWithFrame:CGRectMake(ENTIRE_IMAGE_X + (ENTIRE_IMAGE_WIDTH + SPACING) * 2, ENTIRE_IMAGE_Y + (ENTIRE_IMAGE_HEIGHT + SPACING) * 2, ENTIRE_IMAGE_WIDTH, ENTIRE_IMAGE_HEIGHT)];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end
