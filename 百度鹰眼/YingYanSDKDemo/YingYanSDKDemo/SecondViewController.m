//
//  SecondViewController.m
//  YingYanSDKDemo
//
//  Copyright © 2015 Baidu. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<ApplicationTrackDelegate, BMKMapViewDelegate>

@end

@implementation SecondViewController

dispatch_queue_t global_queue_view2;

NSString *startTime;
NSString *endTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    global_queue_view2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)dealloc
{
    if (_historyMapView)
    {
        _historyMapView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"history appear");
    
    [_historyMapView viewWillAppear];
    _historyMapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
    _historyMapView.hidden = false;
    _datePicker.hidden = true;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"history disappear");
    [_historyMapView viewWillDisappear];
    _historyMapView.delegate = nil; // 不用时，置nil
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    NSString *timeInterval = [NSString stringWithFormat:@"%f", sender.date.timeIntervalSince1970];
    startTime = [[timeInterval componentsSeparatedByString:@"."] objectAtIndex:0];
    endTime = [NSString stringWithFormat:@"%lld", ([startTime longLongValue] + 24 * 3600 - 1)];
    
   
    
}

- (IBAction)triggerDatePicker:(UIDatePicker *)sender
{
    _datePicker.hidden = false;
    _historyMapView.hidden = true;

}

- (IBAction)onClickQueryHistoryTrackButton:(UIButton *)sender
{
    _datePicker.hidden = true;
    
    dispatch_async(global_queue_view2, ^{
        extern int serviceId;
        [[BTRACEAction shared] getTrackHistory:self serviceId:serviceId entityName:@"39D3873F-0775-4E24-92B5-C5DD0A82B6F3"  startTime:[startTime intValue] endTime:[endTime intValue] simpleReturn:1 isProcessed:1 pageSize:5000 pageIndex:1];
    });
        _historyMapView.hidden = false;
}

/// 历史轨迹查询回调方法
- (void) onGetHistoryTrack:(NSData *)data
{
    
    NSString *trackHistoryResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"*******+++++++++++++++%@",trackHistoryResult);
    
    NSDictionary *dic = [trackHistoryResult objectFromJSONString];
    
    NSNumber *status = [dic objectForKey:@"status"];
    NSLog(@"   ----====== %@",status);
    
    NSString *message = [dic objectForKey:@"message"];
    NSLog(@"mmmmmmmmmmmm %@",message);
    
    NSLog(@"%@", message);
    if (0 == [status longValue])
    {
        NSArray *pois = [dic objectForKey:@"points"];
        //去除经纬度为(0,0)的点 将剩余的坐标点存储在poisWithoutZero中
        NSMutableArray *poisWithoutZero = [[NSMutableArray alloc] init]; ;
        for (int i = 0; i < [pois count]; i++)
        {
            NSArray *point = [pois objectAtIndex:i];
            NSNumber *longitude = [point objectAtIndex:0];
            NSNumber *latitude = [point objectAtIndex:1];
            extern double const EPSILON;
            if (fabs(longitude.doubleValue - 0) < EPSILON && fabs(latitude.doubleValue - 0) < EPSILON)
            {
                continue;
            }
            [poisWithoutZero addObject:point];
        }
        
        CLLocationCoordinate2D *locations = malloc([poisWithoutZero count] * sizeof(CLLocationCoordinate2D));
        CLLocationDegrees minLat = 90.0;
        CLLocationDegrees maxLat = -90.0;
        CLLocationDegrees minLon = 180.0;
        CLLocationDegrees maxLon = -180.0;
        for (int i = 0; i < [poisWithoutZero count]; i++)
        {
            NSArray *point = [poisWithoutZero objectAtIndex:i];
            NSNumber *longitude = [point objectAtIndex:0];
            NSNumber *latitude = [point objectAtIndex:1];
            minLat = MIN(minLat, latitude.doubleValue);
            maxLat = MAX(maxLat, latitude.doubleValue);
            minLon = MIN(minLon, longitude.doubleValue);
            maxLon = MAX(maxLon, longitude.doubleValue);
            
            locations[i] = CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue);
        }
        
        BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:locations count:[poisWithoutZero count]];
        
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5f, (minLon + maxLon) * 0.5f);
        BMKCoordinateSpan viewSapn;
        viewSapn.latitudeDelta = maxLat - minLat;
        viewSapn.longitudeDelta = maxLon - minLon;
        BMKCoordinateRegion viewRegion;
        viewRegion.center = centerCoord;
        viewRegion.span = viewSapn;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_historyMapView setRegion:viewRegion animated:YES];
            [_historyMapView addOverlay:polyline];
        });
        
        free(locations);
    }
}


//绘制轨迹
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        //轨迹颜色
        polylineView.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
        //轨迹宽度
        polylineView.lineWidth = 5.0;
        
        return polylineView;
    }
    return nil;
}


@end
