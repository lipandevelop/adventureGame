//
//  GameController.m
//  AdventureGame


#import "GameController.h"
#import "Player.h"
#import "PathSegmentContents.h"


@interface GameController ()

@property (nonatomic, strong) Player *player;
@property (nonatomic, assign) NSInteger segmentsTravelled;

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
        
        PathSegmentContents *randContent = [self randomContent];
        
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


-(PathSegmentContents *)randomContent {
    PathSegmentContents *generatedContent;
    int random = arc4random_uniform(8);
    if (random <4) {
        if (arc4random_uniform(2)==0) {
            generatedContent.treasure = YES;
            
        }
        else {
            generatedContent.creature = YES;
        }
    }
    else if (random >=4) {
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
    NSLog(@"How Far: %ld steps Health: %ld Wealth: %ld Exit: %@", self.segmentsTravelled, self.player.health, self.player.wealth, exitAvailable);
}

-(void)moveUsingMovementDirection: (MovementDirection)movementDirection {
    switch (movementDirection) {
        case MovementDirectionMain:
            if (!self.player.pathSegment.mainRoad)
                return;
            
            if (self.player.pathSegment.mainRoad) {
                int wealthGained = arc4random_uniform(16)+7;
                int healthLost = arc4random_uniform(22)+9;
                self.segmentsTravelled++;
                self.player.pathSegment = self.player.pathSegment.mainRoad;
                if ((self.player.pathSegment.content.treasure = YES)) {
                    self.player.wealth += wealthGained;
                    NSLog(@"You found some gold! Wealth +%d", wealthGained);
                }
                if ((self.player.pathSegment.content.creature = YES)) {
                    self.player.health -=healthLost;
                    NSLog(@"You encountered a monster! Health -%d", healthLost);
                }
                if ((self.player.pathSegment.content.nothing = YES)) {
                    self.player.health +=1;
                    NSLog(@"You have recovered a bit! Health +1");
                }
                break;
                
            case MovementDirectionSide:
                if (!self.player.pathSegment.sideBranch)
                    return;
                
                if (self.player.pathSegment.sideBranch) {
                    int wealthGained = arc4random_uniform(16)+7;
                    int healthLost = arc4random_uniform(22)+9;
                    self.segmentsTravelled++;
                    self.player.pathSegment = self.player.pathSegment.sideBranch;
                    if ((self.player.pathSegment.content.treasure = YES)) {
                        self.player.wealth += wealthGained;
                        NSLog(@"You found some gold! Wealth +%d", wealthGained);
                    }
                    if ((self.player.pathSegment.content.creature = YES)) {
                        self.player.health -=healthLost;
                        NSLog(@"You encountered a monster! Health -%d", healthLost);
                    }
                    if ((self.player.pathSegment.content.nothing = YES)) {
                        self.player.health +=1;
                        NSLog(@"You have recovered a bit! Health +1");
                    }
                }
                
            default:
                break;
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
