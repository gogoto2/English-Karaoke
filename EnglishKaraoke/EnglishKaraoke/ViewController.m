//
//  ViewController.m
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/23/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "KaraokeViewCell.h"
#import "DetailViewController.h"

#define DF_Color_RGB(a,b,c) [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1]
#define HeightCell 40
@interface ViewController ()

@end

@implementation ViewController
@synthesize tblDataList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = DF_Color_RGB(156, 96, 34);
    self.navigationController.navigationItem.title = @"English Song";
    [self.view setBackgroundColor:DF_Color_RGB(75, 131, 217)];
    
    if ( !tblDataList ) {
        self.tblDataList = [[NSMutableArray alloc] init];
    }

    self.txtSearchSong.returnKeyType = UIReturnKeyDone;
    self.tblDataList = [[DBManager getSharedInstance] loadData];
    [self.tbView reloadData];
    oldSearch = @"";
    newSearch= @"";
    
    for (UIView *subview in self.txtSearchSong.subviews) {
        for (UIView *subSubview in subview.subviews) {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
                UIView<UITextInputTraits> *textInputField = (UIView<UITextInputTraits> *)subSubview;
                textInputField.returnKeyType = UIReturnKeyDone;
                [textInputField setEnablesReturnKeyAutomatically:NO];
                break;
            }
        }
    }
    float padding = 0;
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ) {
        padding = 40;
    }
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - padding, self.view.frame.size.width, 70)];
    _adBanner.delegate = self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *txtSearch = textField.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.tblDataList count] > 0) {
            [self.tblDataList removeAllObjects];
        }
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtSearch];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (!valid)
        {
            self.tblDataList = [[DBManager getSharedInstance] loadDataByString:txtSearch];
        }
        else
        {
            self.tblDataList = [[DBManager getSharedInstance] loadDataByNumber:txtSearch];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tbView reloadData];
        });
    });

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    @try {
        if ( [newSearch isEqualToString:@""] ) {
            newSearch = string;
        }
        if ( ![textField.text isEqualToString:@""] && ![textField.text isEqualToString:string]) {
            newSearch = textField.text;
            
            if ([string isEqualToString:@""]) {
                newSearch = [newSearch substringToIndex:[newSearch length] - 1];
            }
            else
            newSearch = [newSearch stringByAppendingString:string];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([self.tblDataList count] > 0) {
                [self.tblDataList removeAllObjects];
            }
            BOOL valid;
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:newSearch];
            valid = [alphaNums isSupersetOfSet:inStringSet];
            if (!valid)
            {
                self.tblDataList = [[DBManager getSharedInstance] loadDataByString:newSearch];
            }
            else
            {
                self.tblDataList = [[DBManager getSharedInstance] loadDataByNumber:newSearch];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [self.tbView reloadData];
            });
        });

    }
    @catch (NSException *exception) {
        
    }
    return TRUE;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tblDataList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tblDataList count] > 0) {
        int indexValues = indexPath.row;
        NSString *indexNumber = [[self.tblDataList objectAtIndex:indexValues] objectAtIndex:0];
        NSString *identifier = [NSString stringWithFormat:@"Cell %@", indexNumber];
        KaraokeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        @try {
            if (cell == nil) {
                
                cell = [[KaraokeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.numberOfLines = 0;
                NSArray *objectSong = [tblDataList objectAtIndex:indexPath.row];
                NSString *titleSong = [objectSong objectAtIndex:1];
                NSString *numOfSong = [objectSong objectAtIndex:0];
                cell.txtNumber = numOfSong;
                cell.txtSongName = titleSong;
                [cell loadNumberAndTitle];
                
            }
            return cell;
        }
        @catch (NSException *exception) {
            return cell;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {

        int indexSelect = indexPath.row;
        NSArray *objectSong = [self.tblDataList objectAtIndex:indexSelect];
        NSString *txtNumberSong = [objectSong objectAtIndex:0];
        DetailViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailindentity"];
        newView.txtNum = txtNumberSong;
        [self.navigationController pushViewController:newView animated:YES];
        
    }
    @catch (NSException *exception) {
        
    }
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBanner.superview == nil)
        {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
}
@end
