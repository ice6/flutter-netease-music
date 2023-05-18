import 'package:zan_cloud_music_api/zan_cloud_music_api.dart';

export 'package:zan_cloud_music_api/zan_cloud_music_api.dart' show Answer;

class RequestError implements Exception {
  RequestError({
    required this.code,
    required this.message,
    required this.answer,
  });

  final int code;
  final String message;

  final Answer answer;

  @override
  String toString() => 'RequestError: $code - $message';
}
