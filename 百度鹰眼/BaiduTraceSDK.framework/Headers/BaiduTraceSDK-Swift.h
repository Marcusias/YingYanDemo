// Generated by Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import Foundation;
@import ObjectiveC;
@import CoreLocation;
@import SystemConfiguration;
@import Foundation.NSURLSession;
#endif


/// Entity相关的HTTP请求的协议,包括entity相关HTTP请求的回调方法
SWIFT_PROTOCOL("_TtP13BaiduTraceSDK25ApplicationEntityDelegate_")
@protocol ApplicationEntityDelegate
@optional

/// 创建 Entity 的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onAddEntity:(NSData * __nonnull)data;

/// 更新 Entity 的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onUpdateEntity:(NSData * __nonnull)data;

/// 查询 Entity的列表 的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onQueryEntityList:(NSData * __nonnull)data;
@end



/// 地理围栏相关HTTP请求的协议,包括地理围栏相关HTTP请求的回调方法
SWIFT_PROTOCOL("_TtP13BaiduTraceSDK24ApplicationFenceDelegate_")
@protocol ApplicationFenceDelegate
@optional

/// 创建地理围栏的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onCreateFence:(NSData * __nonnull)data;

/// 更新地理围栏的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onUpdateFence:(NSData * __nonnull)data;

/// 删除地理围栏的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onDeleteFence:(NSData * __nonnull)data;

/// 查询地理围栏列表的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onFenceList:(NSData * __nonnull)data;

/// 查询地理围栏监控对象的状态的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onQueryFenceStatus:(NSData * __nonnull)data;

/// 查询地理围栏历史报警信息的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onQueryFenceHistoryAlarm:(NSData * __nonnull)data;

/// 设置地理围栏延迟报警的回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onFenceDelayAlarm:(NSData * __nonnull)data;
@end



/// 轨迹服务的协议，,包括轨迹服务相关的回调方法
SWIFT_PROTOCOL("_TtP13BaiduTraceSDK26ApplicationServiceDelegate_")
@protocol ApplicationServiceDelegate
@optional

/// 开始轨迹服务的回调方法
///
/// param:
///
/// errNo 状态码
///
/// errMsg 状态信息
- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString * __nonnull)errMsg;

/// 获取附加数据的回调方法，开发者需要实现这个方法，在此方法中返回自定义列的键和值 returns: 用户自定义列的键值对
- (NSDictionary<NSString *, NSString *> * __nullable)trackAttr;

/// 结束行程回调方法
///
/// param:
///
/// errNo 状态码
///
/// errMsg 状态信息
- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString * __nonnull)errMsg;

/// 推送信息回调方法
///
/// param:
///
/// msgType    状态码
///
/// msgContent 状态信息
- (void)onPushTrace:(uint8_t)msgType msgContent:(NSString * __nonnull)msgContent;
@end



/// track相关HTTP请求的协议,包括track相关HTTP请求的回调方法
SWIFT_PROTOCOL("_TtP13BaiduTraceSDK24ApplicationTrackDelegate_")
@protocol ApplicationTrackDelegate
@optional

/// 历史轨迹查询回调方法
///
/// param:
///
/// data JSON格式的返回内容
- (void)onGetHistoryTrack:(NSData * __nonnull)data;
@end


SWIFT_CLASS("_TtC13BaiduTraceSDK6BTRACE")
@interface BTRACE : NSObject
@property (nonatomic, copy) NSString * __nonnull ak;
@property (nonatomic, copy) NSString * __nonnull mcode;
@property (nonatomic) long long serviceId;
@property (nonatomic, copy) NSString * __nonnull entityName;
@property (nonatomic) NSInteger operationMode;
+ (int32_t)gatherInterval;
+ (void)setGatherInterval:(int32_t)value;
+ (int32_t)packInterval;
+ (void)setPackInterval:(int32_t)value;

/// 构造函数
///
/// param:
///
/// ak 在api控制台申请
///
/// mcode 申请ak时对应的安全码
///
/// serviceId 鹰眼服务的唯一标识
///
/// entityName entity的唯一标识
///
/// operationMode 轨迹服务类型(0:不建立长连接, 1:建立长连接但不采集数据, 2:建立长连接并采集数据)
- (nonnull instancetype)initWithAk:(NSString * __nonnull)ak mcode:(NSString * __nonnull)mcode serviceId:(long long)serviceId entityName:(NSString * __nonnull)entityName operationMode:(NSInteger)operationMode OBJC_DESIGNATED_INITIALIZER;

/// 设置采集周期和打包周期
///
/// param:
///
/// gatherInterval 采集周期 取值范围[2, 60] 单位 秒
///
/// packInterval 打包周期 取值范围[2, 60] 单位 秒
///
/// 打包周期必须比采集周期大，且必须是采集周期的整数倍
///
/// return:
///
/// TRUE设置成功 FALSE代表设置失败
- (BOOL)setInterval:(int32_t)gatherInterval packInterval:(int32_t)packInterval;
@end



/// 该类封装了鹰眼SDK中所有的方法
SWIFT_CLASS("_TtC13BaiduTraceSDK12BTRACEAction")
@interface BTRACEAction : NSObject
+ (BTRACEAction * __nonnull)shared;

/// 开始轨迹服务
///
/// param:
///
/// delegate 轨迹服务的代理
///
/// trace 轨迹类的对象
- (void)startTrace:(id <ApplicationServiceDelegate> __nonnull)delegate trace:(BTRACE * __nonnull)trace;

/// 结束轨迹服务
///
/// param:
///
/// delegate 轨迹服务的代理
///
/// trace 轨迹类的对象
- (void)stopTrace:(id <ApplicationServiceDelegate> __nonnull)delegate trace:(BTRACE * __nonnull)trace;

/// 查询所有符合条件的entity信息及其实时位置
///
/// param:
///
/// serviceId 鹰眼服务ID
///
/// entityNames 要检索的entity_name集合
///
/// columnKey 开发者自定义的entity属性字段
///
/// activeTime 活跃时间
///
/// returnType 返回结果的类型
///
/// pageSize 分页大小
///
/// pageIndex 分页索引
- (void)queryEntityList:(id <ApplicationEntityDelegate> __nonnull)delegate serviceId:(long long)serviceId entityNames:(NSString * __nullable)entityNames columnKey:(NSString * __nullable)columnKey activeTime:(NSInteger)activeTime returnType:(NSInteger)returnType pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

/// 添加一个新的entity，一个entity可以是一个人、一辆车、或者任何运动的物体
///
/// param:
///
/// serviceId 鹰眼服务ID
///
/// entityName entity名称，作为其唯一标识
///
/// columnKey 开发者自定义的entity属性字段
- (void)addEntity:(id <ApplicationEntityDelegate> __nonnull)delegate serviceId:(long long)serviceId entityName:(NSString * __nonnull)entityName columnKey:(NSString * __nonnull)columnKey;

/// 更新entity信息
///
/// param:
///
/// serviceId 鹰眼服务ID
///
/// entityName entity名称，作为其唯一标识
///
/// columnKey 开发者自定义的entity属性字段
- (void)updateEntity:(id <ApplicationEntityDelegate> __nonnull)delegate serviceId:(long long)serviceId entityName:(NSString * __nonnull)entityName columnKey:(NSString * __nullable)columnKey;

/// 通过serviceId和entityName查找本entity历史轨迹点的具体信息，包括经纬度，时间，其他用户自定义信息等。
///
/// param:
///
/// serviceId 鹰眼服务ID
///
/// entityName entity唯一标识
///
/// startTime 起始时间 UNIX时间戳
///
/// endTime 结束时间 UNIX时间戳 结束时间不超过当前时间，不能早于起始时间，且与起始时间差在24小时之内。
///
/// simpleReturn 是否返回精简结果  0代表返回原始结果，1代表返回精简结果。
///
/// isProcesed 是否返回纠偏后轨迹  0为返回原始轨迹，1为返回纠偏轨迹。
///
/// pageSize 分页大小; int(1-5000); 返回结果最大个数与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几条记录。
///
/// pageIndex 分页索引; int(1到2^21-1); 与pageSize一起计算从第几条结果返回，代表返回第几页。
- (void)getTrackHistory:(id <ApplicationTrackDelegate> __nonnull)delegate serviceId:(long long)serviceId entityName:(NSString * __nonnull)entityName startTime:(long long)startTime endTime:(long long)endTime simpleReturn:(NSInteger)simpleReturn isProcessed:(NSInteger)isProcessed pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

/// 创建一个新的圆形围栏
///
/// param:
///
/// serviceId 鹰眼服务唯一标识
///
/// fenceName 围栏名称
///
/// fenceDesc 围栏描述; string(1024)
///
/// creator 围栏创建者; string; 创建者的entityName
///
/// monitoredPersons 监控对象列表; string,string…;	 被监控者的entityName，使用英文逗号”,”分割，至少一个，最多五个。
///
/// observers 观察者列表; string,string…;	观察者的entityName，使用英文逗号”,”分割，至少一个，最多五个。
///
/// validTimes 围栏生效时间列表; "string,string;string,string;…"; 一天中的几点几分到几点几分生效。至少含有一段生效时间，多个时间段使用分号”;”分隔。比如：“0820,0930;1030,1130”
///
/// validCycle 围栏生效周期; int; 标识valid_times是否周期性生效，可以使用如下数值 1：不重复 2：工作日循环 3：周末循环 4：每天循环 5：自定义 当为5时，需要定义valid_days，标识在周几生效。当validCycle为1时，必须设置validDate字段，当validCycle为5时，必须设置validDays字段。
///
/// validDate 围栏生效日期; string; 当valid_cycle为1时必须设置此字段的值，例如：20150908。
///
/// validDays 围栏生效日期列表; int,int...; 1到7，分别表示周一到周日，当valid_cycle为5时必须设置此字段的值。
///
/// coordType 坐标类型; int(1,3); 坐标类型定义如下：1：GPS经纬度 2：国测局经纬度 3：百度经纬度
///
/// center 围栏圆心经纬度; double,double; 格式为：经度,纬度; 示例：116.4321,38.76623
///
/// radius 围栏半径; double(0, 5000]; 单位：米.
///
/// alarmCondition 围栏报警条件; int; 1：进入时触发提醒 2：离开时触发提醒 3：进入离开均触发提醒
- (void)createCircularFence:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceName:(NSString * __nonnull)fenceName fenceDesc:(NSString * __nullable)fenceDesc creator:(NSString * __nonnull)creator monitoredPersons:(NSString * __nonnull)monitoredPersons observers:(NSString * __nonnull)observers validTimes:(NSString * __nonnull)validTimes validCycle:(NSInteger)validCycle validDate:(NSString * __nullable)validDate validDays:(NSString * __nullable)validDays coordType:(NSInteger)coordType center:(NSString * __nonnull)center radius:(double)radius alarmCondition:(NSInteger)alarmCondition;

/// 本接口作为预留，暂不提供多边形围栏创建功能
- (void)createVertexesFence:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceName:(NSString * __nonnull)fenceName fenceDesc:(NSString * __nullable)fenceDesc creator:(NSString * __nonnull)creator monitoredPersons:(NSString * __nonnull)monitoredPersons observers:(NSString * __nonnull)observers validTimes:(NSString * __nonnull)validTimes validCycle:(NSInteger)validCycle validDate:(NSString * __nullable)validDate validDays:(NSString * __nullable)validDays coordType:(NSInteger)coordType vertexes:(NSString * __nonnull)vertexes alarmCondition:(NSInteger)alarmCondition;

/// 更新一个围栏实体的详细信息
///
/// param:
///
/// serviceId 鹰眼服务唯一标识
///
/// fenceId 地理围栏的唯一标识
///
/// fenceName 围栏名称
///
/// fenceDesc 围栏描述; string(1024)
///
/// monitoredPersons 监控对象列表; string,string…;	 被监控者的entityName，使用英文逗号”,”分割，至少一个，最多五个。
///
/// observers 观察者列表; string,string…;	观察者的entityName，使用英文逗号”,”分割，至少一个，最多五个。
///
/// validTimes 围栏生效时间列表; "string,string;string,string;…"; 一天中的几点几分到几点几分生效。至少含有一段生效时间，多个时间段使用分号”;”分隔。比如：“0820,0930;1030,1130”
///
/// validCycle 围栏生效周期; int; 标识valid_times是否周期性生效，可以使用如下数值 1：不重复 2：工作日循环 3：周末循环 4：每天循环 5：自定义 当为5时，需要定义valid_days，标识在周几生效。
///
/// validDate 围栏生效日期; string; 当valid_cycle为1时必须设置此字段的值，例如：20150908。
///
/// validDays 围栏生效日期列表; int,int...; 1到7，分别表示周一到周日，当valid_cycle为5时必须设置此字段的值。
///
/// coordType 坐标类型; int(1,3); 坐标类型定义如下：1：GPS经纬度 2：国测局经纬度 3：百度经纬度
///
/// center 围栏圆心经纬度; double,double; 格式为：经度,纬度; 示例：116.4321,38.76623
///
/// radius 围栏半径; double(0, 5000]; 单位：米.
///
/// alarmCondition 围栏报警条件; int; 1：进入时触发提醒 2：离开时触发提醒 3：进入离开均触发提醒
- (void)updateFence:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceId:(long long)fenceId fenceName:(NSString * __nullable)fenceName fenceDesc:(NSString * __nullable)fenceDesc monitoredPersons:(NSString * __nullable)monitoredPersons observers:(NSString * __nullable)observers validTimes:(NSString * __nullable)validTimes validCycle:(NSInteger)validCycle validDate:(NSString * __nullable)validDate validDays:(NSString * __nullable)validDays shape:(NSInteger)shape coordType:(NSInteger)coordType center:(NSString * __nullable)center radius:(double)radius vertexes:(NSString * __nullable)vertexes alarmCondition:(NSInteger)alarmCondition;

/// 根据fenceId删除围栏
///
/// param:
///
/// serviceId 鹰眼服务唯一标识
///
/// fenceId 地理围栏的唯一标识; int
- (void)deleteFence:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceId:(long long)fenceId;

/// 根据fenceId查询围栏
///
/// param:
///
/// serviceId 鹰眼服务唯一标识
///
/// creator 围栏创建者的entityName; string	; creator和fenceIds二者至少选一个
///
/// fenceIds 查询的地理围栏ID列表，最多10个; int,int...;	creator和fenceIds二者至少选一个
- (void)queryFenceList:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId creator:(NSString * __nullable)creator fenceIds:(NSString * __nullable)fenceIds;

/// 查询围栏的监控对象的历时报警信息
///
/// param:
///
/// serviceId 鹰眼服务唯一标识; int
///
/// fenceId 地理围栏的唯一标识; int
///
/// monitoredPersons 监控对象列表; string,string; 表示查询哪些监控对象的历史动作，如果为空，则查询所有监控对象的历史动作,最多五个
///
/// beginTime 开始时间; UNIX时间戳
///
/// endTime 结束时间; UNIX时间戳
- (void)queryFenceHistoryAlarm:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceId:(long long)fenceId monitoredPersons:(NSString * __nullable)monitoredPersons beginTime:(long long)beginTime endTime:(long long)endTime;

/// 根据fence_id查询围栏内监控对象是在围栏内还是在围栏外
///
/// param:
///
/// serviceId 鹰眼服务唯一标识
///
/// fenceId 地理围栏的唯一标识; int
///
/// monitoredPersons 围栏监控对象列表; string,string…; 多个对象用逗号分隔,表示查询那些监控对象的状态,不填时，查询所有监控对象的状态
- (void)queryFenceStatus:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceId:(long long)fenceId monitoredPersons:(NSString * __nullable)monitoredPersons;

/// 围栏观察者在设定时间内不再接收报警
///
/// param:
///
/// serviceId 鹰眼服务唯一标识
///
/// fenceId 地理围栏的唯一标识
///
/// observer 围栏观察者; string
///
/// time 在此时间之前不再提醒; UNIX时间戳
- (void)fenceDelayAlarm:(id <ApplicationFenceDelegate> __nonnull)delegate serviceId:(long long)serviceId fenceId:(long long)fenceId observer:(NSString * __nonnull)observer time:(long long)time;
@end
