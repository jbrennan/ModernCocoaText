//
//  JBTextEditorProcessor.h
//  TextEditing
//
//  Created by Jason Brennan on 12-06-04.
//  Copyright (c) 2012 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JBTextEditorProcessorCompletionHandler)(NSString *processedText, NSRange newSelectedRange);

@interface JBTextEditorProcessor : NSObject

- (void)processStringAsynchronously:(NSString *)string changedSelectionRange:(NSRange)selectionRange replacementString:(NSString *)replacementString completionHandler:(JBTextEditorProcessorCompletionHandler)completionHandler; // completionHandler is executed on the main queue.
//- (void)processStringAsynchronously:(NSString *)fullString 
@end
