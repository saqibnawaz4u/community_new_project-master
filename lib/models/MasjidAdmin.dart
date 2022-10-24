class MasjidAdminModel{
  int? user_Id;
  final String? userName;
  final String? fullName;
  int? masjid_Id;
  MasjidAdminModel({this.masjid_Id,this.user_Id,this.userName,this.fullName});
  //OrgUser.WithId({this.full_name,this.org_id,this.user_id,this.userName});

  factory MasjidAdminModel.fromJson(Map<String?, dynamic> json) =>
      _$MasjidUserFromJson(json);

  Map<String?, dynamic> toJson() => _$MasjidUserToJson(this);

}
MasjidAdminModel _$MasjidUserFromJson(Map<String?, dynamic> json) {
  return MasjidAdminModel(
      masjid_Id: json['masjid_Id'],
      user_Id: json['user_Id'],
      userName: json['userName'] as String?,
      fullName:  json['fullName'] as String?
  );}

Map<String, dynamic> _$MasjidUserToJson(MasjidAdminModel instance) => <String, dynamic>{
  'masjid_Id': instance.masjid_Id,
  'user_Id':instance.user_Id,
  'fullName': instance.fullName,
  'userName': instance.userName
};




