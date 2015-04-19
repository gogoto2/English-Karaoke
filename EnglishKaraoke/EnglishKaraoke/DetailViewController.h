//
//  DetailViewController.h
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/25/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property(nonatomic,assign) IBOutlet UILabel *lblNUmber;
@property(nonatomic,assign)  IBOutlet UILabel *lblNameSong;
@property(nonatomic,assign)   IBOutlet UILabel *lblLyric;
@property(nonatomic,assign) IBOutlet UILabel *lblLanguge;
@property(nonatomic,assign) IBOutlet UILabel *lblMeta;
@property(nonatomic,assign)NSString *txtNum;
@end
