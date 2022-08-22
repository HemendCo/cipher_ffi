import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cipher_ffi_flutter/src/internal_bindings/bridge_generated.dart';

const String _libName = 'cipher_ffi';
typedef KeyPair = RsaKeyPair;

/// The dynamic library in which the symbols for [CipherFfiFlutterBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib_$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final CipherFfiLibImpl _bindings = CipherFfiLibImpl(_dylib);

class RsaPort {
  RsaPort._();
  static Future<RsaKeyPair> generateKey(int keySize) => _bindings.rsaGenerateKey(keySize: keySize);
  static Future<Uint8List> encrypt(Uint8List data, String publicKey) =>
      _bindings.rsaEncrypt(data: data, publicKey: publicKey);
  static Future<Uint8List> decrypt(Uint8List data, String privateKey) =>
      _bindings.rsaDecrypt(data: data, privateKey: privateKey);
}

abstract class AES128Port {
  AES128Port._();

  static Uint8List _currentKey = Uint8List(16);

  static Future<void> updateAesKey(Uint8List key) {
    assert(key.length == 16);
    _currentKey = key;
    return _bindings.aes128UpdateKey(key: key);
  }

  static Future<Uint8List> encrypt(Uint8List data, [Uint8List? key]) {
    if (key != null && key != _currentKey) {
      updateAesKey(key);
    }
    return _bindings.aes128Encrypt(
      data: data,
    );
  }

  static Future<Uint8List> decrypt(Uint8List data, [Uint8List? key]) {
    if (key != null && key != _currentKey) {
      updateAesKey(key);
    }
    return _bindings.aes128Decrypt(
      data: data,
    );
  }
}

abstract class AES256Port {
  AES256Port._();

  static Uint8List _currentKey = Uint8List(32);

  static Future<void> updateAesKey(Uint8List key) {
    assert(key.length == 32);
    _currentKey = key;
    return _bindings.aes256UpdateKey(key: key);
  }

  static Future<Uint8List> encrypt(Uint8List data, [Uint8List? key]) {
    if (key != null && key != _currentKey) {
      updateAesKey(key);
    }
    return _bindings.aes256Encrypt(
      data: data,
    );
  }

  static Future<Uint8List> decrypt(Uint8List data, [Uint8List? key]) {
    if (key != null && key != _currentKey) {
      updateAesKey(key);
    }
    return _bindings.aes256Decrypt(
      data: data,
    );
  }
}
