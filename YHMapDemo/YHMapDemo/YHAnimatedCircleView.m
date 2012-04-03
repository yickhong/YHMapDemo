/*
 Copyright 2012 Yick-Hong Lam
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
*/

#import <QuartzCore/QuartzCore.h>
#import "YHAnimatedCircleView.h"

#define MAX_RATIO 1.2
#define MIN_RATIO 0.8
#define STEP_RATIO 0.05

#define ANIMATION_DURATION 0.8

//repeat forever
#define ANIMATION_REPEAT 1e100f 

@implementation YHAnimatedCircleView

-(id)initWithCircle:(MKCircle *)circle{
    
    self = [super initWithCircle:circle];
    
    if(self){
        [self start];
    }   
    
    return self;
}

-(void)dealloc{
    
    [self removeExistingAnimation];
    
    [super dealloc];
}

-(void)start{

    [self removeExistingAnimation];
    
    //create the image
    UIImage* img = [UIImage imageNamed:@"redCircle.png"];
    imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(0, 0, 0, 0);
    [self addSubview:imageView];
    [imageView release];
    
    //opacity animation setup
    CABasicAnimation *opacityAnimation;
    
    opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = ANIMATION_DURATION;
    opacityAnimation.repeatCount = ANIMATION_REPEAT;
    //theAnimation.autoreverses=YES;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.2];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.025];
    
    //resize animation setup
    CABasicAnimation *transformAnimation;
    
    transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    transformAnimation.duration = ANIMATION_DURATION;
    transformAnimation.repeatCount = ANIMATION_REPEAT;
    //transformAnimation.autoreverses=YES;
    transformAnimation.fromValue = [NSNumber numberWithFloat:MIN_RATIO];
    transformAnimation.toValue = [NSNumber numberWithFloat:MAX_RATIO];
    
    
    //group the two animation
    CAAnimationGroup *group = [CAAnimationGroup animation]; 

    group.repeatCount = ANIMATION_REPEAT;
    [group setAnimations:[NSArray arrayWithObjects:opacityAnimation, transformAnimation, nil]];
    group.duration = ANIMATION_DURATION;

    //apply the grouped animaton
    [imageView.layer addAnimation:group forKey:@"groupAnimation"];
}


-(void)stop{
    
    [self removeExistingAnimation];    
}

-(void)removeExistingAnimation{
    
    if(imageView){
        [imageView.layer removeAllAnimations];
        [imageView removeFromSuperview];
        imageView = nil;
    }
}


- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    
    //the circle center
    MKMapPoint mpoint = MKMapPointForCoordinate([[self overlay] coordinate]);
    
    //geting the radius in map point
    double radius = [(MKCircle*)[self overlay] radius];    
    double mapRadius = radius * MKMapPointsPerMeterAtLatitude([[self overlay] coordinate].latitude);
    
    //calculate the rect in map coordination
    MKMapRect mrect = MKMapRectMake(mpoint.x - mapRadius, mpoint.y - mapRadius, mapRadius * 2, mapRadius * 2);
    
    //get the rect in pixel coordination and set to the imageView
    CGRect rect = [self rectForMapRect:mrect];
     
    if(imageView){
        imageView.frame = rect;
    }
}

@end
