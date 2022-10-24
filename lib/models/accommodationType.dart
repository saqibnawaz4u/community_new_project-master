import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()

class accommodationType {
  int? id;
  final String? name;
  final String? description;

  accommodationType({ this.name,this.description,this.id

  });
  accommodationType.withId({this.description,this.name,this.id
  });

  factory accommodationType.fromJson(Map<String, dynamic> json) =>
      _$accommodationTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$accommodationTypeModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$accommodationTypeModelToJsonwithId(this);
}


accommodationType _$accommodationTypeModelFromJson(Map<String, dynamic> json) {
  return accommodationType(
      id: json['id'],
      name: json['name'],
      description: json['description'] as String
  );
}

Map<String, dynamic> _$accommodationTypeModelToJson(accommodationType instance) => <String, dynamic>{
  'id':instance.id,
  'name': instance.name,
  'description': instance.description

};
Map<String, dynamic> _$accommodationTypeModelToJsonwithId(accommodationType instance) => <String, dynamic>{
  'id':instance.id,
  'name': instance.name,
  'description': instance.description
};