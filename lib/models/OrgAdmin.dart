class OrgAdmin{
  int? user_Id;
  final String? userName;
  final String? fullName;
  int? org_Id;
  OrgAdmin({this.org_Id,this.user_Id,this.userName,this.fullName});
  //OrgUser.WithId({this.full_name,this.org_id,this.user_id,this.userName});

  factory OrgAdmin.fromJson(Map<String?, dynamic> json) =>
      _$OrgUserFromJson(json);

  Map<String?, dynamic> toJson() => _$OrgUserToJson(this);


  //Map<String?, dynamic> toJsonWithId() => _$OrgUserToJsonWithId(this);
}
OrgAdmin _$OrgUserFromJson(Map<String?, dynamic> json) {
  return OrgAdmin(
      org_Id: json['org_Id'],
      user_Id: json['user_Id'],
      userName: json['userName'] as String?,
      fullName:  json['fullName'] as String?
  );}

Map<String, dynamic> _$OrgUserToJson(OrgAdmin instance) => <String, dynamic>{
  'org_Id': instance.org_Id,
  'user_Id':instance.user_Id,
  'fullName': instance.fullName,
  'userName': instance.userName
};




