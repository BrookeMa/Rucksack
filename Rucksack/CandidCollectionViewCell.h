//
//  CandidCollectionViewCell.h
//  Rucksack
//
//  Created by MaYe on 14-2-15.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *photoSelectButton;
- (IBAction)photoSelectAction:(id)sender;

@end
