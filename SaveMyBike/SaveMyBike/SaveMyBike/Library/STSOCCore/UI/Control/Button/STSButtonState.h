//
//  STSButtonState.h
//
//  Created by Szymon Tomasz Stefanek on 2/8/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSButtonState_h
#define STSButtonState_h

typedef enum _STSButtonState
{
	STSButtonStateNormal,
	STSButtonStateActive,
	STSButtonStatePressed,
	STSButtonStateActivePressed,
	STSButtonStateDisabled,
	
	_STSButtonStateCount
} STSButtonState;

#endif /* STSButtonState_h */
