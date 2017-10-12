//
//  ResultTableViewController.m
//  sqlite
//
//  Created by koreadragon on 2017/10/10.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "ResultTableViewController.h"

static NSString*observeArray = @"muDataArray";

@interface ResultTableViewController ()

@property(nonatomic,strong)NSMutableArray*selectedArray;
@property(nonatomic,strong)UILabel*bottomEditView;//用来在编辑状态下批量删除的view
@property(nonatomic,strong)KVOModel*model;

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详细数据";
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
     [self.editButtonItem setTitle:@"删除"];
    
    [self.model addObserver:self forKeyPath:observeArray options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil ];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:observeArray]){
        
        if(self.model.muDataArray.count == 0){
            self.bottomEditView.backgroundColor = [UIColor lightGrayColor];
            self.bottomEditView.textColor = [UIColor grayColor];
        }else{
            self.bottomEditView.backgroundColor =RGB(255,51,102,1.0);
            
            self.bottomEditView.textColor = [UIColor whiteColor];
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if(self.editing){
        //所有编辑状态的配置
 
        [self.editButtonItem setTitle:@"完成"];
   
        self.bottomEditView.alpha = 1.0;
    }else{

        [self.editButtonItem setTitle:@"删除"];
 
        [UIView animateWithDuration:0.5 animations:^{
            
            self.bottomEditView.alpha = 0.0;
            
        }];
        [[self.model mutableArrayValueForKey:observeArray] removeAllObjects];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
 
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    
    NSDictionary*userInfo = self.dataSourceArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"【%@岁】%@",userInfo[@"AGE"],userInfo[@"NAME"]];
    cell.detailTextLabel.text = userInfo[@"ADDRESS"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
     
    // Configure the cell...
    
    return cell;
}

#pragma mark - 待删除数据发生变化
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*userInfo = self.dataSourceArray[indexPath.row];
    
    if(tableView.isEditing){
        [[self.model mutableArrayValueForKey:observeArray] addObject:userInfo];
        NSLog(@"已选中的数据:%@",self.model.muDataArray);
        
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self modifyCellData:tableView indexPath:indexPath userInfo:userInfo];
        
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*userInfo = self.dataSourceArray[indexPath.row];
    
    if(tableView.isEditing){
        [[self.model mutableArrayValueForKey:observeArray] removeObject:userInfo];
        NSLog(@"取消后，已选中的数据:%@",self.model.muDataArray);
        
    }
}
-(void)modifyCellData:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath userInfo:(NSDictionary*)userInfo{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改信息" message:@"各项信息为必填项" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"NAME TEXT";
        textField.text = userInfo[@"NAME"];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"AGE INT";
        textField.text = userInfo[@"AGE"];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ADDRESS TEXT";
        textField.text = userInfo[@"ADDRESS"];
        
    }];
    
    UIAlertAction*sure = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        
        
        BOOL re =   [[HGDataHelper shared].db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET NAME = '%@',AGE = %@,ADDRESS = '%@' WHERE ID = %@",_tableName,name,age,address,userInfo[@"ID"]]];
        if(re){
            [self.view endEditing:YES];
            //            [self alert:@"插入成功"];
            NSLog(@"修改数据成功");
            [self.dataSourceArray replaceObjectAtIndex:indexPath.row withObject:@{@"ID":userInfo[@"ID"],@"NAME":name,@"AGE":age,@"ADDRESS":address}];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)alert:(NSString*)title{
    UIAlertView*view = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
    [view show];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark - 删除事件

/**
 批量删除数据

 @param tap 点击手势
 */
-(void)deleteData:(UITapGestureRecognizer*)tap{
    if([self.model mutableArrayValueForKey:observeArray].count == 0){
        return;
    }
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"是否删除？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*sure = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSMutableArray*idsArray = [NSMutableArray new];
        for (NSDictionary*dic in [self.model mutableArrayValueForKey:observeArray]) {
            NSString*ID = dic[@"ID"];
            [idsArray addObject:ID];
        }
        //需要删除数据库中的数据
       BOOL res =  [[HGDataHelper shared]removeDataWithIDs:idsArray tableName:_tableName];
        if(res){
            [self.dataSourceArray removeObjectsInArray:[self.model mutableArrayValueForKey:observeArray]];
            [[self.model mutableArrayValueForKey:observeArray] removeAllObjects];
            [self.tableView reloadData];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil] ;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary*removeOBJ = self.dataSourceArray[indexPath.row];
        NSString*removeID = removeOBJ[@"ID"];
       BOOL delete =  [[HGDataHelper shared] removeData:removeID tableName:_tableName];
        if(delete){
            
            [self.dataSourceArray removeObject:self.dataSourceArray[indexPath.row]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(NSMutableArray *)selectedArray{
    if(!_selectedArray){
        _selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}

-(KVOModel *)model{
    if(!_model){
        _model = [[KVOModel alloc]init];
    }
    return _model;
}
-(UILabel *)bottomEditView{
    if(!_bottomEditView){
        _bottomEditView = [UILabel new];
       [self.tableView addSubview:_bottomEditView];
        [_bottomEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.tableView);
            make.centerX.mas_equalTo(self.tableView);
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
            make.height.mas_equalTo(49);
        }];
        _bottomEditView.backgroundColor = [UIColor lightGrayColor];
        _bottomEditView.text = @"批量删除";
        _bottomEditView.textColor = [UIColor grayColor];
        _bottomEditView.textAlignment = NSTextAlignmentCenter;
        _bottomEditView.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteData:)];
        [_bottomEditView addGestureRecognizer:tap];
        
    }
    return _bottomEditView;
}

-(void)dealloc{
    [self.model removeObserver:self forKeyPath:observeArray context:nil];
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
