//
//  ViewController.m
//  sqlite
//
//  Created by koreadragon on 2017/10/10.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "ViewController.h"
#import "ResultTableViewController.h"

@interface ViewController ()

@property(nonatomic,strong)FMDatabase*db;
@property(nonatomic,strong)UIButton*createDBButton;
@property(nonatomic,strong)UITextField*databaseNameField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   [ self.createDBButton addTarget:self action:@selector(createStore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.databaseNameField];
    self.navigationItem.title = @"数据库demo";
    [self addRightButton];
    
    [self createDB];
}

-(void)addRightButton{
    UIBarButtonItem*right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pushToShowResult)];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)pushToShowResult{
    //首先读取数据
    FMResultSet *set = [self.db executeQuery:@"SELECT * FROM HAN"];
    NSMutableArray*arr = [NSMutableArray new];
    while ([set next]) {
        NSString*name = [set stringForColumn:@"NAME"];
        [arr addObject:name];
    }
    
    ResultTableViewController*res = [ResultTableViewController new];
    res.dataSource = arr;
    [self.navigationController pushViewController:res animated:YES];
}
-(void)createStore:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新增" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"id int";
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"name text";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"age int";
    }];

    UIAlertAction*sure = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray* array = alert.textFields;
        NSString*userId = ((UITextField*)array[0]).text;
        NSString*name = ((UITextField*)array[1]).text;
        NSString*age = ((UITextField*)array[2]).text;
        
        if(userId.length == 0){
            [self alert:@"请填写id"];
            return;
        }
        if(name.length == 0){
            [self alert:@"请填写name"];
             return;
        }
        if(age.length == 0){
            [self alert:@"请填写age"];
             return;
        }
        
        
      BOOL re =   [self.db executeUpdate:@"INSERT INTO HAN VALUES (?,?,?)",userId,name,age];
        if(re){
            [self alert:@"插入成功"];
        }
    }];
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)createDB{
    NSString*directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //
    //    if(self.databaseNameField.text.length == 0){
    //         [self alert:@"请输入数据库名称"];
    //        return;
    //    }
    //    NSString*userInput = self.databaseNameField.text;
    //    if(![userInput hasSuffix:@"db"]){
    //        userInput = [userInput stringByAppendingString:@".db"];
    //    }
    
    NSString*filePath = [directory stringByAppendingPathComponent:@"formal.db"];
    NSLog(@"数据库路径:%@",filePath);
    self.db = [FMDatabase databaseWithPath:filePath];
    if([self.db open]){
        NSLog(@"数据库打开成功!");
//        [self alert:@"数据库打开成功!"];
        //创建表
     BOOL res = [self.db executeUpdate:@"CREATE TABLE HAN (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT NOT NULL,AGE INT NOT NULL)"];
        if(res){
//            [self alert:@"创建表成功"];
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }else{
        NSLog(@"数据库打开失败!");
//        [self alert:@"数据库打开失败!"];
    }
    
   
}

-(void)dealloc{
    if([self.db close]){
        //        [self alert:@"数据库关闭"];
    }else{
        //        [self alert:@"数据库关闭失败"];
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
            
            make.top.mas_equalTo(self.databaseNameField.mas_bottom).with.offset(20);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self.view);
            
        }];
        [_createDBButton setTitle:@"添加数据" forState:UIControlStateNormal];
        _createDBButton.backgroundColor = RGB(22, 102, 248, 1.0);
        [_createDBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
    return _createDBButton;
}
-(UITextField *)databaseNameField{
    if(!_databaseNameField){
        _databaseNameField = [UITextField new ];
       [self.view addSubview:_databaseNameField];
        [_databaseNameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(20);;
          
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
