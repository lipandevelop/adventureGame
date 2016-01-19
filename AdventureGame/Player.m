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
        _health = 1000;
        _wealth = 200;
        _hammerDurability = 30;
        _vitalityPotion = NO;
        _healthCoefficient = 9;
    }
    return self;
}

@end
