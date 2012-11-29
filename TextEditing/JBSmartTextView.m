//
//  JBSmartTextView.m
//  TextEditing
//
//  Created by Jason Brennan on 2012-11-29.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBSmartTextView.h"
#import "JBTextEditorProcessor.h"


@interface JBSmartTextView ()
@property (nonatomic, strong) JBTextEditorProcessor *textProcessor;
@end


@implementation JBSmartTextView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self commonInit];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}


- (void)commonInit {
	self.textProcessor = [JBTextEditorProcessor new];
	[self setFont:[NSFont fontWithName:@"Menlo" size:24.0f]];
}


- (void)insertText:(id)insertString {
	NSLog(@"inserting: %@", insertString);
	
	NSRange range = [self selectedRange];
	if (![self shouldChangeTextInRange:NSMakeRange(range.location, range.length) replacementString:@""]) {
		return;
	}

	NSString *input = [self string];
	
	NSString *deletedText = @"";
	if (range.length > 0) {
		deletedText = [[self string] substringWithRange:range];
	}

	[self.textProcessor processString:input
				changedSelectionRange:range
						deletedString:deletedText
					   insertedString:insertString
					completionHandler:^(NSString *processedText, NSRange newSelectedRange) {
						NSLog(@"Processed: %@", processedText);
						
						// This way of replacing the string is kind of overkill but you get the idea.
						// Could definitely be optimized.
						[[self textStorage] replaceCharactersInRange:NSMakeRange(0, [[self string] length]) withString:processedText];
						[self setFont:[NSFont fontWithName:@"Menlo" size:24.0f]];
						[self setSelectedRange:newSelectedRange];
					}];
}


- (void)deleteBackward:(id)sender {
	
	NSRange range = [self selectedRange];
	NSRange backwardRange = range;
	if (!backwardRange.length) {
		backwardRange.location -= 1;
	}
	if (![self shouldChangeTextInRange:backwardRange replacementString:@""]) {
		return;
	}
	
	NSString *input = [self string];
	
	NSString *deletedText = [[self string] substringWithRange:range];
	if (range.length < 1) {
		deletedText = [[self string] substringWithRange:NSMakeRange(range.location - 1, 1)];
		range.length = 1;
		range.location -= 1;
	}
	
	
	[self.textProcessor processString:input
				changedSelectionRange:range
						deletedString:deletedText
					   insertedString:@""
					completionHandler:^(NSString *processedText, NSRange newSelectedRange) {
						
						[[self textStorage] replaceCharactersInRange:NSMakeRange(0, [[self string] length]) withString:processedText];
						[self setFont:[NSFont fontWithName:@"Menlo" size:24.0f]];
						[self setSelectedRange:newSelectedRange];
					}];
}


// TODO: Implement -deleteForward:, too.

@end
