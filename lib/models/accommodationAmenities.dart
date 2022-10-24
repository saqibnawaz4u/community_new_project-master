import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()

class accommodationAmenities {
  int? id;
  final String? name;
  final String? description;

  accommodationAmenities({ this.name,this.description,this.id

  });
  accommodationAmenities.withId({this.description,this.name,this.id
  });

  factory accommodationAmenities.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$RoleModelToJsonwithId(this);
}


accommodationAmenities _$RoleModelFromJson(Map<String, dynamic> json) {
  return accommodationAmenities(
      id: json['id'],
      name: json['name'],
      description: json['description'] as String
  );
}

Map<String, dynamic> _$RoleModelToJson(accommodationAmenities instance) => <String, dynamic>{
  'id':instance.id,
  'name': instance.name,
  'description': instance.description

};
Map<String, dynamic> _$RoleModelToJsonwithId(accommodationAmenities instance) => <String, dynamic>{
  'id':instance.id,
  'name': instance.name,
  'description': instance.description
};