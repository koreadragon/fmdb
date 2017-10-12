//
//  ResultTableViewController.m
//  sqlite
//
//  Created by koreadragon on 2017/10/10.
//  Copyright © 2017年 koreadragon. All rights reserved.
//

#import "ResultTableViewController.h"

@interface ResultTableViewController ()

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详细数据";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
     
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary*userInfo = self.dataSourceArray[indexPath.row];
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
