//
//  GameController.h
//  AdventureGame


#import <Foundation/Foundation.h>
#import "PathSegment.h"
#import "PathSegmentContent.h"

typedef NS_ENUM(NSInteger, MovementDirection) {
    MovementDirectionMain,
    MovementDirectionSide
};

@interface GameController : NSObject

@property (nonatomic, strong) PathSegment *start;

-(void)printHowFarHealthWealthExit;

-(void)printPath;

-(NSString *)inputPrompt: (NSString *)prompt;

-(void)moveUsingMovementDirection: (MovementDirection)movementDirection;

-(BOOL)doesPlayerHaveTwoChoices;

-(BOOL)canPlayerProceedToMainroad;

-(BOOL)canPlayerProceedToSideroad;

-(BOOL)isPlayerAlive;

-(BOOL)didPlayerWin;

@end
