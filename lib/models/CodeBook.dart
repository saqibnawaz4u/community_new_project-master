class CodeBook{
  int? id;
  final String? table_Name;
  final String? code_Name;
  final String? code_Value;
  final String? display_Value;

  CodeBook({this.id,this.code_Name,this.code_Value,this.display_Value,
  this.table_Name
  });

  CodeBook.WithId({this.id,this.code_Name,this.code_Value,this.display_Value,
    this.table_Name
  });

  factory CodeBook.fromJson(Map<String, dynamic> json) =>
      _$CodeBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$CodeBookModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$CodeBookModelToJsonwithId(this);
}


CodeBook _$CodeBookModelFromJson(Map<String, dynamic> json) {
  return CodeBook(
      id: json['id'],
      table_Name: json['table_Name'] as String?,
    code_Name: json['code_Name'] as String?,
    code_Value: json['code_Value'] as String?,
    display_Value: json['display_Value'] as String?
  );
}

Map<String, dynamic> _$CodeBookModelToJson(CodeBook instance)
    => <String, dynamic>{
  'table_Name' : instance.table_Name,
  'code_Name' : instance.code_Name,
  'code_Value'  : instance.code_Value,
  'display_Value': instance.display_Value
  // 'children':instance.children

};
Map<String, dynamic> _$CodeBookModelToJsonwithId(CodeBook instance)
      => <String, dynamic>{
  'id' : instance.id,
  'table_Name' : instance.table_Name,
  'code_Name' : instance.code_Name,
  'code_Value'  : instance.code_Value,
  'display_Value': instance.display_Value
};