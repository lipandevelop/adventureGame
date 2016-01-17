//
//  main.m
//  AdventureGame

#import <Foundation/Foundation.h>
#import "GameController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        GameController *game = [[GameController alloc] init];
        NSString *playerName = [game inputPrompt:@"You are about to embark on a journey of greed, what should I call you? \nName:"];
//        [game getName:playerName];
        
        
        [game printPath];
        
        while (true) {
            
            [game printHowFarHealthWealthExit];
            if ([game didPlayerWin]) {
                NSLog(@"You WON!!!");
                break;
            }
            if (![game isPlayerAlive]) {
                NSLog(@"You DIED!!!");
                break;
            }
            
            
            if ([game doesPlayerHaveTwoChoices] ) {
                
                NSString *userCommand = [game inputPrompt:@"Where would you like to go?\n//Main//Side//Quit\n>"];
                
                if ([userCommand isEqualToString:@"main"]) {
                    [game moveUsingMovementDirection:MovementDirectionMain];
                }
                else if ([userCommand isEqualToString:@"side"]) {
                    [game moveUsingMovementDirection:MovementDirectionSide];
                }
                else if ([userCommand isEqualToString:@"quit"]) {
                    NSLog(@"You Quit!");
                    break;
                }
                else {
                    NSLog(@"Do not compute");
                }
            } else {
                if ([game canPlayerProceedToMainroad]) {
                    [game moveUsingMovementDirection:MovementDirectionMain];
                } else if ([game canPlayerProceedToSideroad]) {
                    [game moveUsingMovementDirection:MovementDirectionSide];
                } else {
                    NSLog(@"Game over");
                    break;
                }
            }
        }
        return 0;
    }
}
