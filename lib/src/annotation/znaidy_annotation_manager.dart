part of mapbox_maps_flutter;

class ZnaidyAnnotationManager extends BaseAnnotationManager {
  ZnaidyAnnotationManager({required String id}) : super(id: id);

  final _ZnaidyAnnotationMessager messager = _ZnaidyAnnotationMessager();

  Future<ZnaidyAnnotation> create(ZnaidyAnnotationOptions annotationOptions) =>
      messager.create(id, annotationOptions);

  Future<void> update(ZnaidyAnnotation annotation) =>
      messager.update(id, annotation);

  Future<void> delete(ZnaidyAnnotation annotation) =>
      messager.delete(id, annotation);
}
