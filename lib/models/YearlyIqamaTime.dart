import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class YearlyIqamaTime {
  int? id;
  String? dateRange;
  int? year;
  int? month;
  int? day;
  final String? monthName;
  final String? fajar;
  final String? zuhar;
  final String? asr;
  final String? maghrib;
  final String? isha;
  final String? firstJuma;
  final String? secondJuma;
  final String? thirdJuma;
  final int? masjidId;

  YearlyIqamaTime(
      {this.id,
      this.masjidId,
      this.fajar,
      this.zuhar,
      this.asr,
      this.maghrib,
      this.isha,
      this.dateRange,
      this.day,
      this.month,
      this.year,
      this.firstJuma,
      this.secondJuma,
      this.thirdJuma,
      this.monthName});
  YearlyIqamaTime.withId(
      {this.id,
      this.masjidId,
      this.fajar,
      this.zuhar,
      this.asr,
      this.maghrib,
      this.isha,
      this.dateRange,
      this.day,
      this.month,
      this.year,
      this.firstJuma,
      this.secondJuma,
      this.thirdJuma,
      this.monthName});

  factory YearlyIqamaTime.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$RoleModelToJsonwithId(this);
}

YearlyIqamaTime _$RoleModelFromJson(Map<String, dynamic> json) {
  return YearlyIqamaTime(
      id: json['id'],
      dateRange: json['dateRange'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
      fajar: json['fajar'],
      zuhar: json['zuhar'],
      asr: json['asr'],
      maghrib: json['maghrib'],
      isha: json['isha'],
      firstJuma: json['firstJuma'],
      secondJuma: json['secondJuma'],
      thirdJuma: json['thirdJuma'],
      masjidId: json['masjidId'],
      monthName: json['monthName']);
}

Map<String, dynamic> _$RoleModelToJson(YearlyIqamaTime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateRange': instance.dateRange,
      'day': instance.day,
      'month': instance.month,
      'year': instance.year,
      'fajar': instance.fajar,
      'zuhar': instance.zuhar,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
      'firstJuma': instance.firstJuma,
      'secondJuma': instance.secondJuma,
      'thirdJuma': instance.thirdJuma,
      'masjidId': instance.masjidId,
      'monthName': instance.monthName
    };
Map<String, dynamic> _$RoleModelToJsonwithId(YearlyIqamaTime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateRange': instance.dateRange,
      'day': instance.day,
      'month': instance.month,
      'year': instance.year,
      'fajar': instance.fajar,
      'zuhar': instance.zuhar,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
      'firstJuma': instance.firstJuma,
      'secondJuma': instance.secondJuma,
      'thirdJuma': instance.thirdJuma,
      'masjidId': instance.masjidId,
      'monthName': instance.monthName
    };