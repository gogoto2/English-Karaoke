//
//  DBManager.m
//  KaraokePlus
//
//  Created by Nguyen Huu Hoang on 3/23/15.
//  Copyright (c) 2015 Phoenix NH. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
static NSString *DBNamePath = @"karaokeplus.sqlite";
static NSString *DBTableName = @"notes";

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
//    NSArray *dirPaths;
    // Get the documents directory
//    dirPaths = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = dirPaths[0];
    
    docsDir = [[NSBundle mainBundle] pathForResource:@"/karaokeplus" ofType:@"sqlite"];
    
    databasePath = [[NSString alloc] initWithString:docsDir];

    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
//        const char *dbpath = [databasePath UTF8String];
//        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//        {
//            char *errMsg;
//            const char *sql_stmt =
//            "create table if not exists karaoke (id integer primary key autoincrement, title text, description text)";
//            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
//                != SQLITE_OK)
//            {
//                isSuccess = NO;
//                NSLog(@"Failed to create table");
//            }
//            sqlite3_close(database);
//            return  isSuccess;
//        }
//        else {
//            isSuccess = NO;
//            NSLog(@"Failed to open/create database");
//        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString*)title
      description:(NSString*)description
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"insert into karaoke (title, description) values (\"%@\",\"%@\")",title, description];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            sqlite3_reset(statement);
            return YES;
        }
        else {
            sqlite3_close(database);
            sqlite3_reset(statement);
            return NO;
        }
    }
    sqlite3_close(database);
    sqlite3_reset(statement);
    return NO;
}
- (BOOL) deletaData:(int)_id
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"delete from karaoke where id = %d",_id];
        const char *insert_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            sqlite3_reset(statement);
            return YES;
        }
        else {
            sqlite3_close(database);
            sqlite3_reset(statement);
            return NO;
        }
    }
    sqlite3_close(database);
    sqlite3_reset(statement);
    return NO;
}

- (NSMutableArray*)loadData
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ZROWID,ZSNAME from ZSONG WHERE ZSLANGUAGE = 'en' LIMIT 50"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *objectSong = [[NSMutableArray alloc] init];
                NSString *_id = [[NSString alloc] initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 0)];
                [objectSong addObject:_id];
                NSString *_title = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                [objectSong addObject:_title];
                [resultArray addObject:objectSong];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return resultArray;
    }
    return nil;
}
- (NSMutableArray*)loadDataByString:(NSString*)_valueFill
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
         sqlite3_stmt *stm;
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ZROWID,ZSNAME from ZSONG where ZSNAMECLEAN LIKE '%@%%' and ZSLANGUAGE = 'en'  LIMIT 500",_valueFill];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &stm, NULL) == SQLITE_OK)
        {
            NSString *_id = @"";
            NSString *_title = @"";
            while (sqlite3_step(stm) == SQLITE_ROW)
            {
                NSMutableArray *objectSong = [[NSMutableArray alloc] init];
                
                char * text = (char *) sqlite3_column_text(stm, 0);
                if (text != nil) {
                    _id = [NSString stringWithUTF8String:text];
                }else{
                    _id = @"";
                }
                
                text = (char *) sqlite3_column_text(stm, 1);
                if (text != nil) {
                    _title = [NSString stringWithUTF8String:text];
                }else{
                    _title = @"";
                }
                
                [objectSong addObject:_id];
                [objectSong addObject:_title];
                 [resultArray addObject:objectSong];
            }
        }
        sqlite3_finalize(stm);
        return resultArray;
    }
    return nil;
}
- (NSMutableArray*)loadDataByNumber:(NSString *)_valueFill
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ZROWID,ZSNAME from ZSONG where ZROWID LIKE '%@%%' and ZSLANGUAGE = 'en' LIMIT 500",_valueFill];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &stm, NULL) == SQLITE_OK)
        {
            NSString *_id = @"";
            NSString *_title = @"";
            while (sqlite3_step(stm) == SQLITE_ROW)
            {
                NSMutableArray *objectSong = [[NSMutableArray alloc] init];
                
                char * text = (char *) sqlite3_column_text(stm, 0);
                if (text != nil) {
                    _id = [NSString stringWithUTF8String:text];
                }else{
                    _id = @"";
                }
                
                text = (char *) sqlite3_column_text(stm, 1);
                if (text != nil) {
                    _title = [NSString stringWithUTF8String:text];
                }else{
                    _title = @"";
                }
                
                [objectSong addObject:_id];
                [objectSong addObject:_title];
                [resultArray addObject:objectSong];
            }
        }
        sqlite3_finalize(stm);
        return resultArray;
    }
    return nil;
}
- (NSMutableArray*)loadDataByExactNumber:(NSString*)_valueFill
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        sqlite3_stmt *stm;
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ZROWID,ZSNAME,ZSLYRIC,ZSLANGUAGE,ZSMETA from ZSONG where ZROWID = %@ and ZSLANGUAGE = 'en' ",_valueFill];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &stm, NULL) == SQLITE_OK)
        {
            NSString *_id = @"";
            NSString *_title = @"";
            NSString *_lyric = @"";
            NSString *_language = @"";
            NSString *_meta = @"";
            while (sqlite3_step(stm) == SQLITE_ROW)
            {
                char * text = (char *) sqlite3_column_text(stm, 0);
                if (text != nil) {
                    _id = [NSString stringWithUTF8String:text];
                }else{
                    _id = @"";
                }
                
                text = (char *) sqlite3_column_text(stm, 1);
                if (text != nil) {
                    _title = [NSString stringWithUTF8String:text];
                }else{
                    _title = @"";
                }
                
                text = (char *) sqlite3_column_text(stm, 2);
                if (text != nil) {
                    _lyric = [NSString stringWithUTF8String:text];
                }else{
                    _lyric = @"";
                }
                
                text = (char *) sqlite3_column_text(stm, 3);
                if (text != nil) {
                    _language = [NSString stringWithUTF8String:text];
                }else{
                    _language = @"";
                }
                text = (char *) sqlite3_column_text(stm, 4);
                if (text != nil) {
                    _meta = [NSString stringWithUTF8String:text];
                }else{
                    _meta = @"";
                }
                
                [resultArray addObject:_id];
                [resultArray addObject:_title];
                [resultArray addObject:_lyric];
                [resultArray addObject:_language];
                [resultArray addObject:_meta];
            }
        }
        sqlite3_finalize(stm);
        return resultArray;
    }
    return nil;
}

@end
