//
//  PathSegment.h
//  AdventureGame

#import <Foundation/Foundation.h>

@class PathSegmentContents;

@interface PathSegment : NSObject

@property (nonatomic, strong) PathSegmentContents *content;
@property (nonatomic, strong) PathSegment *mainRoad;
@property (nonatomic, strong) PathSegment *sideBranch;

- (instancetype)initWithContent:(PathSegmentContents *)content;

@end
