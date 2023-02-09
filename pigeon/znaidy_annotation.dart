import 'package:pigeon/pigeon.dart';

class ZnaidyAnnotation {
  ZnaidyAnnotation({
    required this.id,
    this.geometry,
  });

  /// The id for annotation
  String id;

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
}

class ZnaidyAnnotationOptions {
  ZnaidyAnnotationOptions({
    this.geometry,
});

  Map<String?, Object?>? geometry;
}

@FlutterApi()
abstract class OnZnaidyAnnotationClickListener {
  void onZnaidyAnnotationClick(ZnaidyAnnotation annotation);
}

@HostApi()
abstract class _ZnaidyAnnotationMessager {
  @async
  ZnaidyAnnotation create(String managerId, ZnaidyAnnotationOptions annotationOptions);

  @async
  void update(String managerId, ZnaidyAnnotation annotation);

  @async
  void delete(String managetId, ZnaidyAnnotation annotation);
}