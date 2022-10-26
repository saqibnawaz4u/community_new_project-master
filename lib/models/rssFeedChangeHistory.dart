class RssFeedChangeHistory {
  int? id;
  int? rssFeedId;
  String? moduleName;
  String? fieldName;
  String? oldValue;
  String? newValue;

  RssFeedChangeHistory(
      {this.id,
      this.rssFeedId,
      this.moduleName,
      this.fieldName,
      this.oldValue,
      this.newValue});

  RssFeedChangeHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rssFeedId = json['rssFeedId'];
    moduleName = json['moduleName'];
    fieldName = json['fieldName'];
    oldValue = json['oldValue'];
    newValue = json['newValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rssFeedId'] = this.rssFeedId;
    data['moduleName'] = this.moduleName;
    data['fieldName'] = this.fieldName;
    data['oldValue'] = this.oldValue;
    data['newValue'] = this.newValue;
    return data;
  }
}
