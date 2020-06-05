import 'package:flutter/cupertino.dart';

abstract class Audio {
  Future<bool> play({@required String url});

  Future<bool> pause();

  Future<bool> stop();

  Future<bool> mute();

  Future<bool> seek({@required double seconds});

  Future<bool> resume();
}
