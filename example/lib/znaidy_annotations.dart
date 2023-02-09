import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/main.dart';
import 'package:mapbox_maps_example/page.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/helpers.dart';

class ZnaidyAnnotationPage extends ExamplePage {
  const ZnaidyAnnotationPage()
      : super(const Icon(Icons.map), 'Znaidy Annotations');

  @override
  Widget build(BuildContext context) {
    return ZnaidyAnnotationBody();
  }
}

class ZnaidyAnnotationBody extends StatefulWidget {
  const ZnaidyAnnotationBody({Key? key}) : super(key: key);

  @override
  State<ZnaidyAnnotationBody> createState() => _ZnaidyAnnotationBodyState();
}

class _ZnaidyAnnotationBodyState extends State<ZnaidyAnnotationBody> {
  MapboxMap? mapboxMap;
  ZnaidyAnnotationManager? znaidyAnnotationManager;
  ZnaidyAnnotation? annotation;
  int styleIndex = 1;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    znaidyAnnotationManager =
        await mapboxMap.annotations.createZnaidyAnnotationManager();
  }

  Widget _create() {
    return TextButton(
        child: Text('create annotation'),
        onPressed: () async {
          _createAnnotation();
        });
  }

  Widget _delete() {
    return TextButton(
        child: Text('delete annotation'),
        onPressed: () async {
          _deleteAnnotation();
        });
  }

  Widget _update() {
    return TextButton(
        child: Text('update annotation'),
        onPressed: () async {
          _updateAnnotation();
        });
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
        key: ValueKey("mapWidget"),
        resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
        onMapCreated: _onMapCreated);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.add(_create());
    listViewChildren.add(_delete());
    listViewChildren.add(_update());

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              child: mapWidget),
        ),
        Expanded(
          child: ListView(
            children: listViewChildren,
          ),
        )
      ],
    );

    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                  child: Icon(Icons.swap_horiz),
                  heroTag: null,
                  onPressed: () {
                    mapboxMap?.style.setStyleURI(annotationStyles[
                        ++styleIndex % annotationStyles.length]);
                  }),
              SizedBox(height: 10),
              FloatingActionButton(
                  child: Icon(Icons.clear),
                  heroTag: null,
                  onPressed: () {
                    // if (pointAnnotationManager != null) {
                    //   mapboxMap?.annotations
                    //       .removeAnnotationManager(pointAnnotationManager!);
                    //   pointAnnotationManager = null;
                    // }
                  }),
            ],
          ),
        ),
        body: column);
  }

  Future<void> _createAnnotation() async {
    annotation = await znaidyAnnotationManager?.create(
      ZnaidyAnnotationOptions(
        geometry: createRandomPoint().toJson(),
      ),
    );
    dev.log('ZnaidyAnnotation: create: (${annotation?.id}, ${annotation?.geometry})');
  }

  Future<void> _deleteAnnotation() async {
    if (annotation == null) return;
    await znaidyAnnotationManager?.delete(annotation!);
    dev.log('ZnaidyAnnotation: deleted (${annotation?.id}, ${annotation?.geometry})');
    annotation = null;
  }

  Future<void> _updateAnnotation() async {
    if (annotation == null) return;
    final lastPosition = Point.fromJson(annotation!.geometry!.cast());
    final newPosition = Point(coordinates: Position(
      lastPosition.coordinates.lng + 1,
      lastPosition.coordinates.lat + 1,
    ));
    final newAnnotation = ZnaidyAnnotation(id: annotation!.id, geometry: newPosition.toJson());
    await znaidyAnnotationManager?.update(newAnnotation);
    dev.log('ZnaidyAnnotation: updated (${annotation?.id}, ${annotation?.geometry}) -> (${newAnnotation.id}, ${newAnnotation.geometry})');
    annotation = newAnnotation;
  }
}
