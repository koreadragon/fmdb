//
//  KVOModel.h
//  sqlite
//
//  Created by koreadragon on 2017/10/12.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVOModel : NSObject

@property(nonatomic,strong)NSMutableArray*muDataArray;

 

/**
 测试执行事务批量操作数据
 */
+(void)test;
@end
