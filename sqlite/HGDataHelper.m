//
//  HGDataHelper.m
//  sqlite
//
//  Created by koreadragon on 2017/10/11.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "HGDataHelper.h"

@interface HGDataHelper ()



@end

@implementation HGDataHelper

+(HGDataHelper*)shared{
    static dispatch_once_t onceToken;
    static HGDataHelper*data = nil;
    dispatch_once(&onceToken, ^{
        data = [[HGDataHelper alloc]init];
    });
    return data;
}

-(FMResultSet*)readDataFromTable:(NSString*)tableName{
    
    FMResultSet *set  = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
 
   
    return set;
}

-(BOOL)closeDB{
   return [self.db close];
}

-(BOOL)insertData:(NSString*)sql,...{
    
    if([self.db open]){
         return [self.db executeUpdate:sql];
    }else{
        return NO;
    }
 
}

-(BOOL)removeData:(NSString*)dataID tableName:(NSString*)tableName{
//    [self.db open];
    BOOL removeResult =  [self.db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = %@",tableName,dataID]];

//    [self.db close];
    return removeResult;
}
-(BOOL)removeDataWithIDs:(NSArray *)IDsArray tableName:(NSString *)tableName{
    [self.db beginTransaction];
    BOOL isRollBack = NO;
    BOOL deleteResult = NO;
    
    @try{
        for (NSString*ID in IDsArray) {
            NSString*sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = %@",tableName,ID];
            deleteResult = [self.db executeUpdate:sql];
        }
    }
    @catch(NSException *exception){
        isRollBack = YES;
        
        [self.db rollback];
    }
    
    @finally{
        if(!isRollBack){
            [self.db commit];
        }
    }
    
    return deleteResult;
    
    
}

-(BOOL)dropTable:(NSString*)tableName{
   return  [self.db executeUpdate:@"DROP TABLE %@ "];
    
}

-(BOOL)createTable:(NSString*)tableName{
     return [self.db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@  (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT NOT NULL,AGE INT NOT NULL,ADDRESS TEXT NOT NULL)",tableName]];
}

-(FMDatabase *)db{
    if(!_db){
        NSString*directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
        NSString*filePath = [directory stringByAppendingPathComponent:@"formal.db"];
        NSLog(@"数据库路径:%@",filePath);
       _db = [FMDatabase databaseWithPath:filePath];
    }
    return _db;
}


- (void)insertData:(int)fromIndex useTransaction:(BOOL)useTransaction tableName:(NSString*)tableName
{
//    [self.db open];
    if (useTransaction) {
        [self.db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = fromIndex; i<500+fromIndex; i++) {
                NSString *nId = [NSString stringWithFormat:@"%d",i];
                NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (id,student_name) VALUES (?,?)",tableName];
                BOOL a = [self.db executeUpdate:sql,nId,strName];
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [self.db rollback];
        }
        @finally {
            if (!isRollBack) {
                [self.db commit];
            }
        }
    }else{
        for (int i = fromIndex; i<500+fromIndex; i++) {
            NSString *nId = [NSString stringWithFormat:@"%d",i];
            NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
             NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (id,student_name) VALUES (?,?)",tableName];
            BOOL a = [self.db executeUpdate:sql,nId,strName];
            if (!a) {
                NSLog(@"插入失败2");
            }
        }
    }
//    [self.db close];
}

@end
