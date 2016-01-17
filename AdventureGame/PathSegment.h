//
//  PathSegment.h
//  AdventureGame

#import <Foundation/Foundation.h>

@class PathSegmentContent;

@interface PathSegment : NSObject

@property (nonatomic, strong) PathSegmentContent *content;
@property (nonatomic, strong) PathSegment *mainRoad;
@property (nonatomic, strong) PathSegment *sideBranch;

- (instancetype)initWithContent:(PathSegmentContent *)content;

@end
