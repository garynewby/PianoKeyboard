//
//  GLNPianoView.h
//  Piano Keyboard View
//
//  Created by Gary Newby on 11/03/2013.
//  Copyright (c) 2013 Gary Newby. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLNPianoViewDelegate <NSObject>
-(void)pianoKeyUp:(NSUInteger)keyNumber;
-(void)pianoKeyDown:(NSUInteger)keyNumber;
@end

IB_DESIGNABLE

@interface GLNPianoView : UIView
@property(nonatomic, assign) id<GLNPianoViewDelegate> delegate;
@property (nonatomic, assign) IBInspectable NSInteger totalNumKeys;
@end


