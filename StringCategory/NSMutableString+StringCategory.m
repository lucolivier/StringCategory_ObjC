//
//  NSMutableString+StringCategory.m
//  StringCategory
//
//  Created by Luc-Olivier on 4/15/16.
//  Copyright © 2016 Luc-Olivier. All rights reserved.
//

#import "NSMutableString+StringCategory.h"

@implementation StringExtensionExceptions
+ (NSException*) exception: (StringExtensionExceptions_t) name {
	NSArray *names = @[
					   @"ReplaceString_StringToInsert_Void",
					   @"ReplaceString_StringAnchor_Void",
					   
					   @"InsertString_StringToInsert_Void",
					   @"InsertString_StringAnchor_Void",
					   
					   @"RemoveString_StringToRemove_Void",
					   
					   @"RangeOfString_VoidString",
					   @"RangeOfString_BadOccurence",
					   
					   @"OccurenceOfString_VoidString",
					   
					   @"StringWithChar_NotAChar",
					   @"StringWithChar_AmountToZero",
					   
					   @"UnicodeScalar_NotAOneCharString"
					   ];
	return [NSException exceptionWithName:names[name] reason:nil userInfo:nil];
}
@end

@implementation StringExtensionResults
+ (NSString*) result: (StringExtensionResults_t) name {
	NSArray *names = @[
						@"Undefined",

						@"ReplaceString_Success",
						@"ReplaceString_Exception",
						
						@"InsertString_Success",
						@"InsertString_Exception",

						@"RemoveString_Success",
						@"RemoveString_Exception",

						@"RemoveDoubleSpace_Success",
						@"RemoveDoubleSpace_NoSpaceToRemove",
						@"RemoveDoubleSpace_Exception",

						@"RangeOfString_StringFound",
						@"RangeOfString_StringNotFound",
						@"RangeOfString_LastStringOccurenceFound",
						@"RangeOfString_StringOccurenceFound",
						@"RangeOfString_StringFoundButOccurenceNotFound",
						@"RangeOfString_Exception"
			  ];
	return names[name];
}
@end

@implementation NSMutableString (StringCategory)

- (StringExtension_Result) replaceString: (NSString*) anchor string: (NSString*) string occurence: (int) occurence {
	
	StringExtension_Result result;
	
	@try {
		result = [NSMutableString replaceToString: self anchor: anchor string: string occurence: occurence];
		return result;
		
	} @catch (NSException *exception) {
		//return (StringExtension_Result){ReplaceString_Exception, nil};
		@throw exception;
	}
}

+ (StringExtension_Result) replaceToString: (NSMutableString*) target anchor: (NSString*) anchor string: (NSString*) string occurence: (int) occurence {
	
	if ([string length] == 0) { @throw [StringExtensionExceptions exception:ReplaceString_StringToInsert_Void]; }
	if ([anchor length] == 0) { @throw [StringExtensionExceptions exception:ReplaceString_StringAnchor_Void]; }
	
	StringExtension_ResultWithRange result;
	
	@try {
		result  = [NSMutableString rangeOfStringIn: target string: anchor occurence: occurence];
		if (result.range.length == 0) { return (StringExtension_Result){result.result,result.error}; }
		
		[target replaceCharactersInRange:result.range withString:string];
		
		return (StringExtension_Result){ReplaceString_Success,nil};
		
	} @catch (NSException *exception) {
		//return (StringExtension_Result){ReplaceString_Exception,(__bridge void *)(exception)};
		@throw exception;
	}
}


- (StringExtension_Result) insertString: (NSString*) string anchor: (NSString*) anchor occurence: (int) occurence mode: (StringInsertMode_t) mode {
	
	StringExtension_Result result;
	
	@try {
		result = [NSMutableString insertToString: self string: string anchor: anchor occurence: occurence mode: mode];
		return result;

	} @catch (NSException *exception) {
		//return (StringExtension_Result){InsertString_Exception, nil};
		@throw exception;
	}
}

+ (StringExtension_Result) insertToString: (NSMutableString*) target string: (NSString*) string anchor: (NSString*) anchor occurence: (int) occurence mode: (StringInsertMode_t) mode {
	
	if ([string length] == 0) { @throw [StringExtensionExceptions exception:InsertString_StringToInsert_Void]; }
	if ([anchor length] == 0) { @throw [StringExtensionExceptions exception:InsertString_StringAnchor_Void]; }
	
	StringExtension_ResultWithRange result;
	
	@try {
		result  = [NSMutableString rangeOfStringIn: target string: anchor occurence: occurence];
		if (result.range.length == 0) { return (StringExtension_Result){result.result,result.error}; }
		if (mode == Before) {
			[target insertString:string atIndex:result.range.location];
		} else {
			[target insertString:string atIndex:result.range.location+result.range.length];
		}
		return (StringExtension_Result){InsertString_Success,nil};
		
	} @catch (NSException *exception) {
		//return (StringExtension_Result){InsertString_Exception,(__bridge void *)(exception)};
		@throw exception;
	}
}

- (StringExtension_Result) removeString: (NSString*) string  occurence: (int) occurence {
	StringExtension_Result result;
	
	@try {
		
		result = [NSMutableString removeStringTo: self string: string occurence: occurence];
		return result;
		
	} @catch (NSException *exception) {
		//return (StringExtension_Result) {InsertString_Exception, (__bridge void *)(exception)};
		@throw exception;
	}
}

+ (StringExtension_Result) removeStringTo: (NSMutableString*) target string: (NSString*) string  occurence: (int) occurence {
	
	if ([string length] == 0) { @throw [StringExtensionExceptions exception:RemoveString_StringToRemove_Void]; }
	
	StringExtension_ResultWithRange range;
	
	@try {
		
		range = [NSMutableString rangeOfStringIn: target string: string occurence: occurence];
		if (range.range.length == 0) {
			return (StringExtension_Result) {range.result, nil};
		}
		[target deleteCharactersInRange:range.range];
		return (StringExtension_Result) {RemoveString_Success, nil};
		
	} @catch (NSException *exception) {
		//return (StringExtension_Result) {RemoveString_Exception, (__bridge void *)(exception)};
		@throw exception;
	}
}

- (StringExtension_Result) removeDoubleSpace {
	@try {
		return [NSMutableString removeDoubleSpaceToString: self];
		
	} @catch (NSException *exception) {
		@throw exception;
	}
}

+ (StringExtension_Result) removeDoubleSpaceToString: (NSMutableString*) target {
	StringExtension_ResultWithRange range;
	StringExtension_Result result;
	range.range.length = 1;
	int cpt = 0;
	while (range.range.length != 0) {
		
		@try {
		
			range = [NSMutableString rangeOfStringIn: target string: @"  " occurence: 1];
			if (range.range.length != 0) {
				
				result = [NSMutableString removeStringTo: target string: @"  " occurence: 1];
				if (result.result == RemoveString_Success) {
					cpt++;
				}
				// >> All is thrown deeply!!!
				//if (result.result == RemoveString_Exception) {
				//	return (StringExtension_Result){RemoveDoubleSpace_Exception,result.error};
				//}
			}
			
		} @catch (NSException *exception) {
			//return (StringExtension_Result) {RemoveString_Exception, (__bridge void *)(exception)};
			@throw exception;
		}
	}
	if (cpt == 0) {
		return (StringExtension_Result) {RemoveDoubleSpace_NoSpaceToRemove, nil};
	} else if (result.result ==  RemoveString_Success) {
		return (StringExtension_Result) {RemoveDoubleSpace_Success, nil};
	}
	return (StringExtension_Result) {RemoveString_Exception, result.error};
}

- (StringExtension_ResultWithRange) rangeOfString: (NSString*) string occurence: (int) occurence {
	StringExtension_ResultWithRange result;
	@try {
		result =  [NSMutableString rangeOfStringIn: self string: string occurence: occurence];
		return result;
		
	} @catch (NSException *exception) {
		//return (StringExtension_ResultWithRange) {{0,0}, RangeOfStringOccurence_Exception, &exception};
		@throw exception;
	}
	
}

+ (StringExtension_ResultWithRange) rangeOfStringIn: (NSString*) target string: (NSString*) string occurence: (int) occurence {
	
	// 1=1st, -1=last, n=nth
	
	if ([string length] == 0) { @throw [StringExtensionExceptions exception:RangeOfString_VoidString]; }
	if (occurence < -1) { @throw [StringExtensionExceptions exception:RangeOfString_BadOccurence]; }
	
	StringExtension_ResultWithRange result;
	
	NSRange resultRange = {0,0};
	NSRange currentRange = {0, [target length]};
	StringExtensionResults_t resultName = Undefined;
	
	if (occurence == 1) {
		resultRange = [target rangeOfString:string];
		resultName = (resultRange.length != 0) ? RangeOfString_StringFound : RangeOfString_StringNotFound;
		return (StringExtension_ResultWithRange){resultRange, resultName, nil};
	} else {
		
		int cpt = 0;
		
		NSRange resultRangeBkp = {0,0};
		while (cpt != occurence) {
			
			resultRange = [target rangeOfString:string options:NSLiteralSearch range:currentRange];

			if (resultRange.length != 0) {
				cpt += 1;
				if ((resultRange.location+resultRange.length) >= [target length]) { break; }
				currentRange.location = resultRange.location+resultRange.length;
				currentRange.length = [target length] - currentRange.location;
			} else {
				break;
			}
			resultRangeBkp = resultRange;
		}
		if (occurence == -1) {
			if (resultRange.length != 0) {
				result.range = resultRange;
			} else {
				result.range = resultRangeBkp;
			}
			result.result = (result.range.length != 0) ? RangeOfString_LastStringOccurenceFound : RangeOfString_StringNotFound;
		} else {
			if (cpt == 0) {
				result.range = resultRange;
				result.result = RangeOfString_StringNotFound;
			} else if (cpt == occurence) {
				result.range = resultRange;
				result.result = RangeOfString_StringOccurenceFound;
			} else {
				result.range.length = 0;
				result.result = RangeOfString_StringFoundButOccurenceNotFound;
			}
		}
	}
	return result;
}

+ (NSString*) stringWithChar: (NSString*) character amount: (unsigned int) amount {
	if ([character length] != 1) { @throw [StringExtensionExceptions exception:StringWithChar_NotAChar]; }
	if (amount < 1) { @throw [StringExtensionExceptions exception:StringWithChar_AmountToZero]; }
	
	NSMutableString *string = [NSMutableString stringWithString:@""];
	for (int i=0; i < amount; i++) {
		[string appendString:character];
	}
	return string;
}

- (unsigned int) occuranceOfString: (NSString*) string {
	if ([string length] < 1) { @throw [StringExtensionExceptions exception:OccurenceOfString_VoidString]; }
	@try {
		return [NSMutableString occuranceOfStringIn: self string:string];
	} @catch (NSException *exception) {
		@throw exception;
	}
}

+ (unsigned int) occuranceOfStringIn: (NSString*) target string: (NSString*) string {
	if ([string length] < 1) { @throw [StringExtensionExceptions exception:OccurenceOfString_VoidString]; }
	NSRange resultRange;
	NSRange currentRange = {0, [target length]};
	unsigned int cpt = 0;
	while (true) {
		resultRange = [target rangeOfString:string options:NSLiteralSearch range:currentRange];
		if (resultRange.length != 0) {
			cpt += 1;
			if ((resultRange.location+resultRange.length) >= [target length]) { break; }
			currentRange.location = resultRange.location+resultRange.length;
			currentRange.length = [target length] - currentRange.location;
		} else {
			break;
		}
	}
	return cpt;
}

// Not working with Subroggates
- (unichar) unicodeScalar {
	@try {
		return [NSMutableString unicodeScalarOfChar: self];
	} @catch (NSException *exception) {
		@throw exception;
	}
}

+ (unichar) unicodeScalarOfChar: (NSString*) string {
	if ([string length] != 1) { @throw [StringExtensionExceptions exception:UnicodeScalar_NotAOneCharString]; }
	return [string characterAtIndex:0];
}

@end


