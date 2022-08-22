import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cipher_ffi_flutter/cipher_ffi_flutter.dart' as cipher_ffi_flutter;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const dummyFileTag = 'assets/dummy.file';
  Future<ByteData> getDummyFileContent = rootBundle.load(dummyFileTag);
  late Uint8List dum;
  @override
  void initState() {
    super.initState();
  }

  Uint8List encrypted = Uint8List.fromList([]);
  cipher_ffi_flutter.KeyPair? keyPair;
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TimerView(),
                TextButton(
                  onPressed: () async {
                    await timer(
                      () => cipher_ffi_flutter.AES128Port.updateAesKey(
                        Uint8List.fromList(
                          List.generate(16, (index) => 15),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'generate key',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    const count = 10000000;
                    // final testFile = Uint8List.fromList(repeat("i", count).codeUnits);
                    dum = Uint8List.fromList([...(await getDummyFileContent).buffer.asUint8List()]);
                    final testFile = dum;

                    // final data = Uint8List.fromList(repeat('|', 215).codeUnits);
                    await timer(() async {
                      encrypted = (await cipher_ffi_flutter.AES128Port.encrypt(testFile));
                    });
                  },
                  child: Text(
                    'test encrypt',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final encValue = await timer(() => cipher_ffi_flutter.AES128Port.decrypt(
                          encrypted,
                        ));
                    // final testFile = base64Decode(String.fromCharCodes(encValue));
                    print('${encValue.length},${dum.length}');
                    for (int i = 0; i < encValue.length; i++) {
                      if (encValue[i] != dum[i]) {
                        print('error at $i');
                      }
                    }
                    print('done');
                  },
                  child: Text(
                    'test decrypt',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({
    Key? key,
  }) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  String timeToShow = '0';
  bool isLoading = false;
  void update() {
    setState(() {
      timeToShow = '${durationView.lastTime}';
      isLoading = durationView.isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    durationView.addListener(update);
  }

  @override
  void dispose() {
    durationView.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          )
        : Text(timeToShow);
  }
}

final durationView = SampleTimer();
Future<T> timer<T>(Future<T> Function() method) async {
  durationView.isLoading = true;
  print('started');
  final start = DateTime.now();
  final result = await method();
  final end = DateTime.now();
  durationView.isLoading = false;
  final dur = end.difference(start).inMilliseconds;
  print('took $dur ms');
  durationView.lastTime = dur;
  return result;
}

String repeat(String input, int repCount) {
  return List.filled(repCount, input).join();
}

class SampleTimer extends ChangeNotifier {
  int _lastTime = 0;

  int get lastTime => _lastTime;

  set lastTime(int lastTime) {
    _lastTime = lastTime;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
