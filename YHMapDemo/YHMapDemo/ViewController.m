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

#import "ViewController.h"
#import "YHAnimatedCircleView.h"

#define RADIUS 500
#define HK_LATITUDE 22.284681
#define HK_LONGITUDE 114.158177

@interface ViewController ()

@end

@implementation ViewController

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {

    YHAnimatedCircleView* circleView = [[YHAnimatedCircleView alloc] initWithCircle:(MKCircle *)overlay];
    
    return [circleView autorelease];
}

-(void)addCircle{
    
    CLLocationCoordinate2D location;
    location.latitude = HK_LATITUDE;
    location.longitude = HK_LONGITUDE;

    //add annotation
    MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
    anno.coordinate = location;
    [mapView addAnnotation:anno];
    
    //add overlay
    [mapView addOverlay:[MKCircle circleWithCenterCoordinate:location radius:RADIUS]]; 
    
    //zoom into the location with the defined circle at the middle
    [self zoomInto:location distance:(RADIUS * 4.0) animated:YES];
}


#pragma mark - Helper

- (void)zoomInto:(CLLocationCoordinate2D)zoomLocation distance:(CGFloat)distance animated:(BOOL)animated{
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, distance, distance);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self addCircle];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
