// Autogenerated from Pigeon (v3.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLTOnlineStatus) {
  FLTOnlineStatusNone = 0,
  FLTOnlineStatusOnline = 1,
  FLTOnlineStatusInApp = 2,
  FLTOnlineStatusOffline = 3,
};

typedef NS_ENUM(NSUInteger, FLTMarkerType) {
  FLTMarkerTypeNone = 0,
  FLTMarkerTypeSelf = 1,
  FLTMarkerTypeFriend = 2,
  FLTMarkerTypeCompany = 3,
};

@class FLTZnaidyAnnotationOptions;

@interface FLTZnaidyAnnotationOptions : NSObject
+ (instancetype)makeWithGeometry:(nullable NSDictionary<NSString *, id> *)geometry
    markerType:(FLTMarkerType)markerType
    onlineStatus:(FLTOnlineStatus)onlineStatus
    userAvatars:(nullable NSArray<NSString *> *)userAvatars
    stickerCount:(nullable NSNumber *)stickerCount
    companySize:(nullable NSNumber *)companySize
    currentSpeed:(nullable NSNumber *)currentSpeed
    batteryLevel:(nullable NSNumber *)batteryLevel
    batteryCharging:(nullable NSNumber *)batteryCharging
    zoomFactor:(nullable NSNumber *)zoomFactor;
@property(nonatomic, strong, nullable) NSDictionary<NSString *, id> * geometry;
@property(nonatomic, assign) FLTMarkerType markerType;
@property(nonatomic, assign) FLTOnlineStatus onlineStatus;
@property(nonatomic, strong, nullable) NSArray<NSString *> * userAvatars;
@property(nonatomic, strong, nullable) NSNumber * stickerCount;
@property(nonatomic, strong, nullable) NSNumber * companySize;
@property(nonatomic, strong, nullable) NSNumber * currentSpeed;
@property(nonatomic, strong, nullable) NSNumber * batteryLevel;
@property(nonatomic, strong, nullable) NSNumber * batteryCharging;
@property(nonatomic, strong, nullable) NSNumber * zoomFactor;
@end

/// The codec used by FLTOnZnaidyAnnotationClickListener.
NSObject<FlutterMessageCodec> *FLTOnZnaidyAnnotationClickListenerGetCodec(void);

@interface FLTOnZnaidyAnnotationClickListener : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onZnaidyAnnotationClickAnnotationId:(NSString *)annotationId annotationOptions:(nullable FLTZnaidyAnnotationOptions *)annotationOptions completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by FLT_ZnaidyAnnotationMessager.
NSObject<FlutterMessageCodec> *FLT_ZnaidyAnnotationMessagerGetCodec(void);

@protocol FLT_ZnaidyAnnotationMessager
- (void)createManagerId:(NSString *)managerId annotationOptions:(FLTZnaidyAnnotationOptions *)annotationOptions completion:(void(^)(NSString *_Nullable, FlutterError *_Nullable))completion;
- (void)updateManagerId:(NSString *)managerId annotationId:(NSString *)annotationId annotationOptions:(FLTZnaidyAnnotationOptions *)annotationOptions completion:(void(^)(FlutterError *_Nullable))completion;
- (void)deleteManagerId:(NSString *)managerId annotationId:(NSString *)annotationId animated:(NSNumber *)animated completion:(void(^)(FlutterError *_Nullable))completion;
- (void)selectManagerId:(NSString *)managerId annotationId:(NSString *)annotationId bottomPadding:(NSNumber *)bottomPadding animationDuration:(NSNumber *)animationDuration zoom:(NSNumber *)zoom completion:(void(^)(FlutterError *_Nullable))completion;
- (void)resetSelectionManagerId:(NSString *)managerId annotationId:(NSString *)annotationId completion:(void(^)(FlutterError *_Nullable))completion;
- (void)sendStickerManagerId:(NSString *)managerId annotationId:(NSString *)annotationId completion:(void(^)(FlutterError *_Nullable))completion;
- (void)setUpdateRateManagerId:(NSString *)managerId rate:(NSNumber *)rate completion:(void(^)(FlutterError *_Nullable))completion;
@end

extern void FLT_ZnaidyAnnotationMessagerSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLT_ZnaidyAnnotationMessager> *_Nullable api);

NS_ASSUME_NONNULL_END
