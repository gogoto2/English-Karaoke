//
//  KaraokeViewCell.h
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/24/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KaraokeViewCell : UITableViewCell
@property(nonatomic,assign)NSString *txtNumber;
@property(nonatomic,assign)NSString *txtSongName;
-(void)loadNumberAndTitle;
@end
