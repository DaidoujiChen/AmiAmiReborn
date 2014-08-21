//
//  AmiAmiParserObjects.h
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/5/2.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	AmiAmiParserStatusFail      =   0,
	AmiAmiParserStatusSuccess
} AmiAmiParserStatus;

typedef enum {
	AmiAmiParserEntryTypeRank       =   0,
	AmiAmiParserEntryTypeAll,
	AmiAmiParserEntryTypeProductInfo
} AmiAmiParserEntryType;

typedef void (^ArrayCompletion)(AmiAmiParserStatus status, NSArray *result);
typedef void (^DictionaryCompletion)(AmiAmiParserStatus status, NSDictionary *result);

@interface AmiAmiParserObjects : NSObject

@property (nonatomic, copy) ArrayCompletion arrayCompletion;
@property (nonatomic, copy) DictionaryCompletion dictionaryCompletion;
@property (nonatomic, strong) UIWebView *parseWebView;
@property (nonatomic, assign) AmiAmiParserEntryType entryType;

@property (nonatomic, strong) NSMutableArray *productImagesArray;
@property (nonatomic, strong) NSMutableArray *productInfomationArray;
@property (nonatomic, strong) NSMutableArray *relationProductsArray;
@property (nonatomic, strong) NSMutableArray *popularProductsArray;
@property (nonatomic, strong) NSMutableArray *alsoLikeProductArray;
@property (nonatomic, strong) NSMutableArray *alsoBuyProductArray;

@property (nonatomic, strong) DispatchTimer *webViewTimer;
@property (nonatomic, strong) DispatchTimer *timeoutTimer;

@property (nonatomic, assign) BOOL passFlag;
@property (nonatomic, strong) UIAlertView *passAlertView;

@property (nonatomic, strong) NSLock *parseLock;

@end
