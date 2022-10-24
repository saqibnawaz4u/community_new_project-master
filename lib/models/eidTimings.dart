class EidTimings {
  int? id;
  String? takbeeratTime;
  int? sNo;
  int? masjidId;
  String? lectureTime;
  String? salahTime;
  String? entryDt;
  String? modifiedDt;

  EidTimings({
    this.id,
    this.takbeeratTime,
    this.sNo,
    this.masjidId,
    this.lectureTime,
    this.salahTime,
    this.entryDt,
    this.modifiedDt,
  });

  EidTimings.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    takbeeratTime = json['takbeerat_Time'] as String?;
    sNo = json['sNo'] as int?;
    masjidId = json['masjidId'] as int?;
    lectureTime = json['lecture_Time'] as String?;
    salahTime = json['salah_Time'] as String?;
    entryDt = json['entry_Dt'] as String?;
    modifiedDt = json['modified_Dt'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['takbeerat_Time'] = this.takbeeratTime;
    data['sNo'] = this.sNo;
    data['masjidId'] = this.masjidId;
    data['lecture_Time'] = this.lectureTime;
    data['salah_Time'] = this.salahTime;
    data['entry_Dt'] = this.entryDt;
    data['modified_Dt'] = this.modifiedDt;

    return data;
  }
}
