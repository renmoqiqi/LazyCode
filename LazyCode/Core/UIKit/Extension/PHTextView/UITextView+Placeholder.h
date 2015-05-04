//
//  UITextView+Placeholder.h
//  LazyCode
//
//  Created by penghe on 15/5/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)<UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeHolderTextView;
//@property (nonatomic, assign) id <UITextViewDelegate> textViewDelegate;
- (void)addPlaceHolder:(NSString *)placeHolder;
@end
