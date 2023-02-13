import 'package:pigeon/pigeon.dart';

enum OnlineStatus {
  online,
  inApp,
  offline,
}

class ZnaidyAnnotationOptions {
  ZnaidyAnnotationOptions({
    this.geometry,
    this.onlineStatus,
    this.userAvatars,
    this.stickerCount,
    this.companySize,
    this.currentSpeed,
});

  Map<String?, Object?>? geometry;
  OnlineStatus? onlineStatus;
  List<String>? userAvatars;
  int? stickerCount;
  int? companySize;
  int? currentSpeed;
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
  void delete(String managetId, String annotationId,);
}