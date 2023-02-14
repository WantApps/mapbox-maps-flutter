import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
  String? annotationId;
  int styleIndex = 1;

  Point? position;
  OnlineStatus onlineStatus = OnlineStatus.offline;
  String? avatarUrl;
  int stickers = 0;
  int companySize = 0;
  int currentSpeed = 0;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    znaidyAnnotationManager =
        await mapboxMap.annotations.createZnaidyAnnotationManager();
    znaidyAnnotationManager
        ?.addOnAnnotationTapListener(ZnaidyAnnotationClickListener(_onAnnotationClick));
    mapboxMap.style
        .setStyleURI('mapbox://styles/znaidyme/cld4ktnrl000t01qn90o8n2d5');
    await mapboxMap.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(
            30.5,
            50.45,
          ),
        ).toJson(),
        zoom: 9,
      ),
    );
  }

  Future<void> _onMapTap(ScreenCoordinate coordinate) async {
    dev.log('onMapTap: (${coordinate.x},${coordinate.y})');
  }

  void _onAnnotationClick(String id, ZnaidyAnnotationOptions? options) {
    if (options == null) return;
    mapboxMap?.setCamera(
      CameraOptions(center: options.geometry),
    );
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

  Widget _updatePosition() {
    return TextButton(
        child: Text('update annotation position'),
        onPressed: () async {
          _updateAnnotationPosition();
        });
  }

  Widget _updateStatus() {
    return TextButton(
        child: Text('update annotation status'),
        onPressed: () async {
          _updateAnnotationStatus();
        });
  }

  Widget _updateStickers() {
    return TextButton(
        child: Text('update stickers count'),
        onPressed: () async {
          _updateStickerCount();
        });
  }

  Widget _updateCompanyButton() {
    return TextButton(
        child: Text('update company'),
        onPressed: () async {
          _updateCompany();
        });
  }

  Widget _updateSpeed() {
    return TextButton(
        child: Text('update speed'),
        onPressed: () async {
          _updateCurrentSpeed();
        });
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
      onMapCreated: _onMapCreated,
      onTapListener: _onMapTap,
      gestureRecognizers: {
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      },
    );

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.add(_create());
    listViewChildren.add(_delete());
    listViewChildren.add(_updatePosition());
    listViewChildren.add(_updateStatus());
    listViewChildren.add(_updateStickers());
    listViewChildren.add(_updateCompanyButton());
    listViewChildren.add(_updateSpeed());

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
                    mapboxMap?.style.setStyleURI(
                        'mapbox://styles/znaidyme/cld4ktnrl000t01qn90o8n2d5');
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
        body: column);
  }

  Future<void> _createAnnotation() async {
    position = Point(
      coordinates: Position(
        30.5,
        50.45,
      ),
    );
    annotationId = await znaidyAnnotationManager?.create(
      ZnaidyAnnotationOptions(
        geometry: position!.toJson(),
      ),
    );
  }

  Future<void> _deleteAnnotation() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.delete(annotationId!!);
    annotationId = null;
    stickers = 0;
    companySize = 0;
    currentSpeed = 0;
  }

  Future<void> _updateAnnotationPosition() async {
    if (annotationId == null) return;
    final newPosition = Point(
        coordinates: Position(
      position!.coordinates.lng + 0.001,
      position!.coordinates.lat + 0.001,
    ));
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(geometry: newPosition.toJson()),
    );
    position = newPosition;
  }

  Future<void> _updateAnnotationStatus() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(onlineStatus: _getNextStatus(onlineStatus)),
    );
    onlineStatus = _getNextStatus(onlineStatus);
  }

  Future<void> _updateStickerCount() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(stickerCount: stickers + 1),
    );
    stickers = stickers + 1;
  }

  Future<void> _updateCompany() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(companySize: companySize + 1),
    );
    companySize = companySize + 1;
  }

  Future<void> _updateCurrentSpeed() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(currentSpeed: currentSpeed + 1),
    );
    currentSpeed = currentSpeed + 1;
  }

  OnlineStatus _getNextStatus(OnlineStatus status) {
    final index = OnlineStatus.values.indexOf(status);
    final newIndex = (index + 1).remainder(OnlineStatus.values.length);
    return OnlineStatus.values[newIndex];
  }
}

class ZnaidyAnnotationClickListener extends OnZnaidyAnnotationClickListener {
  ZnaidyAnnotationClickListener(this.onAnnotationClick);

  final void Function(String, ZnaidyAnnotationOptions?) onAnnotationClick;

  @override
  void onZnaidyAnnotationClick(
    String annotationId,
    ZnaidyAnnotationOptions? annotationOptions,
  ) {
    dev.log('onZnaidyAnnotationClick: onTap: $annotationId');
    onAnnotationClick(annotationId, annotationOptions);
  }
}
