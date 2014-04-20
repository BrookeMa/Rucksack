//
//  DivideImageEditor.m
//  Rucksack
//
//  Created by MaYe on 14-2-17.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//

#import "DivideImageEditor.h"
#import "HFImageEditorViewController+Private.h"
#import "Utility.h"

#define DIVIDE_NINE_AND_FOUR_FRAME IS_IPHONE ? CGRectMake(0, 100, 320, 320) : CGRectMake(64, 100, 640, 640)
#define DIVIDE_SIX_FRAME IS_IPHONE ? CGRectMake(0, 153, 320, 216) : CGRectMake(64, 153, 640, 432)

typedef NS_ENUM(NSInteger, DivideCounts)
{
    DivideFourParts = 4,
    DivideSixParts = 6,
    DivideNineParts = 9
};

@interface DivideImageEditor ()

- (IBAction)setFourPortraitAction:(id)sender;
- (IBAction)setSixPortraitAction:(id)sender;
- (IBAction)setNinePortraitAction:(id)sender;

@property (nonatomic, strong) UIImageView *divideShapeNineImageView;
@property (nonatomic, strong) UIImageView *divideShapeSixImageView;
@property (nonatomic, strong) UIImageView *divideShapeFourImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *divideFourButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *divideSixButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *divideNineButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation DivideImageEditor

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.cropRect = CGRectMake(0,0,320,320);
        self.minimumScale = 0.2;
        self.maximumScale = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // default init
    [self setNinePortraitAction:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setFourPortraitAction:(id)sender
{
    //clear all divide image view
    [self clearDivideImageView];
    
    self.divideShapeFourImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DivideShapeFourImage"]];
    [self.divideShapeFourImageView setFrame:DIVIDE_NINE_AND_FOUR_FRAME];
    
    self.cropRect = DIVIDE_NINE_AND_FOUR_FRAME;
    
    
    [self reset:YES];
    self.divideCounts = DivideFourParts;
    [self.view addSubview:_divideShapeFourImageView];
}

- (IBAction)setSixPortraitAction:(id)sender
{
    [self clearDivideImageView];
    
  
    self.divideShapeSixImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DivideShapeSixImage"]];
    [self.divideShapeSixImageView setFrame:DIVIDE_SIX_FRAME];
    
    self.cropRect = DIVIDE_SIX_FRAME;
  
    [self reset:YES];
    self.divideCounts = DivideSixParts;
    [self.view addSubview:_divideShapeSixImageView];
}

- (IBAction)setNinePortraitAction:(id)sender
{
    [self clearDivideImageView];
    
    self.divideShapeNineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DivideShapeNineImage"]];
    [self.divideShapeNineImageView setFrame:DIVIDE_NINE_AND_FOUR_FRAME];
    
    self.cropRect = DIVIDE_NINE_AND_FOUR_FRAME;
    
    
    [self reset:YES];
    self.divideCounts = DivideNineParts;
    [self.view addSubview:_divideShapeNineImageView];
}

#pragma mark Hooks
- (void)startTransformHook
{
    self.saveButton.tintColor = [UIColor colorWithRed:0 green:49/255.0f blue:98/255.0f alpha:1];
}

- (void)endTransformHook
{
    self.saveButton.tintColor = [UIColor colorWithRed:0 green:128/255.0f blue:1 alpha:1];
}

#pragma mark -
#pragma mark hidden status bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)clearDivideImageView
{
    if (_divideShapeFourImageView) {
        [_divideShapeFourImageView removeFromSuperview];
    }
    
    if (_divideShapeSixImageView) {
        [_divideShapeSixImageView removeFromSuperview];
    }
    
    if (_divideShapeNineImageView) {
        [_divideShapeNineImageView removeFromSuperview];
    }
}
@end
