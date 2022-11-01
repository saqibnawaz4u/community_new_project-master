class UserEvents {
  int? user_Id;
  int? event_Id;
  // final bool? reminder;
  // final DateTime? reminded_time;
  UserEvents({
    this.event_Id,
    // this.reminded_time,
    this.user_Id,
    // this.reminder,
  });
  UserEvents.withId({
    this.event_Id,
    this.user_Id,
    // this.reminded_time,
    // this.reminder,
  });
  //OrgUser.WithId({this.full_name,this.org_id,this.user_id,this.userName});

  factory UserEvents.fromJson(Map<String?, dynamic> json) =>
      _$UserEventsFromJson(json);

  Map<String?, dynamic> toJson() => _$UserEventsToJson(this);
  Map<String?, dynamic> toJsonwithId() => _$UserEventsToJsonwithId(this);

//Map<String?, dynamic> toJsonWithId() => _$OrgUserToJsonWithId(this);
}

UserEvents _$UserEventsFromJson(Map<String?, dynamic> json) {
  return UserEvents(
      // reminded_time: json['reminded_time'],
      user_Id: json['user_Id'],
      // reminder: json['reminder'],
      event_Id: json['event_Id']);
}

Map<String, dynamic> _$UserEventsToJson(UserEvents instance) =>
    <String, dynamic>{
      // 'reminded_time': instance.reminded_time,
      'user_Id': instance.user_Id,
      // 'reminder': instance.reminder,
      'event_Id': instance.event_Id
    };

Map<String, dynamic> _$UserEventsToJsonwithId(UserEvents instance) =>
    <String, dynamic>{
      // 'reminded_time': instance.reminded_time,
      'user_Id': instance.user_Id,
      // 'reminder': instance.reminder,
      'event_Id': instance.event_Id
    };
