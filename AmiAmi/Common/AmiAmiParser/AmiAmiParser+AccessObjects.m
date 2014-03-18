//
//  AmiAmiParser+AccessObjects.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/2/24.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+AccessObjects.h"

@implementation AmiAmiParser (AccessObjects)

static const char ENTRYTYPEPOINTER;

static const char PRODUCTIMAGESPOINTER;
static const char PRODUCTINFORMATIONPOINTER;
static const char RELATIONPRODUCTSPOINTER;
static const char POPULARPRODUCTSPOINTER;
static const char ALSOLIKEPRODUCTPOINTER;
static const char ALSOBUYPRODUCTPOINTER;

static const char PARSEWEBVIEWPOINTER;
static const char COMPLETIONPOINTER;

static const char WEBVIEWTIMERPOINTER;
static const char PARSELOCKPOINTER;

static const char STARTDATEPOINTER;
static const char PASSFLAGPOINTER;
static const char PASSALERTVIEWPOINTER;

+(void) setArrayCompletion : (void (^)(AmiAmiParserStatus status, NSArray *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+(void (^)(AmiAmiParserStatus status, NSArray *result)) arrayCompletion {
    return objc_getAssociatedObject(self, &COMPLETIONPOINTER);
}

+(void) setDictionaryCompletion : (void (^)(AmiAmiParserStatus status, NSDictionary *result)) completion {
    objc_setAssociatedObject(self, &COMPLETIONPOINTER, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+(void (^)(AmiAmiParserStatus status, NSDictionary *result)) dictionaryCompletion {
    return objc_getAssociatedObject(self, &COMPLETIONPOINTER);
}

+(void) setEntryType : (AmiAmiParserEntryType) entryType {
    objc_setAssociatedObject(self, &ENTRYTYPEPOINTER, [NSNumber numberWithInt:entryType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) setParseWebView : (UIWebView*) parseWebView {
    objc_setAssociatedObject(self, &PARSEWEBVIEWPOINTER, parseWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(UIWebView*) parseWebView {
    return objc_getAssociatedObject(self, &PARSEWEBVIEWPOINTER);
}

+(AmiAmiParserEntryType) entryType {
    NSNumber *entry = objc_getAssociatedObject(self, &ENTRYTYPEPOINTER);
    return [entry intValue];
}

+(void) setWebViewTimer : (NSTimer*) webViewTimer {
    objc_setAssociatedObject(self, &WEBVIEWTIMERPOINTER, webViewTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(NSTimer*) webViewTimer {
    return objc_getAssociatedObject(self, &WEBVIEWTIMERPOINTER);
}

+(void) setStartDate : (NSDate*) startDate {
    objc_setAssociatedObject(self, &STARTDATEPOINTER, startDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(NSDate*) startDate {
    return objc_getAssociatedObject(self, &STARTDATEPOINTER);
}

+(void) setPassFlag : (BOOL) passFlag {
    objc_setAssociatedObject(self, &PASSFLAGPOINTER, [NSNumber numberWithBool:passFlag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(BOOL) passFlag {
    return [(NSNumber*)objc_getAssociatedObject(self, &PASSFLAGPOINTER) boolValue];
}

+(void) setPassAlertView : (UIAlertView*) passAlertView {
    objc_setAssociatedObject(self, &PASSALERTVIEWPOINTER, passAlertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(UIAlertView*) passAlertView {
    return objc_getAssociatedObject(self, &PASSALERTVIEWPOINTER);
}

+(NSLock*) parseLock {
    if (!objc_getAssociatedObject(self, &PARSELOCKPOINTER)) {
        NSLock *parseLock = [NSLock new];
        objc_setAssociatedObject(self, &PARSELOCKPOINTER, parseLock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &PARSELOCKPOINTER);
}

+(NSMutableArray*) productImagesArray {
    if (!objc_getAssociatedObject(self, &PRODUCTIMAGESPOINTER)) {
        objc_setAssociatedObject(self, &PRODUCTIMAGESPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &PRODUCTIMAGESPOINTER);
}

+(NSMutableArray*) productInfomationArray {
    if (!objc_getAssociatedObject(self, &PRODUCTINFORMATIONPOINTER)) {
        objc_setAssociatedObject(self, &PRODUCTINFORMATIONPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &PRODUCTINFORMATIONPOINTER);
}

+(NSMutableArray*) relationProductsArray {
    if (!objc_getAssociatedObject(self, &RELATIONPRODUCTSPOINTER)) {
        objc_setAssociatedObject(self, &RELATIONPRODUCTSPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &RELATIONPRODUCTSPOINTER);
}

+(NSMutableArray*) popularProductsArray {
    if (!objc_getAssociatedObject(self, &POPULARPRODUCTSPOINTER)) {
        objc_setAssociatedObject(self, &POPULARPRODUCTSPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &POPULARPRODUCTSPOINTER);
}

+(NSMutableArray*) alsoLikeProductArray {
    if (!objc_getAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER)) {
        objc_setAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &ALSOLIKEPRODUCTPOINTER);
}

+(NSMutableArray*) alsoBuyProductArray {
    if (!objc_getAssociatedObject(self, &ALSOBUYPRODUCTPOINTER)) {
        objc_setAssociatedObject(self, &ALSOBUYPRODUCTPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &ALSOBUYPRODUCTPOINTER);
}
@end
