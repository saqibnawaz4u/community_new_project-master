import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()

class Role {
  int? key;
  final String? value;

  Role({ this.key,this.value

  });
  Role.withId({this.value,this.key
  });

  factory Role.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$RoleModelToJsonwithId(this);
}


Role _$RoleModelFromJson(Map<String, dynamic> json) {
  return Role(
    key: json['key'],
    value: json['value'] as String
  );
}

Map<String, dynamic> _$RoleModelToJson(Role instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value

};
Map<String, dynamic> _$RoleModelToJsonwithId(Role instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value
};