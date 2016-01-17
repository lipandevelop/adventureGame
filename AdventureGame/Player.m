//
//  Player.m
//  AdventureGame
//
//  Created by Li Pan on 2016-01-16.
//  Copyright © 2016 Cory Alder. All rights reserved.
//

#import "Player.h"

@implementation Player

-(instancetype)init {
    self = [super init];
    if (self) {
        _health = 100;
    }
    return self;
}

@end
