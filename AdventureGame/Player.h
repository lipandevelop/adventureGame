//
//  Player.h
//  AdventureGame
//
//  Created by Li Pan on 2016-01-16.
//  Copyright © 2016 Cory Alder. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PathSegment;

@interface Player : NSObject
@property (nonatomic, strong) PathSegment *pathSegment;
@property (nonatomic, assign) NSInteger health;
@property (nonatomic, assign) NSInteger wealth;




@end
