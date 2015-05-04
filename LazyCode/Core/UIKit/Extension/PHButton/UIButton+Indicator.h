//
//  UIButton+Indicator.h
//  LazyCode
//
//  Created by penghe on 15/5/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Simple category that lets you replace the text of a button with an activity indicator.
 */

@interface UIButton (Indicator)

/**
 This method will show the activity indicator in place of the button text.
 */
- (void) showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void) hideIndicator;
@end
