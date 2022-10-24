import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../UI SCREENS/Menues/MasjidAdmin.dart';
import 'MasjidAdmin.dart';



@JsonSerializable()
class Masjid {
  final  String? AddressLine1;
  final  String? AddressLine2;
  final  String? Asr;
  final  int? capacity;
  final  String? City;
  final  String? Country;
  final  DateTime? daylightSaving_EndDate;
  final  DateTime? daylightSaving_startDate;
  final  String? Description;
  final  String? Duhr;
  final  String? Email;
  final  String? EnteredBy;
  final  DateTime? EntryDate;
  final  String? Fajr;
  final  String? Fax;
  final  String? FirstJuma;
  final  int? Id;
  final int? Org_Id;
  final  String? Isha;
  final  String? Latitude;
  final  String? Location;
  final  String? Longitude;
  final  String? Maghrib;
  final  String? ModifiedBy;
  final  DateTime? ModifiedDate;
  final  String? Name;
  final  String? Phone1;
  final  String? Phone1Type;
  final  String? Phone2;
  final  String? Phone2Type;
  final  String? PostalCode;
  final  String? SecondJuma;
  final  String? State;
  final  String? ThirdJuma;
  List<MasjidAdminModel> Masjid_admin = [] ;



  Masjid({this.AddressLine1,this.AddressLine2,this.Asr,this.capacity,this.City,this.Country,this.daylightSaving_EndDate,
    this.daylightSaving_startDate,this.Description,this.Duhr,this.Email,this.EnteredBy,this.EntryDate,this.Fajr,
    this.Fax,this.FirstJuma,this.Id,this.Isha,this.Latitude,this.Location,this.Longitude,this.Maghrib,this.ModifiedBy,
    this.ModifiedDate,this.Name,this.Phone1,this.Phone1Type,this.Phone2,this.Phone2Type,this.PostalCode,
    this.SecondJuma,this.State,this.ThirdJuma,this.Org_Id});

  GetMasjidUsersJsonList()
  {
    List<Map<String?,dynamic>> MasjidusersFromJson=[] ;
    for(int i=0;i<Masjid_admin.length;i++)
    {
      Map<String?, dynamic> myUser = Masjid_admin[i].toJson();
      var userBody = json.encode(myUser);
      MasjidusersFromJson.add(myUser);
    }
    return MasjidusersFromJson;

  }
  Masjid.WithId({this.Id,this.AddressLine1,this.AddressLine2,this.Asr,this.capacity,this.City,this.Country,this.daylightSaving_EndDate,
    this.daylightSaving_startDate,this.Description,this.Duhr,this.Email,this.EnteredBy,this.EntryDate,this.Fajr,
    this.Fax,this.FirstJuma,this.Isha,this.Latitude,this.Location,this.Longitude,this.Maghrib,this.ModifiedBy,
    this.ModifiedDate,this.Name,this.Phone1,this.Phone1Type,this.Phone2,this.Phone2Type,this.PostalCode,
    this.SecondJuma,this.State,this.ThirdJuma,this.Org_Id,
    required this.Masjid_admin});

  factory Masjid.fromJson(Map<String?, dynamic> json) =>
      _$MasjidFromJson(json);

  factory Masjid.fromJsonWithUsers(Map<String, dynamic> json) =>
      _$MasjidFromJsonWithUser(json);

  Map<String?, dynamic> toJson() => _$MasjidToJson(this);

  Map<String?, dynamic> toJsonWithId() => _$MasjidToJsonWithId(this);

}

Masjid _$MasjidFromJson(Map<String?, dynamic> json) {
  return Masjid(
      Id: json['id'] as  int? ,
      Org_Id: json['org_Id'] as int?,
      AddressLine1: json['AddressLine1'] as  String? ,
      AddressLine2: json['AddressLine2'] as  String? ,
      Asr: json['asr'] as  String? ,
      capacity: json['capacity'] as  int?,
      City: json['city'] as  String? ,
      Country: json['country'] as  String? ,
      daylightSaving_EndDate: json['daylightSaving_EndDate'] as  DateTime? ,
      daylightSaving_startDate: json['daylightSaving_startDate'] as  DateTime? ,
      Description: json['description'] as  String? ,
      Duhr: json['duhr'] as  String? ,
      Email: json['email'] as  String? ,
      EnteredBy: json['EnteredBy'] as  String? ,
      EntryDate: json['EntryDate'] as  DateTime? ,
      Fajr: json['fajr'] as  String? ,
      Fax: json['Fax'] as  String? ,
      FirstJuma: json['FirstJuma'] as  String? ,
      Isha: json['isha'] as  String? ,
      Latitude: json['Latitude'] as  String? ,
      Location: json['location'] as  String? ,
      Longitude: json['Longitude'] as  String? ,
      Maghrib: json['maghrib'] as  String? ,
      ModifiedBy: json['ModifiedBy'] as  String? ,
      ModifiedDate: json['ModifiedDate'] as  DateTime? ,
      Name: json['name'] as  String? ,
      Phone1: json['phone1'] as  String? ,
      Phone1Type: json['Phone1Type'] as  String? ,
      Phone2: json['Phone2'] as  String? ,
      Phone2Type: json['Phone2Type'] as  String? ,
      PostalCode: json['postalCode'] as  String? ,
      SecondJuma: json['SecondJuma'] as  String? ,
      State: json['state'] as  String? ,
      ThirdJuma: json['ThirdJuma'] as  String? ,

  );
}

Masjid _$MasjidFromJsonWithUser(Map<String, dynamic> json) {
  var masjid= Masjid(
    Id: json['id'] as  int? ,
    Org_Id: json['org_Id'] as int?,
    AddressLine1: json['AddressLine1'] as  String? ,
    AddressLine2: json['AddressLine2'] as  String? ,
    Asr: json['asr'] as  String? ,
    capacity: json['capacity'] as  int?,
    City: json['city'] as  String? ,
    Country: json['country'] as  String? ,
    daylightSaving_EndDate: json['daylightSaving_EndDate'] as  DateTime? ,
    daylightSaving_startDate: json['daylightSaving_startDate'] as  DateTime? ,
    Description: json['description'] as  String? ,
    Duhr: json['duhr'] as  String? ,
    Email: json['email'] as  String? ,
    EnteredBy: json['EnteredBy'] as  String? ,
    EntryDate: json['EntryDate'] as  DateTime? ,
    Fajr: json['fajr'] as  String? ,
    Fax: json['Fax'] as  String? ,
    FirstJuma: json['FirstJuma'] as  String? ,

    Isha: json['isha'] as  String? ,
    Latitude: json['Latitude'] as  String? ,
    Location: json['location'] as  String? ,
    Longitude: json['Longitude'] as  String? ,
    Maghrib: json['maghrib'] as  String? ,
    ModifiedBy: json['ModifiedBy'] as  String? ,
    ModifiedDate: json['ModifiedDate'] as  DateTime? ,
    Name: json['name'] as  String? ,
    Phone1: json['phone1'] as  String? ,
    Phone1Type: json['Phone1Type'] as  String? ,
    Phone2: json['Phone2'] as  String? ,
    Phone2Type: json['Phone2Type'] as  String? ,
    PostalCode: json['postalCode'] as  String? ,
    SecondJuma: json['SecondJuma'] as  String? ,
    State: json['state'] as  String? ,
    ThirdJuma: json['ThirdJuma'] as  String? ,

  );
  List<MasjidAdminModel> MasjidusersFromJson = [] ;
  var list = json['users'] as List;
  MasjidusersFromJson = list.map((model) =>MasjidAdminModel.fromJson(model)).toList();
  masjid.Masjid_admin=MasjidusersFromJson;
//print(list.length);
  return masjid;
}


Map<String?, dynamic> _$MasjidToJson(Masjid instance) => <String?, dynamic>{
  'org_Id':instance.Org_Id,
  'AddressLine1': instance.AddressLine1,

  'AddressLine2': instance.AddressLine2,
  'Asr': instance.Asr,
  'capacity': instance.capacity,
  'City': instance.City,
  'Country': instance.Country,
  'daylightSaving_EndDate': instance.daylightSaving_EndDate,
  'daylightSaving_startDate': instance.daylightSaving_startDate,
  'Description': instance.Description,
  'Duhr': instance.Duhr,
  'Email': instance.Email,
  'EnteredBy': instance.EnteredBy,
  'EntryDate': instance.EntryDate,
  'fajr': instance.Fajr,
  'Fax': instance.Fax,
  'FirstJuma': instance.FirstJuma,
  'Isha': instance.Isha,
  'Latitude': instance.Latitude,
  'Location': instance.Location,
  'Longitude': instance.Longitude,
  'Maghrib': instance.Maghrib,
  'ModifiedBy': instance.ModifiedBy,
  'ModifiedDate': instance.ModifiedDate,
  'Name': instance.Name,
  'Phone1': instance.Phone1,
  'Phone1Type': instance.Phone1Type,
  'Phone2': instance.Phone2,
  'Phone2Type': instance.Phone2Type,
  'PostalCode': instance.PostalCode,
  'SecondJuma': instance.SecondJuma,
  'State': instance.State,
  'ThirdJuma': instance.ThirdJuma,
  'users':[]
};

Map<String?, dynamic> _$MasjidToJsonWithId(Masjid instance) => <String?, dynamic>{
  'Id': instance.Id,
  'org_Id':instance.Org_Id,
  'AddressLine1': instance.AddressLine1,
  'AddressLine2': instance.AddressLine2,
  'Asr': instance.Asr,
  'capacity': instance.capacity,
  'City': instance.City,
  'Country': instance.Country,
  'daylightSaving_EndDate': instance.daylightSaving_EndDate,
  'daylightSaving_startDate': instance.daylightSaving_startDate,
  'Description': instance.Description,
  'Duhr': instance.Duhr,
  'Email': instance.Email,
  'EnteredBy': instance.EnteredBy,
  'EntryDate': instance.EntryDate,
  'Fajr': instance.Fajr,
  'Fax': instance.Fax,
  'FirstJuma': instance.FirstJuma,
  'Isha': instance.Isha,
  'Latitude': instance.Latitude,
  'Location': instance.Location,
  'Longitude': instance.Longitude,
  'Maghrib': instance.Maghrib,
  'ModifiedBy': instance.ModifiedBy,
  'ModifiedDate': instance.ModifiedDate,
  'Name': instance.Name,
  'Phone1': instance.Phone1,
  'Phone1Type': instance.Phone1Type,
  'Phone2': instance.Phone2,
  'Phone2Type': instance.Phone2Type,
  'PostalCode': instance.PostalCode,
  'SecondJuma': instance.SecondJuma,
  'State': instance.State,
  'ThirdJuma': instance.ThirdJuma,
  'users':instance.GetMasjidUsersJsonList()
};