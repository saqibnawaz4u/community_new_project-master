class RamadanTimes {
  int? id;
  String? entryDt;
  String? enteredBy;
  int? sNo;
  int? masjidId;
  String? modifiedDt;
  String? modifiedBy;
  String? startDate;
  String? endDate;
  int? format;

  RamadanTimes({
    this.id,
    this.entryDt,
    this.enteredBy,
    this.masjidId,
    this.sNo,
    this.modifiedDt,
    this.modifiedBy,
    this.startDate,
    this.endDate,
    this.format,
  });

  RamadanTimes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entryDt = json['entry_Dt'];
    enteredBy = json['entered_By'];
    sNo = json['sNo'];
    masjidId = json['masjidId'];
    modifiedDt = json['modified_Dt'];
    modifiedBy = json['modified_By'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entry_Dt'] = this.entryDt;
    data['entered_By'] = this.enteredBy;
    data['sNo'] = this.sNo;
    data['masjidId'] = this.masjidId;
    data['modified_Dt'] = this.modifiedDt;
    data['modified_By'] = this.modifiedBy;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['format'] = this.format;
    return data;
  }
}
