//
//  CandidCameraViewController.h
//  Rucksack
//
//  Created by MaYe on 14-2-22.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidCameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIImagePickerController *imagePicker;
    IBOutlet UIView *cameraOverlayView;
    
    NSMutableArray *imagesArray;    // the selected and select images
    NSInteger count;                
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savePhotoButton;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@end
