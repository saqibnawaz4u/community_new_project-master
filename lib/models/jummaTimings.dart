import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class JummaTimings {
  int? id;
  String? khutbaTime;
  String? effectiveDate;
  int? masjidId;
  String? lectureTime;
  String? iqamaTime;
  String? entryDt;
  String? modifiedDt;

  JummaTimings(
      {this.id,
      this.khutbaTime,
      this.effectiveDate,
      this.masjidId,
      this.lectureTime,
      this.iqamaTime,
      this.entryDt,
      this.modifiedDt});

  JummaTimings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    khutbaTime = json['khutba_Time'];
    effectiveDate = json['effectiveDate'];
    masjidId = json['masjidId'];
    lectureTime = json['lecture_Time'];
    iqamaTime = json['iqama_Time'];
    entryDt = json['entry_Dt'];
    modifiedDt = json['modified_Dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['khutba_Time'] = this.khutbaTime;
    data['effectiveDate'] = this.effectiveDate;
    data['masjidId'] = this.masjidId;
    data['lecture_Time'] = this.lectureTime;
    data['iqama_Time'] = this.iqamaTime;
    data['entry_Dt'] = this.entryDt;
    data['modified_Dt'] = this.modifiedDt;
    return data;
  }
}
