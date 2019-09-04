//
//  STSDelegateList.h
//
//  Created by Szymon Tomasz Stefanek on 02/12/12.
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSDelegateArray : NSObject
{
	@private
		NSMutableArray * m_pArray;
}

- (id)init;

- (int)count;
- (void)removeAllDelegates;
- (void)addDelegate:(id)pObject;
- (void)removeDelegate:(id)pObject;
- (bool)containsDelegate:(id)pObject;

/**
 * Trigger a selector on all the objects.
 * Handles the case of delegates that remove themselves from the list
 * from the inside of the notification callback.
 */
- (void)performSelectorOnAllDelegates:(SEL)oSelector;

/**
 * Trigger a selector on all the objects.
 * Handles the case of delegates that remove themselves from the list
 * from the inside of the notification callback.
 */
- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject;

/**
 * Trigger a selector on all the objects.
 * Handles the case of delegates that remove themselves from the list
 * from the inside of the notification callback.
 */
- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2;

/**
 * Trigger a selector on all the objects.
 * Handles the case of delegates that remove themselves from the list
 * from the inside of the notification callback.
 */
- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3;

/**
 * Trigger a selector on all the objects.
 * Handles the case of delegates that remove themselves from the list
 * from the inside of the notification callback.
 */
- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4;

/**
 * Trigger a selector on all the objects.
 * Handles the case of delegates that remove themselves from the list
 * from the inside of the notification callback.
 */
- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4 withObject:(id)pObject5;


@end
