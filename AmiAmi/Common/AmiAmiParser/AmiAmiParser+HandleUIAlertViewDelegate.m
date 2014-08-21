//
//  AmiAmiParser+HandleUIAlertViewDelegate.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+HandleUIAlertViewDelegate.h"

#import "AmiAmiParser+AccessObjects.h"
#import "AmiAmiParser+MiscFunctions.h"

@implementation AmiAmiParser (HandleUIAlertViewDelegate)

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
		{
			[self objects].passAlertView = nil;
			[[self objects].parseWebView reload];
			[self setTimeout];
			break;
		}
            
		case 1:
		{
			[self objects].passAlertView = nil;
			[self objects].passFlag = YES;
			break;
		}
            
		default:
			break;
	}
}

@end
