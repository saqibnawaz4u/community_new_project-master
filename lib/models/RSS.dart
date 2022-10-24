
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()

class RSS{
    int? id;
    final String? title;
    final String? user_Name;
    int? source_id;
    final String? rSStype;
    final String? crud;
    //final Event? source_module;
    final String? source_module;
    final String? description;
    final String? entry_date;  //this will be date time type
    final  String? fajr;
    final  String? duhr;
    final  String? asr;
    final  String? maghrib;
    final  String? isha;
    final  String? firstJuma;
    final  String? secondJuma;
    final  String? thirdJuma;
    RSS({this.id,this.source_id,this.source_module,this.crud,this.rSStype,
    this.description,this.entry_date,this.user_Name,
      this.asr,this.fajr,this.duhr,this.isha,this.maghrib,
      this.firstJuma,this.secondJuma,this.thirdJuma,this.title
    });
    RSS.withId({this.id,this.source_id,this.source_module,this.crud,this.rSStype,
      this.description,this.entry_date,this.user_Name,
      this.asr,this.fajr,this.duhr,this.isha,this.maghrib,
      this.firstJuma,this.secondJuma,this.thirdJuma,this.title
    });
    factory RSS.fromJson(Map<String, dynamic> json) =>
        _$RSSModelFromJson(json);

    Map<String, dynamic> toJson() => _$RSSModelToJson(this);
    Map<String, dynamic> toJsonwithId() => _$RSSModelToJsonwithId(this);
}


RSS _$RSSModelFromJson(Map<String, dynamic> json) {
  return RSS(
      id: json['id'],
      user_Name: json['userName'],
      source_id: json['sourceId'],
      description: json['description'],
      crud: json['crud'],
     entry_date: json['entryDate'],
     rSStype: json['rssType'],
     source_module: json['sourceModule'],
    fajr: json['fajr'],
    duhr: json['duhr'],
    asr: json['asr'],
    maghrib: json['maghrib'],
    isha: json['isha'],
    firstJuma: json['firstJuma'],
    secondJuma: json['secondJuma'],
    thirdJuma: json['thirdJuma'],
    title: json['title']
  );
}

Map<String, dynamic> _$RSSModelToJson(RSS instance) => <String, dynamic>{
    'id':instance.id,
     'userName':instance.user_Name,
  'sourceId':instance.source_id,
  'description':instance.description,
  'crud':instance.crud, 'entry_date':instance.entry_date,
  'rssType':instance.rSStype,
  'entryDate':instance.entry_date,
  'sourceModule':instance.source_module,
  'fajr':instance.fajr,
  'duhr': instance.duhr,
  'asr': instance.asr,
  'maghrib': instance.maghrib,
  'isha': instance.isha,
  'firstJuma': instance.firstJuma,
  'secondJuma': instance.secondJuma,
  'thirdJuma':instance.thirdJuma,
  'title':instance.title
};
Map<String, dynamic> _$RSSModelToJsonwithId(RSS instance) => <String, dynamic>{
  'id':instance.id,
  'userName':instance.user_Name,
  'sourceId':instance.source_id,
  'description':instance.description,
  'crud':instance.crud,
  'entryDate':instance.entry_date,
  'rssType':instance.rSStype,
  'sourceModule':instance.source_module,
  'fajr':instance.fajr,
  'duhr': instance.duhr,
  'asr': instance.asr,
  'maghrib': instance.maghrib,
  'isha': instance.isha,
  'firstJuma': instance.firstJuma,
  'secondJuma': instance.secondJuma,
  'thirdJuma':instance.thirdJuma,
  'title':instance.title
};