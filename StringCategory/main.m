//
//  main.m
//  StringCategory
//
//  Created by Luc-Olivier on 4/15/16.
//  Copyright © 2016 Luc-Olivier. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSMutableString+StringCategory.h"


int main(int argc, const char * argv[]) {
	@autoreleasepool {
		
		@try {
			//printf("𤮃\n");
			unichar res = [NSMutableString unicodeScalarOfChar: @"丁"];
			printf("%hu\n", res);
		} @catch (NSException *e) {
			printf("%s - %s\n", _c(e.name), _c(e.reason));
		}
		
		@try {
			NSMutableString *_char = [NSMutableString stringWithString: @"丁"];
			printf("%hu\n", [_char unicodeScalar]);
		} @catch (NSException *e) {
			printf("%s - %s\n", _c(e.name), _c(e.reason));
		}
		
		@try {
			NSMutableString *_char = [NSMutableString stringWithString: @"😇"];
			printf("%hu\n", [_char unicodeScalar]);
		} @catch (NSException *e) {
			printf("%s - %s\n", _c(e.name), _c(e.reason));
		}
		
		printf("--------------------\n");
		printf("#stringWithChar\n");
		
		
		NSString *s = [NSMutableString stringWithChar:@"•" amount:10];
		printf("%s\n", _c(s));
		
		
		printf("--------------------\n");
		printf("#occuranceOfStringIn, occuranceOfString\n");
		
		NSMutableString *targetocc = [NSMutableString stringWithString:@"Hello,   World,  great       World - the the the the"];
		printf("%s\n", _c(targetocc));
		
		@try {
			//int amount = [NSMutableString occuranceOfStringIn:targetocc string:@"the"];
			int amount = [targetocc occuranceOfString: @"the"];
			printf("%i\n", amount);

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}
	
		
		printf("--------------------\n");
		printf("#rangeOfStringIn, rangeOfString\n");

		
		NSMutableString *targetrg = [NSMutableString stringWithString:@"Hello,   World,  great       World - the the the the"];
		printf("%s\n", _c(targetrg));

		StringExtension_ResultWithRange r = [NSMutableString rangeOfStringIn:targetrg string:@"World" occurence:-1];
		printf("%li,%li - %s\n", r.range.location, r.range.length, _c([StringExtensionResults result:r.result]));

		StringExtension_ResultWithRange r0 = [targetrg rangeOfString:@"World" occurence:-1];
		printf("%li,%li - %s\n", r0.range.location, r0.range.length, _c([StringExtensionResults result:r0.result]));

		NSMutableString *target2 = [NSMutableString stringWithString:@"to-to1111"];
		StringExtension_ResultWithRange r2 = [target2 rangeOfString:@"to" occurence:-1];
		printf("%li,%li - %s\n", r2.range.location, r2.range.length, _c([StringExtensionResults result:r2.result]));
		
		
		printf("--------------------\n");
		printf("#removeDoubleSpaceToString, removeDoubleSpace\n");

		
		NSMutableString *targetremsp = [NSMutableString stringWithString:@"Hello,   World,  great       World - the the the the"];
		printf("%s\n", _c(targetremsp));
		
		@try {
			StringExtension_Result SR0 = [NSMutableString removeDoubleSpaceToString: targetremsp];

			if (SR0.result == RemoveDoubleSpace_Success) {
				printf("%s - %s\n", _c(targetremsp), _c([StringExtensionResults result:SR0.result]));
			}

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}

		@try {
			StringExtension_Result SR0 = [targetremsp removeDoubleSpace];

			if (SR0.result == RemoveDoubleSpace_Success) {
				printf("%s - %s\n", _c(targetremsp), _c([StringExtensionResults result:SR0.result]));
			}

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}
		
		
		printf("--------------------\n");
		printf("#removeStringTo, #removeString\n");
		
		
		NSMutableString *targetrem = [NSMutableString stringWithString:@"Hello,   World,  great       World - the the the the"];
		printf("%s\n", _c(targetrem));
		
		@try {
			StringExtension_Result r2 = [NSMutableString removeStringTo:targetrem string: @"World" occurence: 1];

			if (r2.result == RemoveString_Success) {
				printf("%s - %s\n", _c(targetrem), _c([StringExtensionResults result:r2.result]));
			}

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}

		@try {
			StringExtension_Result r2 = [targetrem removeString: @"the" occurence: 4];

			if (r2.result == RemoveString_Success) {
				printf("%s - %s\n", _c(targetrem), _c([StringExtensionResults result:r2.result]));
			}

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}
		
		
		printf("--------------------\n");
		printf("#insertToString, #insertString\n");

		
		NSMutableString *targetins = [NSMutableString stringWithString:@"Hello,   World,  great       World - the the the the"];
		printf("%s\n", _c(targetins));
		
		@try {
			StringExtension_Result r1 = [NSMutableString insertToString:targetins string:@" and marvelous " anchor:@"great" occurence:1 mode:After];

			if (r1.result == InsertString_Success) {
				printf("%s - %s\n", _c(targetins), _c([StringExtensionResults result:r1.result]));
			}

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}

		@try {
			StringExtension_Result r1 = [targetins insertString: @":" anchor:@"W" occurence:1 mode:Before];

			if (r1.result == InsertString_Success) {
				printf("%s - %s\n", _c(targetins), _c([StringExtensionResults result:r1.result]));
			}

		} @catch (NSException *e) {
			printf("%s\n", _c(e.name));
		}
		
		
		printf("--------------------\n");
		printf("#replaceToString, #replaceString\n");
		
		
		
		NSMutableString *targetrep = [NSMutableString stringWithString:@"Hello,   World,  great       World - the the the the"];
		printf("%s\n", _c(targetrem));
		
		@try {
			//StringExtension_Result r1 = [NSMutableString replaceToString: targetrep anchor: @"the" string: @"THE!!!" occurence: 4];
			StringExtension_Result r1 = [targetrep replaceString: @"Hello" string: @"THE!!!" occurence: 1];
			
			if (r1.result == ReplaceString_Success) {
				printf("|%s| %s\n", _c(targetrep), _c([StringExtensionResults result:r1.result]));
			} else {
				printf("%s\n", _c([StringExtensionResults result:r1.result]));
			}
			
		} @catch (NSException *e) {
			printf(">> %s\n", _c(e.name));
		}
		
	
	}
}

