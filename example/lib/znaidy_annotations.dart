import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/main.dart';
import 'package:mapbox_maps_example/page.dart';
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

  final avatars = [
    'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1760&q=80',
    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1760&q=80',
    'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2067&q=80',
    'https://images.unsplash.com/photo-1607746882042-944635dfe10e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
  ];

  Point? position;
  OnlineStatus onlineStatus = OnlineStatus.offline;
  MarkerType markerType = MarkerType.self;
  String? avatarUrl;
  int stickers = 0;
  int companySize = 0;
  int currentSpeed = 0;
  List<String> userAvatars = [];
  Map<String?, Object?>? lastCameraPosition;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    znaidyAnnotationManager =
        await mapboxMap.annotations.createZnaidyAnnotationManager();
    znaidyAnnotationManager?.addOnAnnotationTapListener(
        ZnaidyAnnotationClickListener(_onAnnotationClick));
    mapboxMap.style
        .setStyleURI('mapbox://styles/znaidyme/cld4ktnrl000t01qn90o8n2d5');
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
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
    _focusAnnotation(id, options);
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

  Widget _unfocus() {
    return TextButton(
        child: Text('unfocus'),
        onPressed: () async {
          _unfocusAnnotation();
        });
  }

  Widget _sendSticker() {
    return TextButton(
        child: Text('send sticker'),
        onPressed: () async {
          _animateSticker();
        });
  }

  Widget _updatePosition() {
    return TextButton(
        child: Text('update annotation position'),
        onPressed: () async {
          _updateAnnotationPosition();
        });
  }

  Widget _switchMode() {
    return TextButton(
        child: Text('switch type'),
        onPressed: () async {
          _switchAnnotationMode();
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
    listViewChildren.add(_unfocus());
    listViewChildren.add(_sendSticker());
    listViewChildren.add(_switchMode());
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

  void _resetVars() {
    onlineStatus = OnlineStatus.inApp;
    markerType = MarkerType.self;
    stickers = 0;
    companySize = 0;
    currentSpeed = 0;
    userAvatars = avatars;
  }

  Future<void> _createAnnotation() async {
    _resetVars();
    position = Point(
      coordinates: Position(
        30.5,
        50.45,
      ),
    );
    annotationId = await znaidyAnnotationManager?.create(
      ZnaidyAnnotationOptions(
        geometry: position!.toJson(),
        markerType: markerType,
        onlineStatus: onlineStatus,
        userAvatars: userAvatars,
        companySize: companySize,
        currentSpeed: currentSpeed,
        stickerCount: stickers,
      ),
    );
  }

  Future<void> _deleteAnnotation() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.delete(annotationId!, true);
    annotationId = null;
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
      ZnaidyAnnotationOptions(
          geometry: newPosition.toJson(),
        markerType: markerType,
        onlineStatus: onlineStatus,
      ),
    );
    position = newPosition;
  }

  Future<void> _updateAnnotationStatus() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(
        markerType: markerType,
        onlineStatus: _getNextStatus(onlineStatus),
      ),
    );
    onlineStatus = _getNextStatus(onlineStatus);
  }

  Future<void> _updateStickerCount() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(
        markerType: markerType,
        onlineStatus: onlineStatus,
        stickerCount: stickers + 1,
      ),
    );
    stickers = stickers + 1;
  }

  Future<void> _updateCompany() async {
    if (annotationId == null) return;
    final size = (companySize + 1).remainder(avatars.length);
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(
          markerType: markerType,
          onlineStatus: onlineStatus,
          companySize: size, userAvatars: avatars.sublist(0, size)),
    );
    companySize = size;
  }

  Future<void> _updateCurrentSpeed() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(
        markerType: markerType,
        onlineStatus: onlineStatus,
          currentSpeed: currentSpeed + 1,
      ),
    );
    currentSpeed = currentSpeed + 1;
  }

  Future<void> _switchAnnotationMode() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.update(
      annotationId!,
      ZnaidyAnnotationOptions(
        onlineStatus: onlineStatus,
        markerType: _getNextType(markerType),),
    );
    markerType = _getNextType(markerType);
  }

  Future<void> _focusAnnotation(
    String id,
    ZnaidyAnnotationOptions options,
  ) async {
    final cameraState = await mapboxMap?.getCameraState();
    lastCameraPosition = cameraState?.center;
    mapboxMap?.flyTo(
      CameraOptions(
        center: options.geometry,
        bearing: 1,
      ),
      MapAnimationOptions(duration: 500),
    );
    await znaidyAnnotationManager?.select(id);
  }

  Future<void> _unfocusAnnotation() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.resetSelection(annotationId!);
    await mapboxMap?.easeTo(
      CameraOptions(
        center: lastCameraPosition,
        bearing: 1,
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  Future<void> _animateSticker() async {
    if (annotationId == null) return;
    await znaidyAnnotationManager?.sendSticker(annotationId!);
  }

  OnlineStatus _getNextStatus(OnlineStatus status) {
    final index = OnlineStatus.values.indexOf(status);
    final newIndex = (index + 1).remainder(OnlineStatus.values.length);
    return OnlineStatus.values[newIndex];
  }

  MarkerType _getNextType(MarkerType type) {
    final index = MarkerType.values.indexOf(type);
    final newIndex = (index + 1).remainder(MarkerType.values.length);
    return MarkerType.values[newIndex];
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
