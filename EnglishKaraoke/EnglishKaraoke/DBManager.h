//
//  DBManager.h
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/23/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}
+(DBManager*)getSharedInstance;
- (BOOL)createDB;
- (BOOL) saveData:(NSString*)title description:(NSString*)description;
- (NSMutableArray*)loadData;
- (BOOL) deletaData:(int)_id;
- (NSMutableArray*)loadDataByString:(NSString*)_valueFill;
- (NSMutableArray*)loadDataByNumber:(NSString*)_valueFill;
- (NSMutableArray*)loadDataByExactNumber:(NSString*)_valueFill;
@end