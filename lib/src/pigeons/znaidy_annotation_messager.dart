part of mapbox_maps_flutter;

enum OnlineStatus {
  online,
  inApp,
  offline,
}

enum MarkerType {
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
    this.zoomFactor,
  });

  Map<String?, Object?>? geometry;
  MarkerType? markerType;
  OnlineStatus? onlineStatus;
  List<String?>? userAvatars;
  int? stickerCount;
  int? companySize;
  int? currentSpeed;
  double? zoomFactor;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['geometry'] = geometry;
    pigeonMap['markerType'] = markerType?.index;
    pigeonMap['onlineStatus'] = onlineStatus?.index;
    pigeonMap['userAvatars'] = userAvatars;
    pigeonMap['stickerCount'] = stickerCount;
    pigeonMap['companySize'] = companySize;
    pigeonMap['currentSpeed'] = currentSpeed;
    pigeonMap['zoomFactor'] = zoomFactor;
    return pigeonMap;
  }

  static ZnaidyAnnotationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ZnaidyAnnotationOptions(
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      markerType: pigeonMap['markerType'] != null
          ? MarkerType.values[pigeonMap['markerType']! as int]
          : null,
      onlineStatus: pigeonMap['onlineStatus'] != null
          ? OnlineStatus.values[pigeonMap['onlineStatus']! as int]
          : null,
      userAvatars: (pigeonMap['userAvatars'] as List<Object?>?)?.cast<String?>(),
      stickerCount: pigeonMap['stickerCount'] as int?,
      companySize: pigeonMap['companySize'] as int?,
      currentSpeed: pigeonMap['currentSpeed'] as int?,
      zoomFactor: pigeonMap['zoomFactor'] as double?,
    );
  }
}

class _OnZnaidyAnnotationClickListenerCodec extends StandardMessageCodec {
  const _OnZnaidyAnnotationClickListenerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ZnaidyAnnotationOptions) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else
    {
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return ZnaidyAnnotationOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);

    }
  }
}
abstract class OnZnaidyAnnotationClickListener {
  static const MessageCodec<Object?> codec = _OnZnaidyAnnotationClickListenerCodec();

  void onZnaidyAnnotationClick(String annotationId, ZnaidyAnnotationOptions? annotationOptions);
  static void setup(OnZnaidyAnnotationClickListener? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.OnZnaidyAnnotationClickListener.onZnaidyAnnotationClick', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.OnZnaidyAnnotationClickListener.onZnaidyAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_annotationId = (args[0] as String?);
          assert(arg_annotationId != null, 'Argument for dev.flutter.pigeon.OnZnaidyAnnotationClickListener.onZnaidyAnnotationClick was null, expected non-null String.');
          final ZnaidyAnnotationOptions? arg_annotationOptions = (args[1] as ZnaidyAnnotationOptions?);
          api.onZnaidyAnnotationClick(arg_annotationId!, arg_annotationOptions);
          return;
        });
      }
    }
  }
}

class __ZnaidyAnnotationMessagerCodec extends StandardMessageCodec {
  const __ZnaidyAnnotationMessagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ZnaidyAnnotationOptions) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else
    {
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return ZnaidyAnnotationOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);

    }
  }
}

class _ZnaidyAnnotationMessager {
  /// Constructor for [_ZnaidyAnnotationMessager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _ZnaidyAnnotationMessager({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = __ZnaidyAnnotationMessagerCodec();

  Future<String> create(String arg_managerId, ZnaidyAnnotationOptions arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.create', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_annotationOptions]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> update(String arg_managerId, String arg_annotationId, ZnaidyAnnotationOptions arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.update', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_annotationId, arg_annotationOptions]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> delete(String arg_managetId, String arg_annotationId, bool arg_animated) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.delete', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managetId, arg_annotationId, arg_animated]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> select(String arg_managerId, String arg_annotationId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.select', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_annotationId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> resetSelection(String arg_managerId, String arg_annotationId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.resetSelection', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_annotationId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> sendSticker(String arg_managerId, String arg_annotationId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.sendSticker', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_annotationId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setUpdateRate(String arg_managerId, int arg_rate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.setUpdateRate', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_rate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}
