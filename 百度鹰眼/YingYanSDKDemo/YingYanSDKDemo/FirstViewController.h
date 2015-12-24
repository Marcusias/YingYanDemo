//
//  FirstViewController.h
//  YingYanSDKDemo
//
//  Copyright © 2015 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduTraceSDK/BaiduTraceSDK-Swift.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface FirstViewController : UIViewController <BMKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *entityNameLabel;
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)startTrace:(UIButton *)sender;

- (IBAction)stopTrace:(UIButton *)sender;

- (IBAction)setFenceEntity:(UIButton *)sender;

- (IBAction)queryFenceStatus:(UIButton *)sender;

- (IBAction)queryHistoryAlarm:(UIButton *)sender;

- (IBAction)setDelayAlarm:(UIButton *)sender;



@end

