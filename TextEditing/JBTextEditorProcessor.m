//
//  JBTextEditorProcessor.m
//  TextEditing
//
//  Created by Jason Brennan on 12-06-04.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBTextEditorProcessor.h"

@implementation JBTextEditorProcessor


- (void)processStringAsynchronously:(NSString *)originalString changedSelectionRange:(NSRange)selectionRange deletedString:(NSString *)deletedString insertedString:(NSString *)insertedString completionHandler:(JBTextEditorProcessorCompletionHandler)completionHandler {
	NSString *originalCopy = [originalString copy];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		
		NSString *processedString = [originalCopy stringByReplacingCharactersInRange:selectionRange withString:insertedString];
		NSRange newSelectionRange = selectionRange;
		
		
		if (![insertedString length]) {
			// it's a deletion
			newSelectionRange.length = 0;
			//NSLog(@"deleted = %@", deletedString);
			
			NSString *pair = nil;
			
			
			NSUInteger len = [originalCopy length];
			NSUInteger selection = NSMaxRange(selectionRange);
			if (len == selection) {
				NSLog(@"max range");
			} else {
				NSLog(@"not");
				pair = [originalCopy substringWithRange:NSMakeRange(selectionRange.location, 2)];
				NSLog(@"pair = %@", pair);
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
			
			
			if ([insertedString isEqualToString:@"("]) {
				processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@")"];
			} else if ([insertedString isEqualToString:@"{"]) {
				processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@"}"];
			} else if ([insertedString isEqualToString:@"["]) {
				processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@"]"];
			} else if ([insertedString isEqualToString:@"“"]) {
				processedString = [processedString stringByReplacingCharactersInRange:newSelectionRange withString:@"”"];
			}
		}
		
		
		dispatch_sync(dispatch_get_main_queue(),^() {
			// Main Queue code
			completionHandler(processedString, newSelectionRange);
		});
		
	});
}


@end
