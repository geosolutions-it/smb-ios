//
//  STSDelegateList.m
//
//  Created by Szymon Tomasz Stefanek on 02/12/12.
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//
//

#import "STSDelegateArray.h"

#import "STSCore.h"

// We wrap the object in a value that stores a weak pointer: so we don't get retain cycles...
@interface STSDelegateArrayElement : NSObject
{
@public
	__unsafe_unretained id pObject;
}

@end

@implementation STSDelegateArrayElement

@end

@interface STSDelegateArray()
- (void)_performSelector:(SEL)oSelector onObject:(id)oObject withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3;
- (void)_performSelector:(SEL)oSelector onObject:(id)oObject withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4;
- (void)_performSelector:(SEL)oSelector onObject:(id)oObject withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4 withObject:(id)pObject5;
@end

@implementation STSDelegateArray

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	m_pArray = nil;
	return self;
}

- (int)count
{
	if(!m_pArray)
		return 0;
	return (int)[m_pArray count];
}

- (void)removeAllDelegates
{
	if(!m_pArray)
		return;
	[m_pArray removeAllObjects];
	m_pArray = nil;
}

- (bool)containsDelegate:(id)pObject
{
	if(!m_pArray)
		return false;

	for(STSDelegateArrayElement * pElement in m_pArray)
	{
		if(pElement->pObject == pObject)
			return true;
	}

	return false;
}

- (void)addDelegate:(id)pObject
{
	if(!m_pArray)
	{
		m_pArray = [NSMutableArray array];
		STSDelegateArrayElement * pElement = [STSDelegateArrayElement new];
		pElement->pObject = pObject;
		[m_pArray addObject:pElement];
		return;
	}
	
	if([self containsDelegate:pObject])
		return;

	STSDelegateArrayElement * pElement = [STSDelegateArrayElement new];
	pElement->pObject = pObject;
	[m_pArray addObject:pElement];
}

- (void)removeDelegate:(id)pObject
{
	if(!m_pArray)
		return;
	
	// FIXME: Also purge the nil objects?
	
	for(STSDelegateArrayElement * pElement in m_pArray)
	{
		if(pElement->pObject == pObject)
		{
			pElement->pObject = nil;
			[m_pArray removeObject:pElement];
			break;
		}
	}
	
	if([m_pArray count] == 0)
		m_pArray = nil;
}

- (void)performSelectorOnAllDelegates:(SEL)oSelector
{
	if(!m_pArray)
		return;
	
	STSDelegateArrayElement * d;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	switch([m_pArray count])
	{
		case 0:
			// nothing
		break;
		case 1:
			d = [m_pArray objectAtIndex:0];
			if(d->pObject)
			{
				if([d->pObject respondsToSelector:oSelector])
					[d->pObject performSelector:oSelector];
			}
		break;
		default:
		{
			// copy first
			NSArray * a = [NSArray arrayWithArray:m_pArray];
			bool bCalledOnce = false;
			
			for(d in a)
			{
				if(bCalledOnce)
				{
					// at least one call has been made: the array may have been modified
					if(![m_pArray containsObject:d])
						continue;
				}
			
				if(!d->pObject)
					continue;

				if(![d->pObject respondsToSelector:oSelector])
					continue;

				[d->pObject performSelector:oSelector];

				bCalledOnce = true;
			}
		}
		break;
	}
	
#pragma clang diagnostic pop
}


- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject;
{
	if(!m_pArray)
		return;
	
	STSDelegateArrayElement * d;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	switch([m_pArray count])
	{
		case 0:
			// nothing
		break;
		case 1:
			d = [m_pArray objectAtIndex:0];
			if(d->pObject)
			{
				if([d->pObject respondsToSelector:oSelector])
					[d->pObject performSelector:oSelector withObject:pObject];
			}
		break;
		default:
		{
			// copy first
			NSArray * a = [NSArray arrayWithArray:m_pArray];
			bool bCalledOnce = false;
			
			for(d in a)
			{
				if(bCalledOnce)
				{
					// at least one call has been made: the array may have been modified
					if(![m_pArray containsObject:d])
						continue;
				}
			
				if(!d->pObject)
					continue;

				if(![d->pObject respondsToSelector:oSelector])
					continue;

				[d->pObject performSelector:oSelector withObject:pObject];

				bCalledOnce = true;
			}
		}
		break;
	}
	
#pragma clang diagnostic pop
}

- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2
{
	if(!m_pArray)
		return;
	
	STSDelegateArrayElement * d;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	switch([m_pArray count])
	{
		case 0:
			// nothing
		break;
		case 1:
			d = [m_pArray objectAtIndex:0];
			if(d->pObject)
			{
				if([d->pObject respondsToSelector:oSelector])
					[d->pObject performSelector:oSelector withObject:pObject1 withObject:pObject2];
			}
		break;
		default:
		{
			// copy first
			NSArray * a = [NSArray arrayWithArray:m_pArray];
			bool bCalledOnce = false;
			
			for(d in a)
			{
				if(bCalledOnce)
				{
					// at least one call has been made: the array may have been modified
					if(![m_pArray containsObject:d])
						continue;
				}
			
				if(!d->pObject)
					continue;

				if(![d->pObject respondsToSelector:oSelector])
					continue;

				[d->pObject performSelector:oSelector withObject:pObject1 withObject:pObject2];

				bCalledOnce = true;
			}
		}
		break;
	}
	
#pragma clang diagnostic pop
}


- (void)_performSelector:(SEL)oSelector onObject:(id)oObject withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3
{
	NSMethodSignature * pSig = [oObject methodSignatureForSelector:oSelector];
	if(!pSig)
	{
		STS_CORE_LOG_ERROR(@"Bad selector passed to STSDelegateArray");
		return;
	}
	
	NSInvocation * pInvocation = [NSInvocation invocationWithMethodSignature:pSig];
	[pInvocation setTarget:oObject];
	[pInvocation setSelector:oSelector];
	[pInvocation setArgument:&pObject1 atIndex:2];
	[pInvocation setArgument:&pObject2 atIndex:3];
	[pInvocation setArgument:&pObject3 atIndex:4];
	[pInvocation invoke];
}

- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3
{
	if(!m_pArray)
		return;
	
	STSDelegateArrayElement * d;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	switch([m_pArray count])
	{
		case 0:
			// nothing
		break;
		case 1:
			d = [m_pArray objectAtIndex:0];
			if(d->pObject)
			{
				if([d->pObject respondsToSelector:oSelector])
					[self _performSelector:oSelector onObject:d->pObject withObject:pObject1 withObject:pObject2 withObject:pObject3];
			}
		break;
		default:
		{
			// copy first
			NSArray * a = [NSArray arrayWithArray:m_pArray];
			bool bCalledOnce = false;
			
			for(d in a)
			{
				if(bCalledOnce)
				{
					// at least one call has been made: the array may have been modified
					if(![m_pArray containsObject:d])
						continue;
				}
			
				if(!d->pObject)
					continue;

				if(![d->pObject respondsToSelector:oSelector])
					continue;

				[self _performSelector:oSelector onObject:d->pObject withObject:pObject1 withObject:pObject2 withObject:pObject3];

				bCalledOnce = true;
			}
		}
		break;
	}
	
#pragma clang diagnostic pop
}



- (void)_performSelector:(SEL)oSelector onObject:(id)oObject withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4
{
	NSMethodSignature * pSig = [oObject methodSignatureForSelector:oSelector];
	if(!pSig)
	{
		STS_CORE_LOG_ERROR(@"Bad selector passed to STSDelegateArray");
		return;
	}
	
	NSInvocation * pInvocation = [NSInvocation invocationWithMethodSignature:pSig];
	[pInvocation setTarget:oObject];
	[pInvocation setSelector:oSelector];
	[pInvocation setArgument:&pObject1 atIndex:2];
	[pInvocation setArgument:&pObject2 atIndex:3];
	[pInvocation setArgument:&pObject3 atIndex:4];
	[pInvocation setArgument:&pObject4 atIndex:5];
	[pInvocation invoke];
}

- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4
{
	if(!m_pArray)
		return;
	
	STSDelegateArrayElement * d;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	switch([m_pArray count])
	{
		case 0:
			// nothing
		break;
		case 1:
			d = [m_pArray objectAtIndex:0];
			if(d->pObject)
			{
				if([d->pObject respondsToSelector:oSelector])
					[self _performSelector:oSelector onObject:d->pObject withObject:pObject1 withObject:pObject2 withObject:pObject3 withObject:pObject4];
			}
		break;
		default:
		{
			// copy first
			NSArray * a = [NSArray arrayWithArray:m_pArray];
			bool bCalledOnce = false;
			
			for(d in a)
			{
				if(bCalledOnce)
				{
					// at least one call has been made: the array may have been modified
					if(![m_pArray containsObject:d])
						continue;
				}
			
				if(!d->pObject)
					continue;

				if(![d->pObject respondsToSelector:oSelector])
					continue;

				[self _performSelector:oSelector onObject:d->pObject withObject:pObject1 withObject:pObject2 withObject:pObject3 withObject:pObject4];

				bCalledOnce = true;
			}
		}
		break;
	}
	
#pragma clang diagnostic pop
}

- (void)_performSelector:(SEL)oSelector onObject:(id)oObject withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4 withObject:(id)pObject5
{
	NSMethodSignature * pSig = [oObject methodSignatureForSelector:oSelector];
	if(!pSig)
	{
		STS_CORE_LOG_ERROR(@"Bad selector passed to STSDelegateArray");
		return;
	}
	
	NSInvocation * pInvocation = [NSInvocation invocationWithMethodSignature:pSig];
	[pInvocation setTarget:oObject];
	[pInvocation setSelector:oSelector];
	[pInvocation setArgument:&pObject1 atIndex:2];
	[pInvocation setArgument:&pObject2 atIndex:3];
	[pInvocation setArgument:&pObject3 atIndex:4];
	[pInvocation setArgument:&pObject4 atIndex:5];
	[pInvocation setArgument:&pObject5 atIndex:6];
	[pInvocation invoke];
}

- (void)performSelectorOnAllDelegates:(SEL)oSelector withObject:(id)pObject1 withObject:(id)pObject2 withObject:(id)pObject3 withObject:(id)pObject4 withObject:(id)pObject5
{
	if(!m_pArray)
		return;
	
	STSDelegateArrayElement * d;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	switch([m_pArray count])
	{
		case 0:
			// nothing
		break;
		case 1:
			d = [m_pArray objectAtIndex:0];
			if(d->pObject)
			{
				if([d->pObject respondsToSelector:oSelector])
					[self _performSelector:oSelector onObject:d->pObject withObject:pObject1 withObject:pObject2 withObject:pObject3 withObject:pObject4 withObject:pObject5];
			}
		break;
		default:
		{
			// copy first
			NSArray * a = [NSArray arrayWithArray:m_pArray];
			bool bCalledOnce = false;
			
			for(d in a)
			{
				if(bCalledOnce)
				{
					// at least one call has been made: the array may have been modified
					if(![m_pArray containsObject:d])
						continue;
				}
			
				if(!d->pObject)
					continue;

				if(![d->pObject respondsToSelector:oSelector])
					continue;

				[self _performSelector:oSelector onObject:d->pObject withObject:pObject1 withObject:pObject2 withObject:pObject3 withObject:pObject4 withObject:pObject5];

				bCalledOnce = true;
			}
		}
		break;
	}
	
#pragma clang diagnostic pop
}


@end
