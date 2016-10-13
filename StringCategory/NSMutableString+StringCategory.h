//
//  NSMutableString+StringCategory.h
//  StringCategory
//
//  Created by Luc-Olivier on 4/15/16.
//  Copyright © 2016 Luc-Olivier. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _c(o) [o cStringUsingEncoding:NSUTF8StringEncoding]


/* ============================================================================
 
 ToDo: 
 
 ============================================================================ */


typedef enum {
	ReplaceString_StringToInsert_Void,
	ReplaceString_StringAnchor_Void,
	
	InsertString_StringToInsert_Void,
	InsertString_StringAnchor_Void,
	
	RemoveString_StringToRemove_Void,
	
	RangeOfString_VoidString,
	RangeOfString_BadOccurence,
	
	OccurenceOfString_VoidString,
	
	StringWithChar_NotAChar,
	StringWithChar_AmountToZero,
	
	UnicodeScalar_NotAOneCharString
	
} StringExtensionExceptions_t;

@interface StringExtensionExceptions : NSObject
+ (NSException*) exception: (StringExtensionExceptions_t) name;
@end

typedef enum {
	Undefined,

	ReplaceString_Success,
	ReplaceString_Exception,
	
	InsertString_Success,
	InsertString_Exception,
	
	RemoveString_Success,
	RemoveString_Exception,
	
	RemoveDoubleSpace_Success,
	RemoveDoubleSpace_NoSpaceToRemove,
	RemoveDoubleSpace_Exception,
	
	RangeOfString_StringFound,
	RangeOfString_StringNotFound,
	RangeOfString_LastStringOccurenceFound,
	RangeOfString_StringOccurenceFound,
	RangeOfString_StringFoundButOccurenceNotFound,
	RangeOfString_Exception
} StringExtensionResults_t;

@interface StringExtensionResults: NSObject
+ (NSString*) result: (StringExtensionResults_t) name;
@end

typedef enum {
	Before,
	After
} StringInsertMode_t;

typedef struct {
	StringExtensionResults_t result;
	void *error;
} StringExtension_Result;

typedef struct {
	NSRange range;
	StringExtensionResults_t result;
	void *error;
} StringExtension_ResultWithRange;

@interface NSMutableString (StringCategory)

- (StringExtension_Result) replaceString: (NSString*) anchor string: (NSString*) string occurence: (int) occurence;

+ (StringExtension_Result) replaceToString: (NSMutableString*) target anchor: (NSString*) anchor string: (NSString*) string occurence: (int) occurence;

- (StringExtension_Result) insertString: (NSString*) string anchor: (NSString*) anchor occurence: (int) occurence mode: (StringInsertMode_t) mode;
+ (StringExtension_Result) insertToString: (NSMutableString*) target string: (NSString*) string anchor: (NSString*) anchor occurence: (int) occurence mode: (StringInsertMode_t) mode;

- (StringExtension_Result) removeString: (NSString*) string  occurence: (int) occurence;
+ (StringExtension_Result) removeStringTo: (NSMutableString*) target string: (NSString*) string  occurence: (int) occurence;

- (StringExtension_Result) removeDoubleSpace;
+ (StringExtension_Result) removeDoubleSpaceToString: (NSMutableString*) target;

- (StringExtension_ResultWithRange) rangeOfString: (NSString*) string occurence: (int) occurence;
+ (StringExtension_ResultWithRange) rangeOfStringIn: (NSString*) target string: (NSString*) string occurence: (int) occurence;

+ (NSString*) stringWithChar: (NSString*) character amount: (unsigned int) amount;

- (unsigned int) occuranceOfString: (NSString*) string;
+ (unsigned int) occuranceOfStringIn: (NSString*) target string: (NSString*) string;

// Not working with Subroggates
- (unichar) unicodeScalar;
+ (unichar) unicodeScalarOfChar: (NSString*) string;

@end
