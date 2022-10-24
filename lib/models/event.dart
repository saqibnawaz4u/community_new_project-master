import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
// "photo": "",
// "name": "Ali",
// "location": "Daruslammshdgh 12",
// "startDate": null,
// "startTime": "",
// "endDate": null,
// "endTime": "",
// "description": "An event 233",
// "intPublic": 1,
// "fullName": "abv23",
// "masjidId": 7,

class Event {
  int? Id;
  //final String? photo = "";
  final String? name;
  final String? location ;
   final  String? startDate ;
  // final DateTime? startTime ;
   //final String? endDate ;
  // final DateTime? endTime ;
  //final  String? startDate ;
  final String? startTime ;
  final String? endDate ;
  final String? endTime ;
  final String? description ;
  //final int? intPublic = 1;
  final int? masjiId;
  final String? fullName;
  final String? eDocLink;

  Event({ this.masjiId,this.name,this.Id,this.location,this.startTime,this.startDate,this.endTime,this.endDate,
this.description,this.fullName,this.eDocLink

  });
  Event.withId({this.masjiId,this.name,this.Id,this.location,this.startTime,this.startDate,this.endTime,this.endDate,
    this.description,this.fullName,this.eDocLink
  });

  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$EventModelToJsonwithId(this);
}


Event _$EventModelFromJson(Map<String, dynamic> json) {
  return Event(
      Id: json['id'] ,
     // fullName: json['fullName'] as String?,
      fullName: json['fullName'] as String?,
     // photo: json['photo'] as String,
      masjiId: json['masjidId'],
      name: json['name'] as String?,
      location: json['location'] as String?,
      startDate:  json['startDate'] as String?,
      startTime:  json['startTime'] as String?,
      endDate: json['endDate'] as String?,
      endTime: json['endTime'] as String? ,
      eDocLink: json['eDocLink'],
    // startDate:  json['startDate'] as DateTime?,
    // startTime:  json['startTime'] as DateTime?,
    // endDate: json['endDate'] as DateTime?,
    // endTime: json['endTime'] as DateTime? ,
      description:  json['description'] as String?,
  );
}

Map<String, dynamic> _$EventModelToJson(Event instance) => <String, dynamic>{
  'name' : instance.name,
  'fullName': instance.fullName,
  'location': instance.location,
  'startDate': instance.startDate,
  'startTime': instance.startTime,
  'endDate': instance.endDate,
  'endTime' : instance.endTime,
   'description' : instance.description,
    'masjidId': instance.masjiId,
  'eDocLink':instance.eDocLink


};
Map<String, dynamic> _$EventModelToJsonwithId(Event instance) => <String, dynamic>{
  'name' : instance.name,
  'id' : instance.Id,
  'fullName': instance.fullName,
  'location': instance.location,
  'startDate':instance.startDate,
  'startTime': instance.startTime,
  'endDate': instance.endDate,
  'endTime' : instance.endTime,
  'description' : instance.description,
  'masjidId': instance.masjiId,
  'eDocLink':instance.eDocLink
};