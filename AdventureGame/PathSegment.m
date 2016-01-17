//
//  PathSegment.m
//  AdventureGame


#import "PathSegment.h"

@implementation PathSegment

- (instancetype)initWithContent:(PathSegmentContents *)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    return self;
}

@end
