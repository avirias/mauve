import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mauve/audio.dart';

typedef void TimeChangeHandler(Duration duration);
typedef void ErrorHandler(String message);

class Mauve extends Audio {
  static const MethodChannel _channel = const MethodChannel('mauve');

  Mauve() {
    _channel.setMethodCallHandler(platformCallHandler);
  }

  TimeChangeHandler _durationHandler;
  TimeChangeHandler _positionHandler;
  VoidCallback _startHandler;
  VoidCallback _completionHandler;
  ErrorHandler _errorHandler;


  set durationHandler(TimeChangeHandler value) {
    _durationHandler = value;
  }

  Future platformCallHandler(MethodCall call) {
    switch (call.method) {
      case "audio.onDuration":
        final duration = new Duration(milliseconds: call.arguments);
        if (_durationHandler != null) {
          _durationHandler(duration);
        }
        break;
      case "audio.onCurrentPosition":
        if (_positionHandler != null) {
          _positionHandler(new Duration(milliseconds: call.arguments));
        }
        break;
      case "audio.onStart":
        if (_startHandler != null) {
          _startHandler();
        }
        break;
      case "audio.onComplete":
        if (_completionHandler != null) {
          _completionHandler();
        }
        break;
      case "audio.onError":
        if (_errorHandler != null) {
          _errorHandler(call.arguments);
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
    return null;
  }

  @override
  Future<bool> mute() => _channel.invokeMethod('mute');

  @override
  Future<bool> pause() => _channel.invokeMethod('pause');

  @override
  Future<bool> play({@required String url}) => _channel.invokeMethod('play', url);

  @override
  Future<bool> resume() => _channel.invokeMethod('resume');

  @override
  Future<bool> seek({@required double seconds}) => _channel.invokeMethod('seek', seconds);

  @override
  Future<bool> stop() => _channel.invokeMethod('stop');

  set positionHandler(TimeChangeHandler value) {
    _positionHandler = value;
  }

  set startHandler(VoidCallback value) {
    _startHandler = value;
  }

  set completionHandler(VoidCallback value) {
    _completionHandler = value;
  }

  set errorHandler(ErrorHandler value) {
    _errorHandler = value;
  }
}
