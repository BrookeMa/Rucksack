//
//  CandidShowPhotoViewController.m
//  Rucksack
//
//  Created by MaYe on 14-3-1.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//

#import "CandidShowPhotoViewController.h"

@interface CandidShowPhotoViewController ()

@end

@implementation CandidShowPhotoViewController

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
	// Do any additional setup after loading the view.
    self.showPhoto.image = self.showPhotoImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
