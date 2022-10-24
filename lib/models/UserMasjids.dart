class UserMasjids{
  int? userId;
  int? masjidid;

  UserMasjids({this.masjidid,this.userId});
  //OrgUser.WithId({this.full_name,this.org_id,this.user_id,this.userName});

  factory UserMasjids.fromJson(Map<String?, dynamic> json) =>
      _$UserMasjidsFromJson(json);

  Map<String?, dynamic> toJson() => _$UserMasjidsToJson(this);

//Map<String?, dynamic> toJsonWithId() => _$OrgUserToJsonWithId(this);
}
UserMasjids _$UserMasjidsFromJson(Map<String?, dynamic> json) {
  return UserMasjids(
      userId: json['userId'],
      masjidid:  json['masjidId']
  );}

Map<String, dynamic> _$UserMasjidsToJson(UserMasjids instance) =>
    <String, dynamic>{
      'userId':instance.userId,
      'masjidId': instance.masjidid
    };




