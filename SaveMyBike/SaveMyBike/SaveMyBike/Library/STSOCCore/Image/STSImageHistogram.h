//
//  STSImageHistogram.h
//
//  Created by Szymon Tomasz Stefanek on 3/22/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSImageHistogram : NSObject
{
@private
	unsigned int m_uChannels;
	unsigned int * m_pBuffer; // m_uChannels * 256 * 4 bytes.
}

- (id)initWithChannels:(unsigned int)uChannels;

- (void)dealloc;

- (void)clear;

@property (nonatomic, readonly) unsigned int channels;

- (unsigned int *)dataForChannel:(unsigned int)uChannelIndex;

- (void)transformToCumulativeDistribution;
- (void)transformToCumulativeDistributionAndNormalizeToMaximum:(unsigned int)uMaximum;

@end
