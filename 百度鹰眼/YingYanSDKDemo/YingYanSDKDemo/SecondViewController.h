//
//  SecondViewController.h
//  YingYanSDKDemo
//
//  Copyright © 2015 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduTraceSDK/BaiduTraceSDK-Swift.h>
#import "JSONKit.h"
#import <MapKit/MapKit.h>
#import <stdlib.h>
#import "FirstViewController.h"

@interface SecondViewController : UIViewController
@property (strong, nonatomic) IBOutlet BMKMapView *historyMapView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;

- (IBAction)triggerDatePicker:(UIButton *)sender;

- (IBAction)onClickQueryHistoryTrackButton:(UIButton *)sender;



@end

