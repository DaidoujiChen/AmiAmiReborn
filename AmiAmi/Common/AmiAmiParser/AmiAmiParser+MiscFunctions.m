//
//  AmiAmiParser+MiscFunctions.m
//  AmiAmi
//
//  Created by 啟倫 陳 on 2014/3/19.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "AmiAmiParser+MiscFunctions.h"

#import "AmiAmiParser+AccessObjects.h"
#import "AmiAmiParser+Parser.h"

@implementation AmiAmiParser (MiscFunctions)

+(NSMutableDictionary*) parshThumbnailWithTitle : (TFHppleElement*) element {
    NSMutableDictionary *dictionaryInArray = [NSMutableDictionary dictionary];
    [dictionaryInArray setObject:[element objectForKey:@"href"] forKey:@"URL"];
    TFHppleElement *child = [element firstChild];
    [dictionaryInArray setObject:[child objectForKey:@"src"] forKey:@"Thumbnail"];
    [dictionaryInArray setObject:[child objectForKey:@"alt"] forKey:@"Title"];
    return dictionaryInArray;
}

+(void) freeMemory {
    [[self webViewTimer] invalidate];
    [[self parseLock] unlock];
    objc_removeAssociatedObjects(self);
}

+(NSString*) mergeContentTexts : (TFHppleElement*) content {
    NSMutableString *returnString = [NSMutableString string];
    
    NSCharacterSet *emptyCharacter = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([content text] != nil &&
        ![[[[content text] componentsSeparatedByCharactersInSet:emptyCharacter] componentsJoinedByString:@""] isEqualToString:@""]) {
        [returnString appendString:[content text]];
    }
    
    for (TFHppleElement *eachChild in [content children]) {
        [returnString appendString:[self mergeContentTexts:eachChild]];
    }
    
    return returnString;
}

+(UIWebView*) makeParseWebViewWithURL : (NSURL*) parseURL {
    UIWebView *parserWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [parserWebView setDelegate:(id<UIWebViewDelegate>)self];
    [parserWebView loadRequest:[NSURLRequest requestWithURL:parseURL]];
    return parserWebView;
}

@end
