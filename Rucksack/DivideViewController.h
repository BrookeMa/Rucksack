//
//  DivideViewController.h
//  Rucksack
//
//  Created by MaYe on 14-1-28.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DivideImageEditor.h"

@interface DivideViewController : UIViewController <HFImageEditorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)chooseImage:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)clearSubimageAction:(id)sender;

@end
