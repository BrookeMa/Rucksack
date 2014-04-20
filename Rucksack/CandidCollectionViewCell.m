//
//  CandidCollectionViewCell.m
//  Rucksack
//
//  Created by MaYe on 14-2-15.
//  Copyright (c) 2014年 MaYe. All rights reserved.
//

#import "CandidCollectionViewCell.h"

@implementation CandidCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)photoSelectAction:(id)sender
{
    if (self.photoSelectButton.selected) {
        self.photoSelectButton.selected = NO;
    } else {
        self.photoSelectButton.selected = YES;
        
    }
}
@end
