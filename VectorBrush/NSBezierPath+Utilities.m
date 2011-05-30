//
//  NSBezierPath+Utilities.m
//  VectorBrush
//
//  Created by Andrew Finnell on 5/28/11.
//  Copyright 2011 Fortunate Bear, LLC. All rights reserved.
//

#import "NSBezierPath+Utilities.h"


@implementation NSBezierPath (FBUtilities)

- (NSPoint) fb_pointAtIndex:(NSUInteger)index
{
    return [self fb_elementAtIndex:index].point;
}

- (NSBezierElement) fb_elementAtIndex:(NSUInteger)index
{
    NSBezierElement element = {};
    NSPoint points[3] = {};
    element.kind = [self elementAtIndex:index associatedPoints:points];
    switch (element.kind) {
        case NSMoveToBezierPathElement:
        case NSLineToBezierPathElement:
        case NSClosePathBezierPathElement:
            element.point = points[0];
            break;
            
        case NSCurveToBezierPathElement:
            element.controlPoints[0] = points[0];
            element.controlPoints[1] = points[1];
            element.point = points[2];
            break;
    }
    return element;
}

- (NSBezierPath *) fb_subpathWithRange:(NSRange)range
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path fb_copyAttributesFrom:self];
    for (NSUInteger i = 0; i < range.length; i++) {
        NSPoint location = [self fb_pointAtIndex:range.location + i];
        if ( i == 0 )
            [path moveToPoint:location];
        else
            [path lineToPoint:location];
    }
    return path;
}

- (void) fb_copyAttributesFrom:(NSBezierPath *)path
{
    [self setLineWidth:[path lineWidth]];
    [self setLineCapStyle:[path lineCapStyle]];
    [self setLineJoinStyle:[path lineJoinStyle]];
    [self setWindingRule:[path windingRule]];
    [self setMiterLimit:[path miterLimit]];
    [self setFlatness:[path flatness]];
}

- (void) fb_appendPath:(NSBezierPath *)path
{
    for (NSUInteger i = 0; i < [path elementCount]; i++) {
        NSPoint location = [path fb_pointAtIndex:i];
        [self lineToPoint:location];
    }
}

@end
