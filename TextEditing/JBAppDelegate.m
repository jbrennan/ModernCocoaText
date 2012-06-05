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
	[self.textView setFont:[NSFont fontWithName:@"Menlo" size:12.0f]];
}


//- (void)textStorageWillProcessEditing:(NSNotification *)notification {
//	NSTextStorage *textStorage = [notification object];
//	
//	NSString *string = [textStorage string];
//	JBTextEditorProcessor *processor = [JBTextEditorProcessor new];
//	[processor processStringAsynchronously:string withCompletionHandler:^(NSString *processedText) {
//		
//		[textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"]"]];
//		
//	}];
//}


- (void)textStorageDidProcessEditing:(NSNotification *)notification {
	NSTextStorage *textStorage = [notification object];
	NSColor *purple = [NSColor purpleColor];
	NSRange found, area;
	NSString *string = [textStorage string];
	NSUInteger length = [string length];
	
	// remove old colours
	area.location = 0;
	area.length = length;
	[textStorage removeAttribute:NSForegroundColorAttributeName range:area];
	
	// add new colours
	
	while (area.length) {
		found = [string rangeOfString:@"Jason" options:NSCaseInsensitiveSearch range:area];
		if (found.location == NSNotFound)
			break;
		
		[textStorage addAttribute:NSForegroundColorAttributeName value:purple range:found];
		area.location = NSMaxRange(found);
		area.length = length - area.location;
	}
}


- (void)textDidChange:(NSNotification *)notification {
	JBTextEditorProcessor *processor = [JBTextEditorProcessor new];
	NSTextStorage *storage = [self.textView textStorage];
	
	//NSLog(@"%@", NSStringFromRange([storage editedRange]));
	
//	[processor processStringAsynchronously:self.textView.string withCompletionHandler:^(NSString *processedText, NSRange newSelectedRange) {
//		[self.textView setString:processedText];
//	}];
}


- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
	
//	if ([replacementString isEqualToString:@"("]) {
//		[[[textView textStorage] mutableString] appendString:@")"];
//		[textView setSelectedRange:NSMakeRange(affectedCharRange.location, 0)];
//	}
	
	NSString *proposedNewString = [textView string];
	proposedNewString = [proposedNewString stringByReplacingCharactersInRange:affectedCharRange withString:replacementString];
	
	
	JBTextEditorProcessor *processor = [JBTextEditorProcessor new];
	[processor processStringAsynchronously:proposedNewString changedSelectionRange:affectedCharRange replacementString:replacementString completionHandler:^(NSString *processedText, NSRange newSelectedRange) {
		[textView setString:processedText];
		
		
		[textView setSelectedRange:newSelectedRange];
	}];
	
	NSLog(@"%@ : %@", NSStringFromRange(affectedCharRange), replacementString);
	return YES;
}




@end
