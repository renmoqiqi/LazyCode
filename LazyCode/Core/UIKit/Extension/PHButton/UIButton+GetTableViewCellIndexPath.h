//
//  UIButton+GetTableViewCellIndexPath.h
//  LazyCode
//
//  Created by penghe on 15/5/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GetTableViewCellIndexPath)
- (NSIndexPath *)getTableViewCellIndexPath;

- (NSIndexPath *)getTableViewCellIndexPathAtTableView:(UITableView *)tableView;
@end
