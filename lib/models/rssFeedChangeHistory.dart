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
    rssFeedId = json['RssFeedId'];
    moduleName = json['ModuleName'];
    fieldName = json['FieldName'];
    oldValue = json['OldValue'];
    newValue = json['NewValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['RssFeedId'] = this.rssFeedId;
    data['ModuleName'] = this.moduleName;
    data['FieldName'] = this.fieldName;
    data['OldValue'] = this.oldValue;
    data['NewValue'] = this.newValue;
    return data;
  }
}
