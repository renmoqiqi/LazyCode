//
//  UIButton+GetTableViewCellIndexPath.m
//  LazyCode
//
//  Created by penghe on 15/5/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "UIButton+GetTableViewCellIndexPath.h"

@implementation UIButton (GetTableViewCellIndexPath)
- (NSIndexPath *)getTableViewCellIndexPath
{
    UIView *cell = self.superview;

    while (![cell isKindOfClass:[UITableViewCell class]])
    {
        cell = cell.superview;
    }

    UIView *tableView = self.superview;

    while (![tableView isKindOfClass:[UITableView class]])
    {
        tableView = tableView.superview;
    }


    NSIndexPath *indexPath = [(UITableView *)tableView indexPathForCell:(UITableViewCell *)cell];

    return indexPath;
}

- (NSIndexPath *)getTableViewCellIndexPathAtTableView:(UITableView *)tableView{
    CGPoint point = [self convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];

    return indexPath;
}
@end
