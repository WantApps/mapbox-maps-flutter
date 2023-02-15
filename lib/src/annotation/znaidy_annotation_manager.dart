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

  Future<void> delete(String annotationId) => messager.delete(id, annotationId);

  Future<void> select(String annotationId) => messager.select(id, annotationId);

  Future<void> resetSelection(String annotationId) =>
      messager.resetSelection(id, annotationId);

  void addOnAnnotationTapListener(OnZnaidyAnnotationClickListener listener) {
    OnZnaidyAnnotationClickListener.setup(listener);
  }
}
