//
//  KVOModel.m
//  sqlite
//
//  Created by koreadragon on 2017/10/12.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "KVOModel.h"

@implementation KVOModel

-(instancetype)init{
  
    if(self = [super init]){
        
        _muDataArray = [NSMutableArray new];
    }
    return self;
}


-(id)initWith{
    if(self = [super init]){
        
        _muDataArray = [NSMutableArray new];
    }
    return self;
}


+(void)test{
    [[HGDataHelper shared].db executeUpdate:@"CREATE TABLE IF NOT EXISTS stu1 (id TEXT,student_name TEXT)"];
     [[HGDataHelper shared].db executeUpdate:@"CREATE TABLE IF NOT EXISTS stu2 (id TEXT,student_name TEXT)"];
 
    [[HGDataHelper shared] insertData:0 useTransaction:NO tableName:@"stu1"];
    NSDate *date1 = [NSDate date];
    [[HGDataHelper shared] insertData:500 useTransaction:NO tableName:@"stu1"];
    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"不使用事务插入500条数据用时%.3f秒",a);
    [[HGDataHelper shared] insertData:1000 useTransaction:YES tableName:@"stu1"];
    NSDate *date3 = [NSDate date];
    NSTimeInterval b = [date3 timeIntervalSince1970] - [date2 timeIntervalSince1970];
    NSLog(@"使用事务插入500条数据用时%.3f秒",b);
}
@end
