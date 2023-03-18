part of mapbox_maps_flutter;

class ZnaidyAnnotationManager extends BaseAnnotationManager {
  ZnaidyAnnotationManager({required String id}) : super(id: id);

  final _ZnaidyAnnotationMessager messager = _ZnaidyAnnotationMessager();

  Future<String> create(ZnaidyAnnotationOptions annotationOptions) =>
      messager.create(id, annotationOptions);

  Future<void> update(
    String annotationId,
    ZnaidyAnnotationOptions annotationOptions,
  ) =>
      messager.update(id, annotationId, annotationOptions);

  Future<void> delete(String annotationId, bool animated) =>
      messager.delete(id, annotationId, animated);

  Future<void> select(String annotationId, double bottomPadding,
          int animationDuration, double zoom) =>
      messager.select(id, annotationId, bottomPadding, animationDuration, zoom);

  Future<void> resetSelection(String annotationId) =>
      messager.resetSelection(id, annotationId);

  Future<void> sendSticker(String annotationId) =>
      messager.sendSticker(id, annotationId);

  Future<void> setLocationUpdateRate(int rate) =>
      messager.setUpdateRate(id, rate);

  Future<void> setZoomFactor(double zoomFactor) =>
      messager.setZoomFactor(id, zoomFactor);

  void addOnAnnotationTapListener(OnZnaidyAnnotationClickListener listener) {
    OnZnaidyAnnotationClickListener.setup(listener);
  }
}
