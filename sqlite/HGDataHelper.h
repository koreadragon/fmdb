//
//  HGDataHelper.h
//  sqlite
//
//  Created by koreadragon on 2017/10/11.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGDataHelper : NSObject

@property(nonatomic,strong)FMDatabase*db;

/**
 单例初始化

 @return 实例
 */
+(HGDataHelper*)shared;

/**
 从表中读取数据

 @param tableName 表名
 @return 从表中读取的结果集
 */
-(FMResultSet*)readDataFromTable:(NSString*)tableName;

/**
 通过数据id删除数据

 @param dataID 待删除数据的id
 @param tableName 待删除数据所在表名
 @return 删除的结果
 */
-(BOOL)removeData:(NSString*)dataID tableName:(NSString*)tableName;
/**
 关闭数据库

 @return 关闭数据库状态，yes表示正常关闭，no表示关闭异常
 */
-(BOOL)closeDB;

/**
 删除表
 
 @param tableName 待删除的表名
 @return 删除的结果
 */
-(BOOL)dropTable:(NSString*)tableName;


/**
 创建表

 @param tableName 待创建的表名
 @return 创建结果
 */
-(BOOL)createTable:(NSString*)tableName;












@end
