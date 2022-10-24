
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class User {
  int? Id;
   final String? UserName ;
  final  String? FullName ;
  final String? Email ;
  final String? PublicEmail ;
  final String? Password ;
  final String? ConfirmPassword ;
  int? default_Role_Id;
  final  String? default_Role_Name;
   int? org_id;
   int? masjid_id;

  User({ this.Id,this.UserName,this.FullName,this.Email,
    this.PublicEmail,this.Password,this.ConfirmPassword,this.default_Role_Id,
  this.default_Role_Name,this.org_id,this.masjid_id
  });

  User.WithId({this.Id,this.UserName,  this.FullName,this.Email,
    this.PublicEmail,this.Password,this.ConfirmPassword,this.default_Role_Id,
    this.default_Role_Name,this.org_id,this.masjid_id
  })
  {
    print(" Ins Side User " + default_Role_Id.toString());
  }
  //;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$UserModelToJsonwithId(this);
}


User _$UserModelFromJson(Map<String, dynamic> json) {
  return User(
      Id: json['id'],
      org_id: json['org_id'] as int?,
      masjid_id: json['masjid_id'] as int?,
      UserName: json['userName'] as String?,
      FullName:  json['fullName'] as String?,
      Email:  json['email'] as String?,
      PublicEmail: json['publicEmail'] as String?,
      Password: json['password'] as String?,
      ConfirmPassword:  json['confirmPassword'] as String?,
      default_Role_Id: json['default_Role_Id'],
      default_Role_Name: json['default_Role_Name'],

  );
}

Map<String, dynamic> _$UserModelToJson(User instance) => <String, dynamic>{
  'FullName': instance.FullName,
  'UserName': instance.UserName,
  'Email': instance.Email,
  'PublicEmail': instance.PublicEmail,
  'Password' : instance.Password,
  'ConfirmPassword' :instance.ConfirmPassword,
  'default_Role_Id': instance.default_Role_Id,
  'default_Role_Name': instance.default_Role_Name,
  'org_id': instance.org_id,
  'masjid_id':instance.masjid_id,
};
Map<String, dynamic> _$UserModelToJsonwithId(User instance) => <String, dynamic>{
  'Id' : instance.Id,
  'FullName': instance.FullName,
  'UserName': instance.UserName,
  'Email': instance.Email,
  'PublicEmail': instance.PublicEmail,
  'Password' : instance.Password,
  'ConfirmPassword' :instance.ConfirmPassword,
  'default_Role_Id': instance.default_Role_Id,
  'default_Role_Name': instance.default_Role_Name,
  'org_id': instance.org_id,
  'masjid_id':instance.masjid_id,
};