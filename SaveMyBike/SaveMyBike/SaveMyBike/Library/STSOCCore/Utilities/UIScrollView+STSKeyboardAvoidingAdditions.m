//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2015 A Tasty Pixel. All rights reserved.
//

#import "UIScrollView+STSKeyboardAvoidingAdditions.h"
#import "STSKeyboardAvoidingScrollView.h"
#import <objc/runtime.h>

static const CGFloat kCalculatedContentPadding = 10;
static const CGFloat kMinimumScrollOffsetPadding = 20;

static NSString * const kUIKeyboardAnimationDurationUserInfoKey = @"UIKeyboardAnimationDurationUserInfoKey";

static const int kStateKey;

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface STSKeyboardAvoidingState : NSObject
@property (nonatomic, assign) UIEdgeInsets priorInset;
@property (nonatomic, assign) UIEdgeInsets priorScrollIndicatorInsets;
@property (nonatomic, assign) BOOL         keyboardVisible;
@property (nonatomic, assign) CGRect       keyboardRect;
@property (nonatomic, assign) CGSize       priorContentSize;
@property (nonatomic, assign) BOOL         priorPagingEnabled;
@property (nonatomic, assign) BOOL         ignoringNotifications;
@property (nonatomic, assign) BOOL         keyboardAnimationInProgress;
@property (nonatomic, assign) CGFloat      animationDuration;
@end

@implementation UIScrollView (STSKeyboardAvoidingAdditions)

- (STSKeyboardAvoidingState*)keyboardAvoidingState {
    STSKeyboardAvoidingState *state = objc_getAssociatedObject(self, &kStateKey);
    if ( !state ) {
        state = [[STSKeyboardAvoidingState alloc] init];
        objc_setAssociatedObject(self, &kStateKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
        [state release];
#endif
    }
    return state;
}

- (void)STSKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    state.animationDuration = [[info objectForKey:kUIKeyboardAnimationDurationUserInfoKey] doubleValue];

    CGRect keyboardRect = [self convertRect:[[info objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    if ( state.ignoringNotifications ) {
        return;
    }

    state.keyboardRect = keyboardRect;

    if ( !state.keyboardVisible ) {
        state.priorInset = self.contentInset;
        state.priorScrollIndicatorInsets = self.scrollIndicatorInsets;
        state.priorPagingEnabled = self.pagingEnabled;
    }

    state.keyboardVisible = YES;
    self.pagingEnabled = NO;

    if ( [self isKindOfClass:[STSKeyboardAvoidingScrollView class]] ) {
        state.priorContentSize = self.contentSize;

        if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
            // Set the content size, if it's not set. Do not set content size explicitly if auto-layout
            // is being used to manage subviews
            self.contentSize = [self STSKeyboardAvoiding_calculatedContentSizeFromSubviewFrames];
        }
    }
    
    // Delay until a future run loop such that the cursor position is available in a text view
    // In other words, it's not available (specifically, the prior cursor position is returned) when the first keyboard position change notification fires
    // NOTE: Unfortunately, using dispatch_async(main_queue) did not result in a sufficient-enough delay
    // for the text view's current cursor position to be available
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        
        // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationWillStartSelector:@selector(keyboardViewAppear:context:)];
        [UIView setAnimationDidStopSelector:@selector(keyboardViewDisappear:finished:context:)];
        
        [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
        
        UIView *firstResponder = [self STSKeyboardAvoiding_findFirstResponderBeneathView:self];
        if ( firstResponder ) {
            
            self.contentInset = [self STSKeyboardAvoiding_contentInsetForKeyboard];
            
            CGFloat viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
            [self setContentOffset:CGPointMake(self.contentOffset.x,
                                               [self STSKeyboardAvoiding_idealOffsetForView:firstResponder
                                                                     withViewingAreaHeight:viewableHeight])
                          animated:NO];
        }
        
        self.scrollIndicatorInsets = self.contentInset;
        [self layoutIfNeeded];
        
        [UIView commitAnimations];
    });
}

- (void)keyboardViewAppear:(NSString *)animationID context:(void *)context {
    self.keyboardAvoidingState.keyboardAnimationInProgress = true;
}

- (void)keyboardViewDisappear:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished.boolValue) {
        self.keyboardAvoidingState.keyboardAnimationInProgress = false;
    }
}

- (void)STSKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification {
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect) && !self.keyboardAvoidingState.keyboardAnimationInProgress) {
        return;
    }
    
    STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( state.ignoringNotifications ) {
        return;
    }
    
    if ( !state.keyboardVisible ) {
        return;
    }
    
    state.keyboardRect = CGRectZero;
    state.keyboardVisible = NO;
    
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    if ( [self isKindOfClass:[STSKeyboardAvoidingScrollView class]] ) {
        self.contentSize = state.priorContentSize;
    }
    
    self.contentInset = state.priorInset;
    self.scrollIndicatorInsets = state.priorScrollIndicatorInsets;
    self.pagingEnabled = state.priorPagingEnabled;
	[self layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)STSKeyboardAvoiding_updateContentInset {
    STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {
        self.contentInset = [self STSKeyboardAvoiding_contentInsetForKeyboard];
    }
}

- (void)STSKeyboardAvoiding_updateFromContentSizeChange {
    STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {
		state.priorContentSize = self.contentSize;
        self.contentInset = [self STSKeyboardAvoiding_contentInsetForKeyboard];
    }
}

#pragma mark - Utilities

- (BOOL)STSKeyboardAvoiding_focusNextTextField {
    UIView *firstResponder = [self STSKeyboardAvoiding_findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        return NO;
    }
    
    UIView *view = [self STSKeyboardAvoiding_findNextInputViewAfterView:firstResponder beneathView:self];
    
    if ( view ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
            STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
            state.ignoringNotifications = YES;
            [view becomeFirstResponder];
            state.ignoringNotifications = NO;
        });
        return YES;
    }
    
    return NO;
}

-(void)STSKeyboardAvoiding_scrollToActiveTextField {
    STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( !state.keyboardVisible ) return;
    
    UIView *firstResponder = [self STSKeyboardAvoiding_findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        return;
    }
    // Ignore any keyboard notification that occur while we scroll
    //  (seems to be an iOS 9 bug that causes jumping text in UITextField)
    state.ignoringNotifications = YES;
    
    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGPoint idealOffset
        = CGPointMake(self.contentOffset.x,
                      [self STSKeyboardAvoiding_idealOffsetForView:firstResponder
                                            withViewingAreaHeight:visibleSpace]);

    // Ordinarily we'd use -setContentOffset:animated:YES here, but it interferes with UIScrollView
    // behavior which automatically ensures that the first responder is within its bounds
    [UIView animateWithDuration:state.animationDuration animations:^{
        self.contentOffset = idealOffset;
    } completion:^(BOOL finished) {
        state.ignoringNotifications = NO;
    }];
}

#pragma mark - Helpers

- (UIView*)STSKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self STSKeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (UIView*)STSKeyboardAvoiding_findNextInputViewAfterView:(UIView*)priorView beneathView:(UIView*)view {
    UIView * candidate = nil;
    [self STSKeyboardAvoiding_findNextInputViewAfterView:priorView beneathView:view bestCandidate:&candidate];
    return candidate;
}

- (void)STSKeyboardAvoiding_findNextInputViewAfterView:(UIView*)priorView beneathView:(UIView*)view bestCandidate:(UIView**)bestCandidate {
    // Search recursively for input view below/to right of priorTextField
    CGRect priorFrame = [self convertRect:priorView.frame fromView:priorView.superview];
    CGRect candidateFrame = *bestCandidate ? [self convertRect:(*bestCandidate).frame fromView:(*bestCandidate).superview] : CGRectZero;
    CGFloat bestCandidateHeuristic = [self STSKeyboardAvoiding_nextInputViewHeuristicForViewFrame:candidateFrame];
    
    for ( UIView *childView in view.subviews ) {
        if ( [self STSKeyboardAvoiding_viewIsValidKeyViewCandidate:childView] ) {
            CGRect frame = [self convertRect:childView.frame fromView:view];
            
            // Use a heuristic to evaluate candidates
            CGFloat heuristic = [self STSKeyboardAvoiding_nextInputViewHeuristicForViewFrame:frame];
            
            // Find views beneath, or to the right. For those views that match, choose the view closest to the top left
            if ( childView != priorView
                    && ((fabs(CGRectGetMinY(frame) - CGRectGetMinY(priorFrame)) < FLT_EPSILON && CGRectGetMinX(frame) > CGRectGetMinX(priorFrame))
                        || CGRectGetMinY(frame) > CGRectGetMinY(priorFrame))
                    && (!*bestCandidate || heuristic > bestCandidateHeuristic) ) {
                
                *bestCandidate = childView;
                bestCandidateHeuristic = heuristic;
            }
        } else {
            [self STSKeyboardAvoiding_findNextInputViewAfterView:priorView beneathView:childView bestCandidate:bestCandidate];
        }
    }
}

- (CGFloat)STSKeyboardAvoiding_nextInputViewHeuristicForViewFrame:(CGRect)frame {
    return  (-frame.origin.y * 1000.0) // Prefer elements closest to top (most important)
          + (-frame.origin.x);         // Prefer elements closest to left
}

- (BOOL)STSKeyboardAvoiding_viewHiddenOrUserInteractionNotEnabled:(UIView *)view {
    while ( view ) {
        if ( view.hidden || !view.userInteractionEnabled ) {
            return YES;
        }
        view = view.superview;
    }
    return NO;
}

- (BOOL)STSKeyboardAvoiding_viewIsValidKeyViewCandidate:(UIView *)view {
    if ( [self STSKeyboardAvoiding_viewHiddenOrUserInteractionNotEnabled:view] ) return NO;
    
    if ( [view isKindOfClass:[UITextField class]] && ((UITextField*)view).enabled ) {
        return YES;
    }
    
    if ( [view isKindOfClass:[UITextView class]] && ((UITextView*)view).isEditable ) {
        return YES;
    }
    
    return NO;
}

- (void)STSKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view {
    for ( UIView *childView in view.subviews ) {
        if ( ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UITextView class]]) ) {
            [self STSKeyboardAvoiding_initializeView:childView];
        } else {
            [self STSKeyboardAvoiding_assignTextDelegateForViewsBeneathView:childView];
        }
    }
}

-(CGSize)STSKeyboardAvoiding_calculatedContentSizeFromSubviewFrames {
    
    BOOL wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    BOOL wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    CGRect rect = CGRectZero;
    for ( UIView *view in self.subviews ) {
        rect = CGRectUnion(rect, view.frame);
    }
    rect.size.height += kCalculatedContentPadding;
    
    self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator;
    
    return rect.size;
}


- (UIEdgeInsets)STSKeyboardAvoiding_contentInsetForKeyboard {
    STSKeyboardAvoidingState *state = self.keyboardAvoidingState;
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = state.keyboardRect;
    newInset.bottom = keyboardRect.size.height - MAX((CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds)), 0);
    return newInset;
}

-(CGFloat)STSKeyboardAvoiding_idealOffsetForView:(UIView *)view withViewingAreaHeight:(CGFloat)viewAreaHeight {
    CGSize contentSize = self.contentSize;
    __block CGFloat offset = 0.0;

    CGRect subviewRect = [view convertRect:view.bounds toView:self];

    __block CGFloat padding = 0.0;
    __block UIEdgeInsets contentInset;
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        contentInset = self.adjustedContentInset;
    } else {
        contentInset = self.contentInset;
    }
#else
    contentInset = self.contentInset;
#endif

    void(^centerViewInViewableArea)(void)  = ^ {
        // Attempt to center the subview in the visible space
        padding = (viewAreaHeight - subviewRect.size.height) / 2;

        // But if that means there will be less than kMinimumScrollOffsetPadding
        // pixels above the view, then substitute kMinimumScrollOffsetPadding
        if (padding < kMinimumScrollOffsetPadding ) {
            padding = kMinimumScrollOffsetPadding;
        }

        // Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
        // If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
        // things like navigation bars.
        offset = subviewRect.origin.y - padding - contentInset.top;
    };

    // If possible, center the caret in the visible space. Otherwise, center the entire view in the visible space.
    if ([view conformsToProtocol:@protocol(UITextInput)]) {
        UIView <UITextInput> *textInput = (UIView <UITextInput>*)view;
        UITextPosition *caretPosition = [textInput selectedTextRange].start;
        if (caretPosition) {
            CGRect caretRect = [self convertRect:[textInput caretRectForPosition:caretPosition] fromView:textInput];

            // Attempt to center the cursor in the visible space
            // pixels above the view, then substitute kMinimumScrollOffsetPadding
            padding = (viewAreaHeight - caretRect.size.height) / 2;

            // But if that means there will be less than kMinimumScrollOffsetPadding
            // pixels above the view, then substitute kMinimumScrollOffsetPadding
            if (padding < kMinimumScrollOffsetPadding ) {
                padding = kMinimumScrollOffsetPadding;
            }

            // Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
            // If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
            // things like navigation bars.
            offset = caretRect.origin.y - padding - contentInset.top;
        } else {
            centerViewInViewableArea();
        }
    } else {
        centerViewInViewableArea();
    }
    
    // Constrain the new contentOffset so we can't scroll past the bottom. Note that we don't take the bottom
    // inset into account, as this is manipulated to make space for the keyboard.
    CGFloat maxOffset = contentSize.height - viewAreaHeight - contentInset.top;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    // Constrain the new contentOffset so we can't scroll past the top, taking contentInsets into account
    if ( offset < -contentInset.top ) {
        offset = -contentInset.top;
    }

    return offset;
}

- (void)STSKeyboardAvoiding_initializeView:(UIView*)view {
    if ( [view isKindOfClass:[UITextField class]]
            && (((UITextField*)view).returnKeyType == UIReturnKeyDefault || (((UITextField*)view).returnKeyType == UIReturnKeyNext))
            && (![(UITextField*)view delegate] || [(UITextField*)view delegate] == (id<UITextFieldDelegate>)self) ) {
        [(UITextField*)view setDelegate:(id<UITextFieldDelegate>)self];
        UIView *otherView = [self STSKeyboardAvoiding_findNextInputViewAfterView:view beneathView:self];
        
        if ( otherView ) {
            ((UITextField*)view).returnKeyType = UIReturnKeyNext;
        } else {
            ((UITextField*)view).returnKeyType = UIReturnKeyDone;
        }
    }
}

@end


@implementation STSKeyboardAvoidingState
@end
