//
//  KaraokeViewCell.m
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/24/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import "KaraokeViewCell.h"

@implementation KaraokeViewCell

- (void)awakeFromNib {
    // Initialization code

}
-(void)loadNumberAndTitle
{
    UILabel *lbNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 35)/2, 75, 35)];
    [lbNumber setText:self.txtNumber];
    [lbNumber setTextColor:[UIColor redColor]];
    [self addSubview:lbNumber];
    
    UILabel *lbSongName = [[UILabel alloc] initWithFrame:CGRectMake(100, (self.frame.size.height - 35)/2, self.frame.size.width-100, 35)];
    [lbSongName setText:self.txtSongName];
    [lbSongName setTextColor:[UIColor blackColor]];
    [lbSongName setFont:[UIFont boldSystemFontOfSize:14]];
    [self addSubview:lbSongName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
