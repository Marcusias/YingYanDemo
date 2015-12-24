//
//  FirstViewController.m
//  YingYanSDKDemo
//
//  Copyright © 2015 Baidu. All rights reserved.
//

#import "FirstViewController.h"
#import "JSONKit.h"

@interface FirstViewController () <ApplicationServiceDelegate, ApplicationEntityDelegate, ApplicationTrackDelegate, ApplicationFenceDelegate, UIAlertViewDelegate, BMKMapViewDelegate> {
    BMKPointAnnotation* pointAnnotation;
    BMKCircle *circleFence;
}
@end


@implementation FirstViewController

dispatch_queue_t global_queue;

static bool isStartPressed = TRUE;
static NSString * entityName;
static BTRACE * traceInstance = NULL;


double radiusOfFence;
double latitudeOfFenceCenter;
double longitudeOfFenceCenter;
double latitudeOfEntity;
double longitudeOfEntity;
int idOfFence;
unsigned long numberOfExistingFences;
bool isReadyToSetFence = false;
NSTimer *timer;
NSRunLoop *loop;
static bool isMonitoringEntity = true;

bool firstTimeIntoForeGround = true;

#pragma mark - 系统回调方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"first viewdidload");
    
    // Do any additional setup after loading the view, typically from a nib.
    
    global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /// 地图比例尺级别，在手机上当前可使用的级别为3-20级,  级别越大,地图精细度越大.
    [_mapView setZoomLevel:20];
    
    
    pointAnnotation = nil;
    //围栏
    circleFence = nil;
    //设置观察(通知)
    [self addObservers];
}




-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"first viewWillAppear");
    
    [self doWork];
}


-(void)applicationWillResignActive
{
    NSLog(@"程序即将进入后台执行");
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    pointAnnotation = nil;
    circleFence = nil;
    [timer invalidate];
    isMonitoringEntity = false;
}

-(void)applicationDidBecomeActive
{
    NSLog(@"程序已经进入前台执行");
    if (firstTimeIntoForeGround)
    {
        firstTimeIntoForeGround = false;
        return;
    }
    [self doWork];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"first viewWillDisappear");
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    pointAnnotation = nil;
    circleFence = nil;
    [timer invalidate];
    isMonitoringEntity = false;
}

- (void)dealloc
{
    if (_mapView)
    {
        _mapView = nil;
    }
    [self removeObservers];
}

#pragma mark - 事件监听方法

//开始实时追踪
- (IBAction)startTrace:(UIButton *)sender
{
    isStartPressed = TRUE;
    /*
     gatherInterval 采集周期 取值范围[2, 60] 单位 秒
     packInterval 打包周期 取值范围[2, 60] 单位 秒
     打包周期必须比采集周期大，且必须是采集周期的整数倍
     */
    BOOL intervalSetRet = [traceInstance setInterval:2 packInterval:10];
    
    NSLog(@"设置间隔结果%@",intervalSetRet ? @"YES" : @"NO");
    
    dispatch_async(global_queue, ^{
        [[BTRACEAction shared] startTrace:self trace:traceInstance];
    });
}

//停止实时追踪
- (IBAction)stopTrace:(UIButton *)sender
{
    dispatch_async(global_queue, ^{
        [[BTRACEAction shared] stopTrace:self trace:traceInstance];
    });
}



//围栏 设置半径

- (IBAction)setFenceEntity:(UIButton *)sender
{
    isReadyToSetFence = true;
    
    //第一步：弹出alertView让用户输入围栏的半径
    UIAlertView *alertForRadius = [[UIAlertView alloc] initWithTitle:@"围栏设置" message:@"第一步：请输入围栏的半径" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertForRadius.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * textField = [alertForRadius textFieldAtIndex:0];
    
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [alertForRadius show];
}


//状态查询  返回是否在围栏内
- (IBAction)queryFenceStatus:(UIButton *)sender
{
    /*
     serviceId 鹰眼服务唯一标识
     fenceId   地理围栏的唯一标识; int
     monitoredPersons 围栏监控对象列表; string,string…; 多个对象用逗号分隔,表示查询那些监控对象的状态,不填时，查询所有监控对象的状态
     */
    dispatch_async(global_queue, ^{
        extern int serviceId;
        [[BTRACEAction shared] queryFenceStatus:self serviceId:serviceId fenceId:idOfFence monitoredPersons:entityName];
    });
}

- (IBAction)queryHistoryAlarm:(UIButton *)sender
{
    double startTime = [[NSDate date] timeIntervalSince1970] - 42200;
    double endTime = [[NSDate date] timeIntervalSince1970];
    dispatch_async(global_queue, ^{
        extern int serviceId;
        [[BTRACEAction shared] queryFenceHistoryAlarm:self serviceId:serviceId fenceId:idOfFence monitoredPersons:entityName beginTime:(int)startTime endTime:(int)endTime];
    });
}

- (IBAction)setDelayAlarm:(UIButton *)sender
{
    double time = [[NSDate date] timeIntervalSince1970] + 300;
    dispatch_async(global_queue, ^{
        extern int serviceId;
        [[BTRACEAction shared] fenceDelayAlarm:self serviceId:serviceId fenceId:idOfFence observer:entityName time:(long long)time];
    });
}

//设置围栏中心位置
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"确定"])
    {
        UITextField * textField = [alertView textFieldAtIndex:0];
        radiusOfFence = [textField.text doubleValue];
        //第二步：让用户在地图上点击确认圆心的位置
        UIAlertView *alertForCenter = [[UIAlertView alloc] initWithTitle:@"围栏设置" message:@"第二步：请在地图上单击确认围栏的圆心" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertForCenter show];
    }
}

//  大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (annotation == pointAnnotation)
    {
        NSString *AnnotationViewID = @"renameMark";
        
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (annotationView == nil)
        {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    return nil;
}

//单击地图空白处获得地理围栏圆心的位置
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (!isReadyToSetFence)
    {
        return;
    }
    isReadyToSetFence = false;
    latitudeOfFenceCenter = coordinate.latitude;
    longitudeOfFenceCenter = coordinate.longitude;
    NSString *centerOfFence = [NSString stringWithFormat:@"%f,%f", longitudeOfFenceCenter,latitudeOfFenceCenter];
    if (0 == numberOfExistingFences)
    { //还没有创建过围栏，新建一个围栏
        dispatch_async(global_queue, ^{
            extern int serviceId;
            [[BTRACEAction shared] createCircularFence:self serviceId:serviceId fenceName:@"test_fence" fenceDesc:nil creator:entityName monitoredPersons:entityName observers:entityName validTimes:@"0000,2359" validCycle:4 validDate:nil validDays:nil coordType:3 center:centerOfFence radius:radiusOfFence alarmCondition:3];
        });
    }
    else
    { //已经有围栏了，就更新
        dispatch_async(global_queue, ^{
            extern int serviceId;
            [[BTRACEAction shared] updateFence:self serviceId:serviceId fenceId:idOfFence fenceName:nil fenceDesc:nil monitoredPersons:nil observers:nil validTimes:nil validCycle:0 validDate:nil validDays:nil shape:0 coordType:0 center:centerOfFence radius:radiusOfFence vertexes:nil alarmCondition:0];
        });
    }
}

#pragma mark - 实例方法

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序.
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void) doWork
{
    
    //不妨以IDFV作为entityName,开发者可以使用自己业务相关的唯一标识作为entityName
        entityName = @"39D3873F-0775-4E24-92B5-C5DD0A82B6F3";
    [_entityNameLabel setText:entityName];
    
    //使用鹰眼SDK，必须先实例化Trace对象 operationMode  2代表进行长连接，且采集轨迹数据
    extern int serviceId;
    extern NSString* const AK;
    extern NSString* const MCODE;
    
    traceInstance = [[BTRACE alloc] initWithAk: AK mcode: MCODE serviceId: serviceId entityName: entityName operationMode: 1];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.mapType = BMKMapTypeStandard;
    
    //视图加载之后就请求实时位置
    [self queryEntityList];
    //查找当前的围栏列表
    [self queryFenceList];
    
    loop = [NSRunLoop currentRunLoop];
    //
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:5 target:self selector:@selector(queryEntityList) userInfo:nil repeats:YES];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    isMonitoringEntity = true;
}


- (void)queryFenceList
{
    dispatch_async(global_queue, ^{
        extern int serviceId;
        [[BTRACEAction shared] queryFenceList:self serviceId:serviceId creator:entityName fenceIds:nil];
    });
}
//获取实时位置
- (void)queryEntityList
{
    dispatch_async(global_queue, ^{
        extern int serviceId;
        [[BTRACEAction shared] queryEntityList:self serviceId:serviceId entityNames:entityName columnKey:nil activeTime:0 returnType:0 pageSize:0 pageIndex:0];
        
    });
}


//添加圆形地理围栏
- (void)addOverlayView {
    CLLocationCoordinate2D coord;
    coord.latitude = latitudeOfFenceCenter;
    coord.longitude = longitudeOfFenceCenter;
    circleFence = [BMKCircle circleWithCenterCoordinate:coord radius:radiusOfFence];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addOverlay:circleFence];
    });
}

//添加当前位置的标注
-(void)addPointAnnotation {
    CLLocationCoordinate2D coord;
    coord.latitude = latitudeOfEntity;
    coord.longitude = longitudeOfEntity;
    if (nil == pointAnnotation) {
        pointAnnotation = [[BMKPointAnnotation alloc] init];
    }
    pointAnnotation.coordinate = coord;
    pointAnnotation.title = @"最新位置";
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView setCenterCoordinate:coord animated:true];
        [_mapView addAnnotation:pointAnnotation];
    });
}

-(void)putMessageInTextView:(NSString*) message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _textView.alpha = 1;
        _textView.text = message;
    });
    [NSThread sleepForTimeInterval:2];
    dispatch_async(dispatch_get_main_queue(), ^{
        _textView.text = @"";
        _textView.alpha = 0;
    });
}

-(void)trackLatestLocationOfEntity
{

    while (isMonitoringEntity) {
        [self queryEntityList];
        for (int i = 0; i < 5; i++)
        {
            sleep(1);
            if (!isMonitoringEntity)
            {
                break;
            }
        }
    }
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    
    if (overlay == circleFence) {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        circleView.lineWidth = 4.0;
        return circleView;
    }
    return nil;
}

- (NSDictionary*)trackAttr
{
    NSMutableDictionary *glossary = [NSMutableDictionary dictionary];
    [glossary setObject: @"col1" forKey: @"v1"];
    [glossary setObject: @"col2" forKey: @"v2"];
    return glossary;
}


#pragma mark - 地理围栏相关的回调方法

///围栏历史报警查询 回调方法
- (void)onQueryFenceHistoryAlarm:(NSData *)data
{
    NSString *fenceHistoryAlarmResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"围栏历史报警查询结果: %@", fenceHistoryAlarmResult);
    
    NSDictionary *dic = [fenceHistoryAlarmResult objectFromJSONString];
    NSNumber *status = [dic objectForKey:@"status"];
    if (0 == [status longValue])
    {
        NSMutableString *alarmReport = [[NSMutableString alloc] initWithString:@"历史报警信息\n"];
        NSArray *monitored_person_alarms = [dic objectForKey:@"monitored_person_alarms"];
        for (NSDictionary *alarmInfo in monitored_person_alarms) {
            if (NO == [entityName isEqualToString: [alarmInfo objectForKey:@"monitored_person"]])
            {
                continue;
            }
            NSArray *alarms = [alarmInfo objectForKey:@"alarms"];
            for (NSDictionary *alarm in alarms) {
                int action = [[alarm objectForKey:@"action"] intValue];
                long longTime = [[alarm objectForKey:@"time"] longValue];
                //将时间戳转换为格式化时间
                NSString *stringTime = [NSString stringWithFormat:@"%ld",longTime];
                NSDate *time_str = [NSDate dateWithTimeIntervalSince1970: [stringTime doubleValue]];
                NSDateFormatter *date_format_str = [[NSDateFormatter alloc] init];
                date_format_str.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
                [date_format_str setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *date_string = [date_format_str stringFromDate:time_str];
                NSMutableString *singleAlarm = [[NSMutableString alloc] initWithFormat:@"在 %@ ",date_string];
                switch (action) {
                    case 1:
                        [singleAlarm appendString:@"进入围栏\n"];
                        break;
                    case 2:
                        [singleAlarm appendString:@"离开围栏\n"];
                        break;
                    default:
                        break;
                }
                [alarmReport appendString: singleAlarm];
            }
        }
        [self putMessageInTextView:alarmReport];
    }
}

///延迟报警请求的回调方法
- (void)onFenceDelayAlarm:(NSData *)data {
    NSString *fenceDelayAlarmResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"围栏延迟报警设置结果: %@", fenceDelayAlarmResult);
    [self putMessageInTextView:fenceDelayAlarmResult];
}

///围栏状态查询的回调方法
- (void)onQueryFenceStatus:(NSData *)data {
    NSString *fenceStatusResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"围栏状态查询结果: %@", fenceStatusResult);
    NSDictionary *dic = [fenceStatusResult objectFromJSONString];
    NSNumber *status = [dic objectForKey:@"status"];
    if (0 == [status longValue]) {
        NSArray *statuses = [dic objectForKey:@"monitored_person_statuses"];
        NSDictionary *monitorOne = [statuses objectAtIndex:0];
        NSNumber *currentStatus = [monitorOne objectForKey:@"monitored_status"];
        switch ([currentStatus intValue]) {
            case 1:
                [self putMessageInTextView:@"您在围栏内"];
                break;
            case 2:
                [self putMessageInTextView:@"您在围栏外"];
                break;
            default:
                [self putMessageInTextView:@"您当前和围栏的关系未知"];
                break;
        }
    }
}


///查询围栏列表的回调方法
- (void)onFenceList:(NSData *)data {
    NSString *fenceListResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"fence/list查询结果: %@", fenceListResult);
    NSDictionary *dic = [fenceListResult objectFromJSONString];
    NSNumber *status = [dic objectForKey:@"status"];
    if (0 == [status longValue]) {
        NSArray *fences = [dic objectForKey:@"fences"];
        numberOfExistingFences = [fences count];
        if (0 == numberOfExistingFences) {
            NSLog(@"当前没有围栏");
        } else {
            NSDictionary *fence = [fences objectAtIndex:0];
            NSNumber *fenceId = [fence objectForKey:@"fence_id"];
            NSNumber *radius = [fence objectForKey:@"radius"];
            NSDictionary *center = [fence objectForKey:@"center"];
            longitudeOfFenceCenter = [[center objectForKey:@"longitude"] doubleValue];
            latitudeOfFenceCenter = [[center objectForKey:@"latitude"] doubleValue];
            radiusOfFence = [radius doubleValue];
            idOfFence = [fenceId intValue];
            [self addOverlayView];
        }
    }
}

///创建围栏的回调方法
- (void)onCreateFence:(NSData *)data {
    NSString* fenceCreateResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"fence/create创建围栏结果: %@", fenceCreateResult);
}

///更新围栏的回调方法
- (void)onUpdateFence:(NSData *)data {
    NSString *fenceUpdateResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"fence/update更新围栏结果: %@", fenceUpdateResult);
    circleFence = nil;
    [self addOverlayView];
}


#pragma mark - Trace服务相关的回调方法

- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString *)errMsg {
    NSLog(@"startTrace: %@", errMsg);
    NSString* no = [NSString stringWithFormat:@"%ld",(long)errNo];
    [self putMessageInTextView:no];
    [self putMessageInTextView:errMsg];
}

- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString *)errMsg {
    NSLog(@"stopTrace: %@", errMsg);
    [self putMessageInTextView:errMsg];
}



//接收报警信息
- (void)onPushTrace:(uint8_t)msgType msgContent:(NSString *)msgContent{
    NSLog(@"收到推送消息: 类型[%d] 内容[%@]", msgType, msgContent);
    [self putMessageInTextView:msgContent];
}

#pragma mark - Entity相关的回调方法

- (void)onQueryEntityList:(NSData *)data
{
    NSString *entityListResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"实时位置查询结果: %@", entityListResult);
    NSDictionary *dic = [entityListResult objectFromJSONString];
    NSNumber *status = [dic objectForKey:@"status"];
    if (0 == [status longValue]) {
        NSArray *entities = [dic objectForKey:@"entities"];
        for (int i = 0; i < [entities count]; i++) {
            NSDictionary *entity = [entities objectAtIndex:i];
            NSDictionary *realtimePoint = [entity objectForKey:@"realtime_point"];
            NSArray *location = [realtimePoint objectForKey:@"location"];
            longitudeOfEntity = [[location objectAtIndex:0] doubleValue];
            latitudeOfEntity = [[location objectAtIndex:1] doubleValue];
            extern double const EPSILON;
            if (fabs(longitudeOfEntity - 0) < EPSILON && fabs(latitudeOfEntity - 0) < EPSILON) {
                continue;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeOverlays:_mapView.overlays];
                [_mapView removeAnnotations:_mapView.annotations];
            });
            [self addOverlayView];
            [self addPointAnnotation];
        }
    }
}

@end
