//
//  ViewController.h
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/23/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate>
{
    ADBannerView *_adBanner;
    BOOL _bannerIsVisible;
    IBOutlet UITextField *txtSearchSong;
    IBOutlet UITableView *tbView;
    NSString *oldSearch;
    NSString *newSearch;
}
@property(nonatomic,assign)  IBOutlet UITextField *txtSearchSong;
@property (nonatomic,strong) NSMutableArray *tblDataList;
@property (nonatomic,assign)   IBOutlet UITableView *tbView;
@end

