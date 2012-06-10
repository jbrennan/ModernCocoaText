//
//  JBTextEditorProcessor.m
//  TextEditing
//
//  Created by Jason Brennan on 12-06-04.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBTextEditorProcessor.h"

@implementation JBTextEditorProcessor


- (void)processString:(NSString *)originalString changedSelectionRange:(NSRange)selectionRange deletedString:(NSString *)deletedString insertedString:(NSString *)insertedString completionHandler:(JBTextEditorProcessorCompletionHandler)completionHandler {
	NSString *originalCopy = [originalString copy];

		
	NSString *processedString = [originalCopy stringByReplacingCharactersInRange:selectionRange withString:insertedString];
	NSRange newSelectionRange = selectionRange;
	
	
	if (![insertedString length]) {
		
		newSelectionRange.length = 0;
		
		NSString *pair = nil;
		if ([originalCopy length] != NSMaxRange(selectionRange)) {
			pair = [originalCopy substringWithRange:NSMakeRange(selectionRange.location, 2)];
		}
		
		if ([pair length]) {
			
			NSRange pairRange = NSMakeRange(selectionRange.location, 2);
			
			if ([pair isEqualToString:@"()"] ||
				[pair isEqualToString:@"[]"] ||
				[pair isEqualToString:@"{}"] ||
				[pair isEqualToString:@"“”"]) {
				processedString = [originalCopy stringByReplacingCharactersInRange:pairRange withString:@""];
			}
		}
		
		
		
		
	} else {
		// insertion
		newSelectionRange.length = 0;
		newSelectionRange.location += 1;
		
		
		// Check for the opening of a pair
		if ([insertedString isEqualToString:@"("]) {
			processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@")"];
		} else if ([insertedString isEqualToString:@"{"]) {
			processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@"}"];
		} else if ([insertedString isEqualToString:@"["]) {
			processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@"]"];
		} else if ([insertedString isEqualToString:@"“"]) {
			processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@"”"];
		}
		
		
		// check for the closing of a pair
		
		
		NSString *pair = nil;
		if ([originalCopy length] > NSMaxRange(selectionRange)) {
			pair = [processedString substringWithRange:NSMakeRange(selectionRange.location, 2)];
		}
		
		if ([pair length]) {
			if ([pair isEqualToString:@"))"] ||
				[pair isEqualToString:@"]]"] ||
				[pair isEqualToString:@"}}"] ||
				[pair isEqualToString:@"””"]) {
				
				processedString = originalCopy;
			}
		}
		
	}
	
	
	// Main Queue code
	completionHandler(processedString, newSelectionRange);

}


@end
