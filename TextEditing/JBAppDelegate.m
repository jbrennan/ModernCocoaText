//
//  JBAppDelegate.m
//  TextEditing
//
//  Created by Jason Brennan on 12-06-04.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBTextEditorProcessor.h"


@interface JBAppDelegate () <NSTextStorageDelegate, NSTextViewDelegate>
@end

@implementation JBAppDelegate

@synthesize window = _window;
@synthesize textView = _textView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}


- (void)awakeFromNib {
	[super awakeFromNib];
	
	
	[[self textView] setDelegate:self];
	[[self.textView textStorage] setDelegate:self];
	[self.textView setFont:[NSFont fontWithName:@"Menlo" size:24.0f]];
}


// If using the text processor this way, note IT BREAKS UNDO because it returns NO, so the undo system thinks the text hasn't changed.
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
	
	
	if (nil == replacementString) // This means only the strings attributes were changing, so we don't really care about replacements.
		return YES;
	
	
	NSString *originalString = [textView string];
	
	NSString *deletedString = @"";
	if (affectedCharRange.length > 0) {
		deletedString = [originalString substringWithRange:affectedCharRange];
	}
	
	JBTextEditorProcessor *processor = [JBTextEditorProcessor new];
	[processor processString:originalString changedSelectionRange:affectedCharRange deletedString:deletedString insertedString:replacementString completionHandler:^(NSString *processedText, NSRange newSelectedRange) {
		[textView setString:processedText];
		
		
		[textView setSelectedRange:newSelectedRange];
	}];
	
	
	return NO;
}


@end
