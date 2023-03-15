import 'package:pigeon/pigeon.dart';

enum OnlineStatus {
  none,
  online,
  inApp,
  offline,
}

enum MarkerType {
  none,
  self,
  friend,
  company,
}

class ZnaidyAnnotationOptions {
  ZnaidyAnnotationOptions({
    this.geometry,
    this.markerType,
    this.onlineStatus,
    this.userAvatars,
    this.stickerCount,
    this.companySize,
    this.currentSpeed,
});

  Map<String?, Object?>? geometry;
  MarkerType? markerType;
  OnlineStatus? onlineStatus;
  List<String?>? userAvatars;
  int? stickerCount;
  int? companySize;
  int? currentSpeed;
  double? zoomFactor;
}

@FlutterApi()
abstract class OnZnaidyAnnotationClickListener {
  void onZnaidyAnnotationClick(String annotationId, ZnaidyAnnotationOptions? annotationOptions);
}

@HostApi()
abstract class _ZnaidyAnnotationMessager {
  @async
  String create(String managerId, ZnaidyAnnotationOptions annotationOptions);

  @async
  void update(String managerId, String annotationId, ZnaidyAnnotationOptions annotationOptions);

  @async
  void delete(String managerId, String annotationId, bool animated);

  @async
  void select(String managerId, String annotationId, double bottomPadding);

  @async
  void resetSelection(String managerId, String annotationId);

  @async
  void sendSticker(String managerId, String annotationId);

  @async
  void setUpdateRate(String managerId, int rate);
}