//
//  ResultTableViewController.h
//  sqlite
//
//  Created by koreadragon on 2017/10/10.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray*dataSourceArray;
@property(nonatomic,copy)NSString*tableName;
@end
