//
//  GameController.m
//  AdventureGame


#import "GameController.h"
#import "Player.h"
#import "PathSegmentContents.h"


@interface GameController ()

@property (nonatomic, strong) Player *player;
@property (nonatomic, assign) NSInteger segmentsTravelled;
@property (nonatomic, assign) int segmentsLaid;

@end

@implementation GameController


- (instancetype)init
{
    self = [super init];
    if (self) {
        // generate game path
        _start = [self generatePath];
        
        //generate player
        _player = [[Player alloc] init];
        _player.pathSegment = _start;
    }
    return self;
}

-(PathSegment *)generatePath {
    
    PathSegment *home = [[PathSegment alloc] initWithContent:nil];
    
    PathSegment *mainBranchCursor = home; // primary
    PathSegment *sideBranchCursor = nil;
    
    for (int i = 0; i < 100; i++) {
        
        PathSegmentContents *randContent = [self randomContentForI:i];
        
        if (mainBranchCursor != nil) {
            // append to main branch
            mainBranchCursor.mainRoad = [[PathSegment alloc] initWithContent:randContent];
            mainBranchCursor = mainBranchCursor.mainRoad;
        }
        
        if (sideBranchCursor != nil) {
            // append to side branch
            sideBranchCursor.sideBranch = [[PathSegment alloc] initWithContent:randContent];
            sideBranchCursor = sideBranchCursor.sideBranch;
        }
        
        if (mainBranchCursor && sideBranchCursor) {
            // if we're branched right now, maybe merge.
            if (arc4random_uniform(10) < 3) {
                sideBranchCursor.mainRoad = mainBranchCursor;
                sideBranchCursor = nil;
            }
        } else {
            // if we're not branched right now, maybe split.
            if (arc4random_uniform(10) < 3) {
                sideBranchCursor = mainBranchCursor;
            }
        }
    }
    
    return home;
}


-(PathSegmentContents *)randomContentForI:(int)i {
    PathSegmentContents *generatedContent;
    int random = arc4random_uniform(99);
    if (random <20) {
        if (arc4random_uniform(2)==0) {
            generatedContent.treasure = YES;
            
        }
        else {
            generatedContent.creature = YES;
        }
        
        if (i == 50) {
            generatedContent.merchant = YES;
        }
        int lowerbound = 50;
        int higherbound = 70;
        int rndvalue = lowerbound + arc4random() % (higherbound);
        if (i == rndvalue) {
            generatedContent.crystal = YES;
        }
        
    }
    else {
        generatedContent.nothing = YES;
    }
    
    return generatedContent;
}


-(void)printPath {
    
    PathSegment *mainPath = self.start.mainRoad;
    PathSegment *sidePath = self.start.sideBranch;
    
    while (mainPath.mainRoad != nil) {
        [self printMainPath:mainPath andSide:sidePath];
        
        printf("\n");
        mainPath = mainPath.mainRoad;
        
        if (mainPath.sideBranch) {
            sidePath = mainPath.sideBranch;
        } else if (sidePath) {
            sidePath = sidePath.sideBranch;
        }
    }
}


-(void)printMainPath:(PathSegment *)main andSide:(PathSegment *)side {
    if (!main) return;
    
    if (main.mainRoad && main.sideBranch) {
        printf("|\\");
    } else {
        if (main.mainRoad) {
            printf("|");
        }
        
        if (side) {
            if (side.sideBranch) {
                printf(" |");
            } else {
                printf("/");
            }
        }
    }
}


-(void)printHowFarHealthWealthExit {
    if (!self.player.pathSegment) {
        return;
    }
    NSString *exitAvailable;
    if (self.player.pathSegment.mainRoad || self.player.pathSegment.sideBranch) {
        exitAvailable = @"YES";
    }
    else {
        exitAvailable = @"NO";
    }
    NSLog(@"How Far: %ld steps Health: %ld Wealth: %ld Exit: %@ Hammer Durability: %d", self.segmentsTravelled, self.player.health, self.player.wealth, exitAvailable, self.player.hammerDurability);
}

-(void)moveUsingMovementDirection: (MovementDirection)movementDirection {
    switch (movementDirection) {
        case MovementDirectionMain:
            if (!self.player.pathSegment.mainRoad)
                return;
            
            if (self.player.pathSegment.mainRoad) {
                int wealthGained = arc4random_uniform(16)+7;
                int healthLost = arc4random_uniform(22)+(self.player.healthCoefficient);
                self.segmentsTravelled++;
                self.player.pathSegment = self.player.pathSegment.mainRoad;
                if ((self.player.pathSegment.content.treasure = YES)) {
                    NSString *userCommand = [self inputPrompt:@"You came across a treasure chest! type \"yes\" to open it it your hammer."];
                    if ([userCommand isEqualToString:@"yes"]) {
                        if (self.player.hammerDurability <= 0) {
                            NSLog(@"Your hammer is worn out, you have to just continue");
                        }
                        else {
                            self.player.wealth += wealthGained;
                            self.player.hammerDurability -= 1;
                            NSLog(@"You found some gold! Wealth +%d, your worn out your hammer a bit", wealthGained);
                        }
                    }
                    
                }
                if ((self.player.pathSegment.content.creature = YES)) {
                    NSString *userCommand = [self inputPrompt:@"You've encountered a merchant, you can buy the following:\nType \"V\" for Vitality Potion for 200gold, it gives you 33% of healing 10 health every step you don't encounter anything.\nType \"N\"New Hammer for 500gold\nType \"A\"Armor for 400 gold, it reduces the damage you take from monsters\nType \"q\" to buy nothing"];
                    if ([userCommand isEqualToString:@"v"]) {
                        self.player.vitalityPotion = YES;
                        NSLog(@"You've purchased a Viltality Potion!");
                    }
                    if ([userCommand isEqualToString:@"n"]) {
                        self.player.hammerDurability = 30;
                        NSLog(@"You've purchased a New Hammer!");
                    }
                    if ([userCommand isEqualToString:@"a"]) {
                        self.player.healthCoefficient = 13;
                        NSLog(@"You've purchased a suit of Armor!");
                    }
                    if ((self.player.pathSegment.content.creature = YES)) {
                        NSString *userCommand = [self inputPrompt:@"You came across a monster! Type \"yes\" to fight it with your hammer."];
                        if ([userCommand isEqualToString:@"yes"]) {
                            if (self.player.hammerDurability <= 0) {
                                NSLog(@"Your hammer is worn out, you've lost %d health trying to run from it.", healthLost);
                                self.player.health -=healthLost;
                            }
                            else {
                                self.player.hammerDurability -= 1;
                                NSLog(@"You defeated the monster, you've worn out your hammer a bit");
                            }
                        }
                        
                        else {
                            self.player.health -=healthLost;
                            NSLog(@"You encountered a monster! Health -%d", healthLost);}
                        
                    }
                    if ((self.player.pathSegment.content.nothing = YES)) {
                        if ((self.player.vitalityPotion = YES)) {
                            int r = arc4random_uniform(2);
                            if (r == 0) {
                                self.player.health +=10;
                                NSLog(@"You have recovered a bit! Health +10");
                            }
                            
                        }
                        
                    }
                    break;
                }
                
                
            case MovementDirectionSide:
                if (!self.player.pathSegment.sideBranch)
                    return;
                
                if (self.player.pathSegment.sideBranch) {
                    int wealthGained = arc4random_uniform(16)+7;
                    int healthLost = arc4random_uniform(22)+(self.player.healthCoefficient);
                    self.segmentsTravelled++;
                    self.player.pathSegment = self.player.pathSegment.sideBranch;
                    if ((self.player.pathSegment.content.treasure = YES)) {
                        if ((self.player.pathSegment.content.treasure = YES)) {
                            NSString *userCommand = [self inputPrompt:@"You came across a treasure chest! type \"yes\" to open it it your hammer."];
                            if ([userCommand isEqualToString:@"yes"]) {
                                if (self.player.hammerDurability <= 0) {
                                    NSLog(@"Your hammer is worn out, you have to just continue");
                                }
                                else {
                                    self.player.wealth += wealthGained;
                                    self.player.hammerDurability -= 1;
                                    NSLog(@"You found some gold! Wealth +%d, your worn out your hammer a bit", wealthGained);
                                }
                            }
                            self.player.wealth += wealthGained;
                            NSLog(@"You found some gold! Wealth +%d", wealthGained);
                        }
                        if ((self.player.pathSegment.content.creature = YES)) {
                            NSString *userCommand = [self inputPrompt:@"You came across a monster! Type \"yes\" to fight it with your hammer."];
                            if ([userCommand isEqualToString:@"yes"]) {
                                if (self.player.hammerDurability <= 0) {
                                    NSLog(@"Your hammer is worn out, you've lost %d health trying to run from it.", healthLost);
                                    self.player.health -=healthLost;
                                }
                                else {
                                    self.player.hammerDurability -= 1;
                                    NSLog(@"You defeated the monster, you've worn out your hammer a bit");
                                }
                            }
                            
                            else {
                                self.player.health -=healthLost;
                                NSLog(@"You encountered a monster! Health -%d", healthLost);}
                            
                        }
                        self.player.health -=healthLost;
                        NSLog(@"You encountered a monster! Health -%d", healthLost);
                    }
                    if ((self.player.pathSegment.content.nothing = YES)) {
                        if ((self.player.vitalityPotion = YES)) {
                            int r = arc4random_uniform(2);
                            if (r == 0) {
                                self.player.health +=1;
                                NSLog(@"You have recovered a bit! Health +1");
                            }
                            
                        }
                        
                    default:
                        break;
                    }
                }
            }
    }
}


-(NSString *)inputPrompt: (NSString *)prompt {
    char inputChar[100];
    NSLog(@"%@", prompt);
    fgets(inputChar, 100, stdin);
    NSString *input = [NSString stringWithUTF8String:inputChar];
    input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    input = [input lowercaseString];
    return input;
}

-(BOOL)doesPlayerHaveTwoChoices {
    return (self.player.pathSegment.mainRoad != nil && self.player.pathSegment.sideBranch != nil);
}

-(BOOL)canPlayerProceedToMainroad {
    return (self.player.pathSegment.mainRoad != nil);
}

-(BOOL)canPlayerProceedToSideroad {
    return (self.player.pathSegment.sideBranch != nil);
}

-(BOOL)isPlayerAlive {
    return (self.player.health > 0);
}

-(BOOL)didPlayerWin {
    return (self.player.wealth >= 1000) || (!self.player.pathSegment.mainRoad && !self.player.pathSegment.sideBranch);
}
-(NSString *)getName: (NSString *)playerNameEntered {
    return playerNameEntered;
}


@end
