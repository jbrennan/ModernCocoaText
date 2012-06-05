//
//  JBTextEditorProcessor.m
//  TextEditing
//
//  Created by Jason Brennan on 12-06-04.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBTextEditorProcessor.h"

@implementation JBTextEditorProcessor


- (void)processStringAsynchronously:(NSString *)string changedSelectionRange:(NSRange)selectionRange replacementString:(NSString *)replacementString completionHandler:(JBTextEditorProcessorCompletionHandler)completionHandler {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		
		NSString *processedString = [string copy];
		NSRange newSelectionRange = selectionRange;
		
		
		if (![replacementString length]) {
			// it's a deletion
			newSelectionRange.length = 0;
			
		} else {
			// insertion
			newSelectionRange.length = 0;
			newSelectionRange.location += 1;
			if ([replacementString isEqualToString:@"("]) {
				processedString = [processedString stringByAppendingFormat:@")"];
				
			}
		}
		
		
		dispatch_sync(dispatch_get_main_queue(),^() {
			// Main Queue code
			completionHandler(processedString, newSelectionRange);
		});
		
	});
}


@end
