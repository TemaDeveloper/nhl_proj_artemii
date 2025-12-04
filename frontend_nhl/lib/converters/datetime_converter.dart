import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const DateTimeConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json == null) {
      return DateTime.now();
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime object) => object.toIso8601String();
}