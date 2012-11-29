#Modern Text

This repo includes some helper classes for making smarter text systems, specifically helping the user type certain commonly paired characters. The code tries to be as smart as possible by inserting only when it's really desired, and making it possible for the user to correct any undesired behaviour.

##Installation

These instructions work equally well for iOS or OS X, with any of the text classes. The examples given will be for `NSTextView` but if you use your brain you should be able to figure out how to translate to iOS quite easily too.

###The quick and dirty way

The quickest way to use this class is to implement the following delegate method for `NSTextView`. **Warning** this breaks undo support if you use this method. There's probably a way around that but I haven't looked into it enough. This method also works just as well with `NSTextField` if you use its appropriate delegate method.

	- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
	
	
		if (nil == replacementString) // This means only the strings attributes were changing, so we don't really care about replacements.
			return YES;
	
	
		NSString *originalString = [textView string];
	
		NSString *deletedString = @"";
		if (affectedCharRange.length > 0) {
			deletedString = [originalString substringWithRange:affectedCharRange];
		}
		
		// Or, create an instance property for `processor`. Shown here for simplicity.
		JBTextEditorProcessor *processor = [JBTextEditorProcessor new];
		[processor processString:originalString changedSelectionRange:affectedCharRange deletedString:deletedString insertedString:replacementString completionHandler:^(NSString *processedText, NSRange newSelectedRange) {
			[textView setString:processedText];
			[textView setSelectedRange:newSelectedRange];
		}];
	
		return NO;
	}

###The Better, cleaner way

The alternative is of course to use an `NSTextView` subclass and manipulate the text storage directly. This maintains the undo stack.

##Automatic Parenthesis Insertion and Matching

When any kind of parenthesis style character is inserted (that is, `(`, `[`, and `{` (and optionally `<`)), they should have their closing counterparts inserted automatically, with the cursor placed between them. This is to assist the user in typing, and as such some special considerations have to be followed.

1. Inserting an opening brace automatically inserts its counterpart. This happens if and only if the character after the opening brace is either whitespace or nonexistant (i.e., end of line or end of file). Examples

		This is a sentence (	# automatically inserts ) here because it is at the end of a line
	
		This is a (big sentence	# does not insert a matching ) because it comes directly before "big"
	
		This is a ( sentence	# automatically inserts ) because there is a space after it

2. If the pair is empty (like `()`) and the opening brace is deleted, the pair is deleted. If the pair is not empty, then only the opening brace is deleted.

3. If the closing brace is deleted, this behaves like it normally would without the assist (that is, the closing character is the only thing deleted).

4. Pasting does not invoke any of these behaviour.

5. If the cursor is placed in front of a closing brace and that closing brace is typed, the cursor should just move to the other side of the brace and have it remain in place. That is, don't insert another character, just move the cursor along. If the user really wanted to have two of the same characters, they'll just type it again.

##Block Editing

When a block of text is selected and the user types a character, the block of text is typically replaced by whatever has just been typed or pasted in. This is not always what the user has intended. Instead, in some circumstances the selected text should instead be surrounded by the characters and have the selection extended. Examples:

    text	# this is our selected text when the ( key is pressed.
    (text)	# this is the result
    

##Subtler rules

Inserting a pair should be a little smarter about how it works. If the cursor is in whitespace or end of a line then it should insert the pair. Otherwise, it has to be a little smarter:

1. If the next character is a non-pair character, insert *only* the opening character
2. If the existing characters around the insertion point are a pair, insert a new pair. (ex: insertion point in between `()`, then insert a new pair -> `(())`).
3. If the next character is **any other** closing pair character, insert the pair.
4. Else, insert the opening character only.