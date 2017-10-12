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
@end
