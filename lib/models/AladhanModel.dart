// To parse this JSON data, do
//
//     final aladhanModel = aladhanModelFromJson(jsonString);

import 'dart:convert';

AladhanModel aladhanModelFromJson(String str) =>
    AladhanModel.fromJson(json.decode(str));

class AladhanModel {
  AladhanModel({
    this.code,
    this.status,
    this.data,
  });

  int? code;
  String? status;
  Data? data;

  factory AladhanModel.fromJson(Map<String, dynamic> json) => AladhanModel(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.timings,
    this.date,
    this.meta,
  });

  Timings? timings;
  Date? date;
  Meta? meta;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        timings:
            json["timings"] == null ? null : Timings.fromJson(json["timings"]),
        date: json["date"] == null ? null : Date.fromJson(json["date"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );
}

class Date {
  Date({
    this.readable,
    this.timestamp,
    this.gregorian,
    this.hijri,
  });

  String? readable;
  String? timestamp;
  Gregorian? gregorian;
  Hijri? hijri;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        readable: json["readable"] == null ? null : json["readable"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        gregorian: json["gregorian"] == null
            ? null
            : Gregorian.fromJson(json["gregorian"]),
        hijri: json["hijri"] == null ? null : Hijri.fromJson(json["hijri"]),
      );
}

class Gregorian {
  Gregorian({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  });

  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  Month? month;
  String? year;
  Designation? designation;

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
        date: json["date"] == null ? null : json["date"],
        format: json["format"] == null ? null : json["format"],
        day: json["day"] == null ? null : json["day"],
        weekday:
            json["weekday"] == null ? null : Weekday.fromJson(json["weekday"]),
        month: json["month"] == null ? null : Month.fromJson(json["month"]),
        year: json["year"] == null ? null : json["year"],
        designation: json["designation"] == null
            ? null
            : Designation.fromJson(json["designation"]),
      );
}

class Designation {
  Designation({
    this.abbreviated,
    this.expanded,
  });

  String? abbreviated;
  String? expanded;

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        abbreviated: json["abbreviated"] == null ? null : json["abbreviated"],
        expanded: json["expanded"] == null ? null : json["expanded"],
      );
}

class Month {
  Month({
    this.number,
    this.en,
    this.ar,
  });

  int? number;
  String? en;
  String? ar;

  factory Month.fromJson(Map<String, dynamic> json) => Month(
        number: json["number"] == null ? null : json["number"],
        en: json["en"] == null ? null : json["en"],
        ar: json["ar"] == null ? null : json["ar"],
      );
}

class Weekday {
  Weekday({
    this.en,
    this.ar,
  });

  String? en;
  String? ar;

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
        en: json["en"] == null ? null : json["en"],
        ar: json["ar"] == null ? null : json["ar"],
      );
}

class Hijri {
  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
  });

  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  Month? month;
  String? year;
  Designation? designation;
  List<dynamic>? holidays;

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
        date: json["date"] == null ? null : json["date"],
        format: json["format"] == null ? null : json["format"],
        day: json["day"] == null ? null : json["day"],
        weekday:
            json["weekday"] == null ? null : Weekday.fromJson(json["weekday"]),
        month: json["month"] == null ? null : Month.fromJson(json["month"]),
        year: json["year"] == null ? null : json["year"],
        designation: json["designation"] == null
            ? null
            : Designation.fromJson(json["designation"]),
        holidays: json["holidays"] == null
            ? null
            : List<dynamic>.from(json["holidays"].map((x) => x)),
      );
}

class Meta {
  Meta({
    this.latitude,
    this.longitude,
    this.timezone,
    this.method,
    this.latitudeAdjustmentMethod,
    this.midnightMode,
    this.school,
    this.offset,
  });

  double? latitude;
  double? longitude;
  String? timezone;
  Method? method;
  String? latitudeAdjustmentMethod;
  String? midnightMode;
  String? school;
  Map<String, int>? offset;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        timezone: json["timezone"] == null ? null : json["timezone"],
        method: json["method"] == null ? null : Method.fromJson(json["method"]),
        latitudeAdjustmentMethod: json["latitudeAdjustmentMethod"] == null
            ? null
            : json["latitudeAdjustmentMethod"],
        midnightMode:
            json["midnightMode"] == null ? null : json["midnightMode"],
        school: json["school"] == null ? null : json["school"],
        offset: json["offset"] == null
            ? null
            : Map.from(json["offset"])
                .map((k, v) => MapEntry<String, int>(k, v)),
      );
}

class Method {
  Method({
    this.id,
    this.name,
    this.params,
    this.location,
  });

  int? id;
  String? name;
  Params? params;
  Location? location;

  factory Method.fromJson(Map<String, dynamic> json) => Method(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        params: json["params"] == null ? null : Params.fromJson(json["params"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );
}

class Location {
  Location({
    this.latitude,
    this.longitude,
  });

  double? latitude;
  double? longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
      );
}

class Params {
  Params({
    this.fajr,
    this.isha,
  });

  double? fajr;
  double? isha;

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        fajr: json["fajr"] == null ? null : json["fajr"].toDouble(),
        isha: json["isha"] == null ? null : json["isha"].toDouble(),
      );
}

class Timings {
  Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  String? firstthird;
  String? lastthird;

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        fajr: json["fajr"] == null ? null : json["fajr"],
        sunrise: json["sunrise"] == null ? null : json["sunrise"],
        dhuhr: json["dhuhr"] == null ? null : json["dhuhr"],
        asr: json["asr"] == null ? null : json["asr"],
        sunset: json["sunset"] == null ? null : json["sunset"],
        maghrib: json["maghrib"] == null ? null : json["maghrib"],
        isha: json["isha"] == null ? null : json["isha"],
        imsak: json["imsak"] == null ? null : json["imsak"],
        midnight: json["midnight"] == null ? null : json["midnight"],
        firstthird: json["firstthird"] == null ? null : json["firstthird"],
        lastthird: json["lastthird"] == null ? null : json["lastthird"],
      );
}
