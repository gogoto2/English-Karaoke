//
//  DetailViewController.m
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/25/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import "DetailViewController.h"
#import "DBManager.h"
#define DF_Color_RGB(a,b,c) [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1]

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize lblLanguge,lblMeta,lblLyric,lblNameSong,lblNUmber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:DF_Color_RGB(75, 131, 217)];
    
    NSMutableArray *listSong = [[NSMutableArray alloc] init];
    listSong = [[DBManager getSharedInstance] loadDataByExactNumber:self.txtNum];
    if ([listSong count] > 0) {
        
        NSString *txtNumber = [listSong objectAtIndex:0];
        NSString *txtNameSong = [listSong objectAtIndex:1];
        NSString *txtLyric = [listSong objectAtIndex:2];
        NSString *txtlanguage = [listSong objectAtIndex:3];
        NSString *txtMeta = [listSong objectAtIndex:4];
        
        
        [self.lblNUmber setText:[NSString stringWithFormat:@"# %@",txtNumber]];
        [self.lblNUmber setFont:[UIFont boldSystemFontOfSize:17]];
        [self.lblNUmber setTextColor:[UIColor redColor]];
        
        [self.lblNameSong setText:[NSString stringWithFormat:@"Tên bài hát: %@",txtNameSong]];
        [self.lblNameSong setFont:[UIFont boldSystemFontOfSize:15]];

        [self.lblLyric setText:[NSString stringWithFormat:@"Lời bài hát: %@",txtLyric]];

        [self.lblLanguge setText:[NSString stringWithFormat:@"Ngôn ngữ: %@",txtlanguage]];
        
        [self.lblMeta setText:[NSString stringWithFormat:@"Trình bày: %@",txtMeta]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
