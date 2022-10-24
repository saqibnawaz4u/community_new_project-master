class UserInfo{
  int? user_Id;
  final String? userName;
 List<String>? fav_masajids;
 List<String>? reg_events;
  UserInfo({this.fav_masajids,this.reg_events,
    this.user_Id,this.userName});
  //OrgUser.WithId({this.full_name,this.org_id,this.user_id,this.userName});

  factory UserInfo.fromJson(Map<String?, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$UserInfoToJson(this);


//Map<String?, dynamic> toJsonWithId() => _$OrgUserToJsonWithId(this);
}
UserInfo _$UserInfoFromJson(Map<String?, dynamic> json) {
  return UserInfo(
      fav_masajids: json['fav_masajids'],
      user_Id: json['user_Id'],
      userName: json['userName'] as String?,
      reg_events:  json['reg_events']
  );}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'fav_masajids': instance.fav_masajids,
  'user_Id':instance.user_Id,
  'reg_events': instance.reg_events,
  'userName': instance.userName
};




