part of mapbox_maps_flutter;

class ZnaidyAnnotation {
  ZnaidyAnnotation({
    required this.id,
    this.geometry,
  });

  String id;
  Map<String?, Object?>? geometry;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['id'] = id;
    pigeonMap['geometry'] = geometry;
    return pigeonMap;
  }

  static ZnaidyAnnotation decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ZnaidyAnnotation(
      id: pigeonMap['id']! as String,
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
    );
  }
}

class ZnaidyAnnotationOptions {
  ZnaidyAnnotationOptions({
    this.geometry,
  });

  Map<String?, Object?>? geometry;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['geometry'] = geometry;
    return pigeonMap;
  }

  static ZnaidyAnnotationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ZnaidyAnnotationOptions(
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
    );
  }
}

class _OnZnaidyAnnotationClickListenerCodec extends StandardMessageCodec {
  const _OnZnaidyAnnotationClickListenerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ZnaidyAnnotation) {
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
        return ZnaidyAnnotation.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);

    }
  }
}
abstract class OnZnaidyAnnotationClickListener {
  static const MessageCodec<Object?> codec = _OnZnaidyAnnotationClickListenerCodec();

  void onZnaidyAnnotationClick(ZnaidyAnnotation annotation);
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
          final ZnaidyAnnotation? arg_annotation = (args[0] as ZnaidyAnnotation?);
          assert(arg_annotation != null, 'Argument for dev.flutter.pigeon.OnZnaidyAnnotationClickListener.onZnaidyAnnotationClick was null, expected non-null ZnaidyAnnotation.');
          api.onZnaidyAnnotationClick(arg_annotation!);
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
    if (value is ZnaidyAnnotation) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else
    if (value is ZnaidyAnnotationOptions) {
      buffer.putUint8(129);
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
        return ZnaidyAnnotation.decode(readValue(buffer)!);

      case 129:
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

  Future<ZnaidyAnnotation> create(String arg_managerId, ZnaidyAnnotationOptions arg_annotationOptions) async {
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
      return (replyMap['result'] as ZnaidyAnnotation?)!;
    }
  }

  Future<void> update(String arg_managerId, ZnaidyAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.update', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managerId, arg_annotation]) as Map<Object?, Object?>?;
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

  Future<void> delete(String arg_managetId, ZnaidyAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._ZnaidyAnnotationMessager.delete', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
    await channel.send(<Object?>[arg_managetId, arg_annotation]) as Map<Object?, Object?>?;
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
