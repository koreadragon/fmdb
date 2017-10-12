//
//  ViewController.m
//  sqlite
//
//  Created by koreadragon on 2017/10/10.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "ViewController.h"
#import "ResultTableViewController.h"

static NSString*tableName = @"STUDENT";

@interface ViewController ()


@property(nonatomic,strong)UIButton*createDBButton;
@property(nonatomic,strong)UITextField*databaseNameField;
@property(nonatomic,strong)UIButton*pushButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   [ self.createDBButton addTarget:self action:@selector(createStore:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.databaseNameField];
    self.navigationItem.title = @"数据库demo";
 
    [self.pushButton  addTarget:self action:@selector(seeData) forControlEvents:UIControlEventTouchUpInside];
    
    [self createTable];
}



-(void)seeData{
    //首先读取数据
    FMResultSet *set = [[HGDataHelper shared] readDataFromTable:tableName];
    NSMutableArray*arr = [NSMutableArray new];
    while ([set next]) {
        NSString*name = [set stringForColumn:@"NAME"];
        NSString*age = [set stringForColumn:@"AGE"];
        NSString*address = [set stringForColumn:@"ADDRESS"];
        NSString*userId = [set stringForColumn:@"ID"];
        [arr addObject:@{@"ID":userId,@"NAME":name,@"AGE":age,@"ADDRESS":address}];
    }
    //arr根据数组中字典的某个键排序
    //由于此时age字段是NSString类型，直接比较会出现bug，例如@"12"会比@"3"小，因为字符串比较时从前往后逐一对比，由于1<3,所以判定@"12"总体比3小
//    [arr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"AGE" ascending:YES]]];
    [arr sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if([obj1[@"AGE"] intValue] < [obj2[@"AGE"] intValue]){
            return NSOrderedAscending;
        }else if ([obj1[@"AGE"] intValue] > [obj2[@"AGE"] intValue]){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
        
    }];
    ResultTableViewController*res = [ResultTableViewController new];
    res.dataSourceArray = arr;
    res.tableName = tableName;
    [self.navigationController pushViewController:res animated:YES];
}
-(void)createStore:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新增英雄信息" message:@"各项信息为必填项" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"NAME TEXT";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"AGE INT";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ADDRESS TEXT";
        
    }];

    UIAlertAction*sure = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray* array = alert.textFields;
        NSString*name = ((UITextField*)array[0]).text;
        NSString*age = ((UITextField*)array[1]).text;
        NSString*address = ((UITextField*)array[2]).text;
        
        if(name.length == 0){
            [self alert:@"请填写name"];
            return;
        }
        if(age.length == 0){
            [self alert:@"请填写age"];
             return;
        }
        if(address.length == 0){
            [self alert:@"请填写address"];
             return;
        }
        
        
      BOOL re =   [[HGDataHelper shared].db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (NAME,AGE,ADDRESS) VALUES (?,?,?)",tableName],name,age,address];
        if(re){
            [self.view endEditing:YES];
//            [self alert:@"插入成功"];
            NSLog(@"插入数据成功");
        }
    }];
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)createTable{
 
    if([[HGDataHelper shared].db open]){
        NSLog(@"数据库打开成功!");
 
        //创建表
        BOOL res =  [[HGDataHelper shared].db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@  (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT NOT NULL,AGE INT NOT NULL,ADDRESS TEXT NOT NULL)",tableName]];
        if(res){
 
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }else{
        NSLog(@"数据库打开失败!");
 
    }
    
   
}

-(void)dealloc{
 
    if([[HGDataHelper shared]closeDB]){
        NSLog(@"数据库关闭成功...");
    }else{
        NSLog(@"数据库关闭失败!");
    }
}

-(void)alert:(NSString*)title{
    UIAlertView*view = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
    [view show];
}

-(UIButton *)createDBButton{
    if(!_createDBButton){
        _createDBButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [self.view addSubview:_createDBButton];
        [_createDBButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(64);;
            make.width.mas_equalTo(self.view).multipliedBy(0.5);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view);
            
        }];
        _createDBButton.layer.cornerRadius = 5.0;
        [_createDBButton setTitle:@"添加数据" forState:UIControlStateNormal];
//        _createDBButton.backgroundColor = RGB(22, 102, 248, 1.0);
        [_createDBButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_createDBButton setTitleColor:RGB(22, 102, 248, 1.0) forState:UIControlStateNormal];
    }
    
    
    return _createDBButton;
}

-(UIButton *)pushButton{
    if(!_pushButton){
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_pushButton];
        [_pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(-64);;
            make.width.mas_equalTo(self.view).with.offset(-10);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(self.view);
            
        }];
        _pushButton.layer.cornerRadius = 3.0;
        [_pushButton setTitle:@"查看数据" forState:UIControlStateNormal];
        _pushButton.backgroundColor = RGB(236, 0, 6, 0.6);
        [_pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    return _pushButton;
}
-(UITextField *)databaseNameField{
    if(!_databaseNameField){
        _databaseNameField = [UITextField new ];
       [self.view addSubview:_databaseNameField];
        [_databaseNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(20);
          
            make.width.mas_equalTo(self.createDBButton);
            make.height.mas_equalTo(self.createDBButton);
            make.centerX.mas_equalTo(self.createDBButton);
        }];
        _databaseNameField.textAlignment = NSTextAlignmentCenter;
        _databaseNameField.placeholder = @"数据库名称";
        
    }
    
    return _databaseNameField;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
