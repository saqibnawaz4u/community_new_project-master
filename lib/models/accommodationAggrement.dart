import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()

class accommodationAgreement {
  int? id;
  int? monthDuration;
  int? reocurring;
  final String? title;
  final String? description;

  accommodationAgreement({ this.title,this.description,this.id,this.monthDuration,this.reocurring

  });
  accommodationAgreement.withId({this.title,this.description,this.id,this.monthDuration,this.reocurring
  });

  factory accommodationAgreement.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$RoleModelToJsonwithId(this);
}


accommodationAgreement _$RoleModelFromJson(Map<String, dynamic> json) {
  return accommodationAgreement(
      id: json['id'],
      monthDuration: json['monthDuration'],
      reocurring: json['reocurring'],
      title: json['title'],
      description: json['description'] as String
  );
}

Map<String, dynamic> _$RoleModelToJson(accommodationAgreement instance) => <String, dynamic>{
  'id':instance.id,
  'reocurring':instance.reocurring,
  'monthDuration':instance.monthDuration,
  'title': instance.title,
  'description': instance.description

};
Map<String, dynamic> _$RoleModelToJsonwithId(accommodationAgreement instance) => <String, dynamic>{
  'id':instance.id,
  'reocurring':instance.reocurring,
  'monthDuration':instance.monthDuration,
  'title': instance.title,
  'description': instance.description
};