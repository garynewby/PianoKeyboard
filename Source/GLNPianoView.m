//
//  GLNPianoView.h
//  Piano Keyboard View
//
//  Created by Gary Newby on 11/03/2013.
//  Copyright (c) 2013 Gary Newby. All rights reserved.
//

#import "GLNPianoView.h"
#import <QuartzCore/QuartzCore.h>


@interface GLNPianoView ()

@property (nonatomic, strong) UIImage *whiteDoImg;
@property (nonatomic, strong) UIImage *whiteUpImg;
@property (nonatomic, strong) UIImage *blackDoImg;
@property (nonatomic, strong) UIImage *blackUpImg;
@property (nonatomic, assign) CGFloat blackHeight;
@property (nonatomic, assign) CGFloat blackWidth;
@property (nonatomic, assign) CGFloat lastWidth;
@property (nonatomic, assign) CGFloat cradius;
@property (nonatomic, assign) NSInteger numOfWhiteKeys;
@property (nonatomic, strong) NSMutableArray *keyDown;
@property (nonatomic, strong) NSMutableArray *keyRects;
@property (nonatomic, strong) NSMutableArray *sublayers;
@property (nonatomic, strong) NSMutableSet *currentTouches;

@end



@implementation GLNPianoView

- (void)prepareForInterfaceBuilder
{
    if (_totalNumKeys < 12) {
        self.totalNumKeys = 12;
    }
}

- (void) commonInit
{
    for (int i = 0; i < self.sublayers.count; i++) {
        [self.sublayers[i] removeFromSuperlayer];
    }
    
    self.keyDown = [NSMutableArray array];
    self.keyRects = [NSMutableArray array];
    self.sublayers = [NSMutableArray array];
    for (int i = 0; i < self.totalNumKeys; i++) {
        [self.keyDown addObject:[NSNull null]];
        [self.keyRects addObject:[NSValue valueWithCGRect:CGRectZero]];
        [self.sublayers addObject:[NSNull null]];
    }
    
    self.blackHeight = 0.585;
    self.blackWidth = 0.63;
    self.cradius = self.blackWidth * 8.0;
    self.numOfWhiteKeys = 0;
    for (int i = 1; i < self.totalNumKeys; i++) {
        self.keyDown[i] = @NO;
        if ([self isWhiteKey:i]) {
            self.numOfWhiteKeys++;
        }
    }
    
    self.currentTouches = [NSMutableSet set];
    self.multipleTouchEnabled = YES;
    self.layer.masksToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self commonInit];
    
    CGRect rect = self.bounds;
    CGFloat whiteKeyHeight = rect.size.height;
    CGFloat whiteKeyWidth  = [self whiteKeywidth:rect];
    CGFloat blackKeyHeight = rect.size.height * self.blackHeight;
    CGFloat blackKeyWidth  = whiteKeyWidth * self.blackWidth;
    CGFloat blackKeyOffset = blackKeyWidth / 2.0;
    
    self.blackUpImg = [self blackKeyImage:CGSizeMake(blackKeyWidth, blackKeyHeight) keyDown:NO];
    self.blackDoImg = [self blackKeyImage:CGSizeMake(blackKeyWidth, blackKeyHeight) keyDown:YES];
    self.whiteUpImg = [self whiteKeyImage:CGSizeMake(21, 21) keyDown:NO];
    self.whiteDoImg = [self whiteKeyImage:CGSizeMake(21, 21) keyDown:YES];
    
    CGFloat runningX = 0;
    NSInteger yval = 0;
    
    // White Keys
    for (int i = 0; i < self.totalNumKeys; i++) {
        if ([self isWhiteKey:i]) {
            NSInteger newX = (NSInteger)(runningX + 0.5);
            NSInteger newW = (NSInteger)((runningX + whiteKeyWidth + 0.5) - newX);
            CGRect keyRect = CGRectMake(newX, yval, newW, whiteKeyHeight - 1);
            self.sublayers[i] = [self createCALayer:[UIColor whiteColor] rect:keyRect white:YES];
            [self.layer addSublayer:self.sublayers[i]];
            runningX += whiteKeyWidth;
        }
    }
    runningX = 0.0f;
    
    // Black Keys
    for (int i = 0; i < self.totalNumKeys; i++) {
        if ([self isWhiteKey:i]) {
            runningX += whiteKeyWidth;
        } else {
            CGRect keyRect = CGRectMake((runningX - blackKeyOffset), yval, blackKeyWidth, blackKeyHeight);
            self.sublayers[i] = [self createCALayer:[UIColor blackColor] rect:keyRect white:NO];
            [self.layer addSublayer:self.sublayers[i]];
        }
    }
}

- (float)whiteKeywidth:(CGRect)rect
{
    return (rect.size.width / self.numOfWhiteKeys);
}

- (CALayer *)createCALayer:(UIColor*)color rect:(CGRect)rect white:(BOOL)white
{
    rect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - (self.cradius*2.0), CGRectGetWidth(rect), CGRectGetHeight(rect) + (self.cradius*2.0));
    
    CALayer *layer = [CALayer layer];
    CGImageRef blackUp = self.blackUpImg.CGImage;
    CGImageRef whiteUp = self.whiteUpImg.CGImage;
    
    NSUInteger x = 0;
    layer.contentsCenter = CGRectMake(0.5, 0.5, 0.02, 0.02);
    
    if (white) {
        x = 1.0;
        layer.contents = (__bridge id)whiteUp;
    }
    
    layer.frame = CGRectInset(rect, x, 0);
    layer.opaque = YES;
    layer.backgroundColor = color.CGColor;
    layer.cornerRadius = self.cradius;
    
    // Disable implict animations for specified keys
    layer.actions = @{@"onOrderIn":[NSNull null], @"onOrderIn":[NSNull null], @"onOrderOut":[NSNull null],
                      @"self.sublayers":[NSNull null], @"contents":[NSNull null], @"bounds":[NSNull null], @"position":[NSNull null]};
    if (!white) {
        // Black
        layer.contents       = (__bridge id)blackUp;
        layer.masksToBounds  = YES;
    }
    
    return layer;
}

-(void)keyDown:(NSInteger)keyNum
{
    CALayer *layer = ((CALayer *)self.sublayers[keyNum]);
    
    if ([self isWhiteKey:keyNum]) {
        CGImageRef whiteDo = self.whiteDoImg.CGImage;
        layer.contents = (__bridge id)whiteDo;
        layer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    } else {
        CGImageRef blackDo = self.blackDoImg.CGImage;
        layer.contents = (__bridge id)blackDo;
    }
}

-(void)keyUp:(NSInteger)keyNum
{
    CALayer *layer = ((CALayer *)self.sublayers[keyNum]);
    
    if ([self isWhiteKey:keyNum]) {
        CGImageRef whiteUp = self.whiteUpImg.CGImage;
        layer.contents = (__bridge id)whiteUp;
        layer.contentsCenter = CGRectMake(0.5, 0.5, 0.02, 0.02);
    } else {
        CGImageRef blackUp = self.blackUpImg.CGImage;
        layer.contents = (__bridge id)blackUp;
    }
}

- (BOOL)isWhiteKey:(NSInteger)key
{
    NSUInteger k = key %12;
    return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11);
}

-(NSInteger)getKeyboardKey:(CGPoint)point
{
    NSInteger keyNum = NSNotFound;
    for (int i = 0; i < self.totalNumKeys; i++) {
        if (CGRectContainsPoint([self.keyRects[i] CGRectValue], point)) {
            keyNum = i;
            if (![self isWhiteKey:i]) {
                break;
            }
        }
    }
    return keyNum;
}

#pragma mark - Update

-(void)updateKeyRects
{
    if (self.lastWidth == self.bounds.size.width) {
        return;
    }
    self.lastWidth = self.bounds.size.width;
    
   	CGRect rect            = self.frame;
    CGFloat whiteKeyHeight = self.bounds.size.height;
    CGFloat blackKeyHeight = whiteKeyHeight * self.blackHeight ;
    CGFloat whiteKeyWidth  = [self whiteKeywidth:rect];
    CGFloat blackKeyWidth  = whiteKeyWidth * self.blackWidth;
    CGFloat leftKeyBound   = whiteKeyWidth - (blackKeyWidth / 2.0f);
    
    NSInteger lastWhiteKey = 0;
    self.keyRects[0] = [NSValue valueWithCGRect:CGRectMake(0, 0, whiteKeyWidth, whiteKeyHeight)];
    
    for (int i = 1; i < self.totalNumKeys; i++) {
        if (![self isWhiteKey:i]) {
            self.keyRects[i] = [NSValue valueWithCGRect:CGRectMake((lastWhiteKey * whiteKeyWidth) + leftKeyBound, 0, blackKeyWidth, blackKeyHeight)];
        } else {
            lastWhiteKey++;
            self.keyRects[i] = [NSValue valueWithCGRect:CGRectMake(lastWhiteKey * whiteKeyWidth, 0, whiteKeyWidth, whiteKeyHeight)];
        }
    }
}

- (void)updateKeyStates
{
    [self updateKeyRects];
    
    NSArray* touches = [self.currentTouches allObjects];
    NSUInteger count = [touches count];
    NSMutableArray *currentKeyState = [NSMutableArray array];
    
    for (int i = 0; i < self.totalNumKeys; i++) {
        currentKeyState[i] = @NO;
    }
    
    for (int i = 0; i < count; i++) {
        UITouch* touch = [touches objectAtIndex:i];
        CGPoint point = [touch locationInView:self];
        NSInteger index = [self getKeyboardKey:point];
        if (index != NSNotFound) {
            currentKeyState[index] = @YES;
        }
    }
    
    for (int i = 0; i < self.totalNumKeys; i++) {
        if (self.keyDown[i] != currentKeyState[i]) {
            BOOL keyDownState = [currentKeyState[i] boolValue];
            self.keyDown[i] = @(keyDownState);
            if (keyDownState) {
                [self.delegate pianoKeyDown:i];
                [self keyDown:i];
            } else {
                [self.delegate pianoKeyUp:i];
                [self keyUp:i];
            }
        }
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Touch Handling Code

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        [self.currentTouches addObject:touch];
    }
    [self updateKeyStates];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateKeyStates];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        [self.currentTouches removeObject:touch];
    }
    [self updateKeyStates];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        [self.currentTouches removeObject:touch];
    }
    [self updateKeyStates];
}

#pragma mark - Image generation

- (UIImage *)blackKeyImage:(CGSize)size keyDown:(BOOL)keyDown
{
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width *= scale;
    size.height *= scale;
    UIGraphicsBeginImageContext(size);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* fillColor = [UIColor colorWithRed: 0.379 green: 0.379 blue: 0.379 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.951];
    
    NSArray* gradient1Colors = [NSArray arrayWithObjects: (id)strokeColor.CGColor, (id)fillColor.CGColor, nil];
    CGFloat gradient1Locations[] = {0.11, 1};
    CGGradientRef gradient1 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient1Colors, gradient1Locations);
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, size.height)];
    [strokeColor setFill];
    [rectanglePath fill];
    
    CGFloat border = size.width*0.15;
    CGFloat width = size.width*0.7;
    CGFloat topRectHeight = size.height*0.86;
    CGFloat bottomRectOffset = size.height*0.875;
    CGFloat bottomRectHeight = size.height*0.125;
    if (keyDown) {
        topRectHeight = size.height*0.91;
        bottomRectOffset = size.height*0.925;
    }
    
    CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(frame) +  border, CGRectGetMinY(frame), width, topRectHeight);
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: self.cradius];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient1, CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)), 0);
    CGContextRestoreGState(context);
    
    CGRect roundedRectangle2Rect = CGRectMake(CGRectGetMinX(frame) +  border, CGRectGetMinY(frame) + bottomRectOffset, width, bottomRectHeight);
    UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: roundedRectangle2Rect cornerRadius: self.cradius];
    CGContextSaveGState(context);
    [roundedRectangle2Path addClip];
    CGContextDrawLinearGradient(context, gradient1, CGPointMake(CGRectGetMidX(roundedRectangle2Rect), CGRectGetMaxY(roundedRectangle2Rect)),
                                CGPointMake(CGRectGetMidX(roundedRectangle2Rect), CGRectGetMinY(roundedRectangle2Rect)), 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient1);
    CGColorSpaceRelease(colorSpace);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

- (UIImage *)whiteKeyImage:(CGSize)size keyDown:(BOOL)keyDown
{
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width *= scale;
    size.height *= scale;
    UIGraphicsBeginImageContext(size);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* fillColor = [UIColor colorWithRed: 0.1 green: 0.1 blue: 0.1 alpha: 0.20];
    UIColor* strokeColor = [UIColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 0.0];
    if (keyDown) {
        fillColor = [UIColor colorWithRed: 0.1 green: 0.1 blue: 0.1 alpha: 0.50];
        strokeColor = [UIColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 0.0];
    }
    
    NSArray* gradient1Colors = [NSArray arrayWithObjects: (id)strokeColor.CGColor, (id)fillColor.CGColor, nil];
    CGFloat gradient1Locations[] = {0.1, 1};
    CGGradientRef gradient1 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient1Colors, gradient1Locations);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, size.width, size.height)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawRadialGradient(context, gradient1, CGPointMake(size.width/2.0, size.height/2.0), size.height*0.01,
                                CGPointMake(size.width/2.0, size.height/2.0), size.height*0.6,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient1);
    CGColorSpaceRelease(colorSpace);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end






