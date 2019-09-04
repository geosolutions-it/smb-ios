//
//  STSPair.h
//
//  Created by Szymon Tomasz Stefanek on 22/08/2019.
//  Copyright © 2019 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSPair<__covariant TypeA,__covariant TypeB> : NSObject

@property(nonatomic,retain) TypeA a;
@property(nonatomic,retain) TypeB b;

@end
