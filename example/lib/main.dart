import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:mauve/mauve.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterAudioQuery _audioQuery;

  @override
  void initState() {
    super.initState();
    _audioQuery = FlutterAudioQuery();
  }

  Future<bool> play(String url) async {
    Mauve mauve = Mauve();
    mauve.play(url: url);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: FutureBuilder(
            future: _audioQuery.getSongs(),
            builder: (context, AsyncSnapshot<List<SongInfo>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  return ListView(
                    children: snapshot.data
                        .map((f) => ListTile(
                              title: Text(f.title),
                              subtitle: Text(f.artist),
                              onTap: () {
                                play(f.filePath);
                              },
                            ))
                        .toList(),
                  );
              }
              return Text('end');
            },
          )),
    );
  }
}
