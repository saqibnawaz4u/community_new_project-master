// class Aladhan {
//   int? code;
//   String? status;
//   Data? data;
//
//   Aladhan({this.code, this.status, this.data});
//
//   Aladhan.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     status = json['status'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   Timings? timings;
//   Date? date;
//   Meta? meta;
//
//   Data({this.timings, this.date, this.meta});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     timings =
//         json['timings'] != null ? new Timings.fromJson(json['timings']) : null;
//     date = json['date'] != null ? new Date.fromJson(json['date']) : null;
//     meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.timings != null) {
//       data['timings'] = this.timings!.toJson();
//     }
//     if (this.date != null) {
//       data['date'] = this.date!.toJson();
//     }
//     if (this.meta != null) {
//       data['meta'] = this.meta!.toJson();
//     }
//     return data;
//   }
// }
//
// class Timings {
//   String? fajr;
//   String? sunrise;
//   String? dhuhr;
//   String? asr;
//   String? sunset;
//   String? maghrib;
//   String? isha;
//   String? imsak;
//   String? midnight;
//   String? firstthird;
//   String? lastthird;
//
//   Timings(
//       {this.fajr,
//       this.sunrise,
//       this.dhuhr,
//       this.asr,
//       this.sunset,
//       this.maghrib,
//       this.isha,
//       this.imsak,
//       this.midnight,
//       this.firstthird,
//       this.lastthird});
//
//   Timings.fromJson(Map<String, dynamic> json) {
//     fajr = json['fajr'];
//     sunrise = json['sunrise'];
//     dhuhr = json['dhuhr'];
//     asr = json['asr'];
//     sunset = json['sunset'];
//     maghrib = json['maghrib'];
//     isha = json['isha'];
//     imsak = json['imsak'];
//     midnight = json['midnight'];
//     firstthird = json['firstthird'];
//     lastthird = json['lastthird'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fajr'] = this.fajr;
//     data['sunrise'] = this.sunrise;
//     data['dhuhr'] = this.dhuhr;
//     data['asr'] = this.asr;
//     data['sunset'] = this.sunset;
//     data['maghrib'] = this.maghrib;
//     data['isha'] = this.isha;
//     data['imsak'] = this.imsak;
//     data['midnight'] = this.midnight;
//     data['firstthird'] = this.firstthird;
//     data['lastthird'] = this.lastthird;
//     return data;
//   }
// }
//
// class Date {
//   String? readable;
//   String? timestamp;
//   Gregorian? gregorian;
//   Hijri? hijri;
//
//   Date({this.readable, this.timestamp, this.gregorian, this.hijri});
//
//   Date.fromJson(Map<String, dynamic> json) {
//     readable = json['readable'];
//     timestamp = json['timestamp'];
//     gregorian = json['gregorian'] != null
//         ? new Gregorian.fromJson(json['gregorian'])
//         : null;
//     hijri = json['hijri'] != null ? new Hijri.fromJson(json['hijri']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['readable'] = this.readable;
//     data['timestamp'] = this.timestamp;
//     if (this.gregorian != null) {
//       data['gregorian'] = this.gregorian!.toJson();
//     }
//     if (this.hijri != null) {
//       data['hijri'] = this.hijri!.toJson();
//     }
//     return data;
//   }
// }
//
// class Gregorian {
//   String? date;
//   String? format;
//   String? day;
//   Weekday? weekday;
//   Month? month;
//   String? year;
//   Designation? designation;
//
//   Gregorian(
//       {this.date,
//       this.format,
//       this.day,
//       this.weekday,
//       this.month,
//       this.year,
//       this.designation});
//
//   Gregorian.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     format = json['format'];
//     day = json['day'];
//     weekday =
//         json['weekday'] != null ? new Weekday.fromJson(json['weekday']) : null;
//     month = json['month'] != null ? new Month.fromJson(json['month']) : null;
//     year = json['year'];
//     designation = json['designation'] != null
//         ? new Designation.fromJson(json['designation'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     data['format'] = this.format;
//     data['day'] = this.day;
//     if (this.weekday != null) {
//       data['weekday'] = this.weekday!.toJson();
//     }
//     if (this.month != null) {
//       data['month'] = this.month!.toJson();
//     }
//     data['year'] = this.year;
//     if (this.designation != null) {
//       data['designation'] = this.designation!.toJson();
//     }
//     return data;
//   }
// }
//
// class Weekday {
//   String? en;
//   Null? ar;
//
//   Weekday({this.en, this.ar});
//
//   Weekday.fromJson(Map<String, dynamic> json) {
//     en = json['en'];
//     ar = json['ar'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['en'] = this.en;
//     data['ar'] = this.ar;
//     return data;
//   }
// }
//
// class Month {
//   int? number;
//   String? en;
//   Null? ar;
//
//   Month({this.number, this.en, this.ar});
//
//   Month.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     en = json['en'];
//     ar = json['ar'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['number'] = this.number;
//     data['en'] = this.en;
//     data['ar'] = this.ar;
//     return data;
//   }
// }
//
// class Designation {
//   String? abbreviated;
//   String? expanded;
//
//   Designation({this.abbreviated, this.expanded});
//
//   Designation.fromJson(Map<String, dynamic> json) {
//     abbreviated = json['abbreviated'];
//     expanded = json['expanded'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['abbreviated'] = this.abbreviated;
//     data['expanded'] = this.expanded;
//     return data;
//   }
// }
//
// class Hijri {
//   String? date;
//   String? format;
//   String? day;
//   Weekday? weekday;
//   Month? month;
//   String? year;
//   Designation? designation;
//   List<String>? holidays;
//
//   Hijri(
//       {this.date,
//       this.format,
//       this.day,
//       this.weekday,
//       this.month,
//       this.year,
//       this.designation,
//       this.holidays});
//
//   Hijri.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     format = json['format'];
//     day = json['day'];
//     weekday =
//         json['weekday'] != null ? new Weekday.fromJson(json['weekday']) : null;
//     month = json['month'] != null ? new Month.fromJson(json['month']) : null;
//     year = json['year'];
//     designation = json['designation'] != null
//         ? new Designation.fromJson(json['designation'])
//         : null;
//     holidays = json['holidays'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     data['format'] = this.format;
//     data['day'] = this.day;
//     if (this.weekday != null) {
//       data['weekday'] = this.weekday!.toJson();
//     }
//     if (this.month != null) {
//       data['month'] = this.month!.toJson();
//     }
//     data['year'] = this.year;
//     if (this.designation != null) {
//       data['designation'] = this.designation!.toJson();
//     }
//     data['holidays'] = this.holidays;
//     return data;
//   }
// }
//
// // class Weekday {
// //   String? en;
// //   String? ar;
//
// //   Weekday({this.en, this.ar});
//
// //   Weekday.fromJson(Map<String, dynamic> json) {
// //     en = json['en'];
// //     ar = json['ar'];
// //   }
//
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['en'] = this.en;
// //     data['ar'] = this.ar;
// //     return data;
// //   }
// // }
//
// // class Month {
// //   int? number;
// //   String? en;
// //   String? ar;
//
// //   Month({this.number, this.en, this.ar});
//
// //   Month.fromJson(Map<String, dynamic> json) {
// //     number = json['number'];
// //     en = json['en'];
// //     ar = json['ar'];
// //   }
//
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['number'] = this.number;
// //     data['en'] = this.en;
// //     data['ar'] = this.ar;
// //     return data;
// //   }
// // }
//
// class Meta {
//   double? latitude;
//   double? longitude;
//   String? timezone;
//   Method? method;
//   String? latitudeAdjustmentMethod;
//   String? midnightMode;
//   String? school;
//   Offset? offset;
//
//   Meta(
//       {this.latitude,
//       this.longitude,
//       this.timezone,
//       this.method,
//       this.latitudeAdjustmentMethod,
//       this.midnightMode,
//       this.school,
//       this.offset});
//
//   Meta.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     timezone = json['timezone'];
//     method =
//         json['method'] != null ? new Method.fromJson(json['method']) : null;
//     latitudeAdjustmentMethod = json['latitudeAdjustmentMethod'];
//     midnightMode = json['midnightMode'];
//     school = json['school'];
//     offset =
//         json['offset'] != null ? new Offset.fromJson(json['offset']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['timezone'] = this.timezone;
//     if (this.method != null) {
//       data['method'] = this.method!.toJson();
//     }
//     data['latitudeAdjustmentMethod'] = this.latitudeAdjustmentMethod;
//     data['midnightMode'] = this.midnightMode;
//     data['school'] = this.school;
//     if (this.offset != null) {
//       data['offset'] = this.offset!.toJson();
//     }
//     return data;
//   }
// }
//
// class Method {
//   int? id;
//   String? name;
//   Params? params;
//   Location? location;
//
//   Method({this.id, this.name, this.params, this.location});
//
//   Method.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     params =
//         json['params'] != null ? new Params.fromJson(json['params']) : null;
//     location = json['location'] != null
//         ? new Location.fromJson(json['location'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     if (this.params != null) {
//       data['params'] = this.params!.toJson();
//     }
//     if (this.location != null) {
//       data['location'] = this.location!.toJson();
//     }
//     return data;
//   }
// }
//
// class Params {
//   double? fajr;
//   double? isha;
//
//   Params({this.fajr, this.isha});
//
//   Params.fromJson(Map<String, dynamic> json) {
//     fajr = json['fajr'];
//     isha = json['isha'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fajr'] = this.fajr;
//     data['isha'] = this.isha;
//     return data;
//   }
// }
//
// class Location {
//   double? latitude;
//   double? longitude;
//
//   Location({this.latitude, this.longitude});
//
//   Location.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     return data;
//   }
// }
//
// class Offset {
//   int? imsak;
//   int? fajr;
//   int? sunrise;
//   int? dhuhr;
//   int? asr;
//   int? maghrib;
//   int? sunset;
//   int? isha;
//   int? midnight;
//
//   Offset(
//       {this.imsak,
//       this.fajr,
//       this.sunrise,
//       this.dhuhr,
//       this.asr,
//       this.maghrib,
//       this.sunset,
//       this.isha,
//       this.midnight});
//
//   Offset.fromJson(Map<String, dynamic> json) {
//     imsak = json['imsak'];
//     fajr = json['fajr'];
//     sunrise = json['sunrise'];
//     dhuhr = json['dhuhr'];
//     asr = json['asr'];
//     maghrib = json['maghrib'];
//     sunset = json['sunset'];
//     isha = json['isha'];
//     midnight = json['midnight'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['imsak'] = this.imsak;
//     data['fajr'] = this.fajr;
//     data['sunrise'] = this.sunrise;
//     data['dhuhr'] = this.dhuhr;
//     data['asr'] = this.asr;
//     data['maghrib'] = this.maghrib;
//     data['sunset'] = this.sunset;
//     data['isha'] = this.isha;
//     data['midnight'] = this.midnight;
//     return data;
//   }
// }





import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Aladhan{
  final String? status;
  Data? data;
  Aladhan({this.status, this.data});
  factory Aladhan.fromJson(Map<String, dynamic> parsedJson){
    return Aladhan(
      data:Data.fromJson(parsedJson['data']),
    );
  }
  Map<String, dynamic> toJson() => _$AladhanToJson(this);
  Map<String, dynamic> _$AladhanToJson(Aladhan instance) => <String, dynamic>{
    'data': instance.data,
  };
}
class Data {
  Timings? timings;
  Meta? meta;
  Data({this.timings,this.meta
  });
  factory Data.fromJson(Map<String, dynamic> parsedJson){
    return Data(
        timings:Timings.fromJson(parsedJson['timings']),
        meta: Meta.fromJson(parsedJson['meta'])
    );
  }
}

class Timings {
  String? fajr;
  String? dhuhr;
  String? asr;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  String? firstthird;
  String? lastthird;

  Timings({ this.fajr,this.dhuhr,this.asr,this.maghrib,
    this.isha,this.imsak,this.midnight,this.firstthird,this.lastthird});

  factory Timings.fromJson(Map<String, dynamic> json) =>
      _$TimingsFromJson(json);

  Map<String, dynamic> toJson() => _$TimingsToJson(this);
}
Timings _$TimingsFromJson(Map<String, dynamic> json) {
  return Timings(
    fajr: json['fajr'],
    dhuhr: json['dhuhr'] ,
    asr:json['asr'],
    maghrib: json['maghrib'],
    isha: json['isha'],
    imsak: json['imsak'],
    midnight: json['midnight'],
    firstthird: json['firstthird'],
    lastthird: json['lastthird'],
  );
}
Map<String, dynamic> _$TimingsToJson(Timings instance) => <String, dynamic>{
  'fajr': instance.fajr,
  'dhuhr': instance.dhuhr,
  'asr':instance.asr,
  'maghrib': instance.maghrib,
  'isha':instance.isha
};



class Meta {
  String? timezone;


  Meta({ this.timezone});

  factory Meta.fromJson(Map<String, dynamic> json) =>
      _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    timezone: json['timezone'],
  );
}
Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'timezone': instance.timezone,
};



