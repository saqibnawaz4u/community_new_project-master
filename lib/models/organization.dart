import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'OrgAdmin.dart';
import 'dart:core';
@JsonSerializable()
class Organization {
  int? Id;
  final String? name;
  final  String? country;
  final String? Email;
  final String? phoneNo;
  final String? description;
  final int? parentId;
  final String? address1;
  final String? address2;
  final String? state;
  final String? city;
  final String? zipCode;
  final String? orgType;
  List<OrgAdmin>? Org_admin = [];
  //List? children;

  Organization({ this.Id,this.name,  this.country,this.Email,
    this.parentId,this.description,this.address1,this.city,this.state,
    this.phoneNo,this.zipCode,this.orgType,this.address2
    //this.children
  })
  {

   print( GetOrgUsersJsonList());
  }

 /* List<String> OrgusersFromJson = [] ;
  var list = json1['users'] as List;
  // Iterable list = json.decode(json1['users']);
  OrgusersFromJson = Orgusers.map((model) => OrgUser.toJson(model)).toList();

  var myUser = organization.toJson();
  var userBody = json.encode(myUser);*/


  GetOrgUsersJsonList()
  {
  //   Iterable listorganizations = json.decode ( response.body);
  //   organizations = listorganizations.map (
  //           (model) => OrgUser. ( model ) ).toList ( );
  // Map<String, dynamic> t=OrgUser
    List<Map<String?,dynamic>> OrgusersFromJson=[] ;
    for(int i=0;i<Org_admin!.length;i++)
      {
        Map<String?, dynamic> myUser = Org_admin![i].toJson();
        var userBody = json.encode(myUser);
        OrgusersFromJson.add(myUser);
      }
    return OrgusersFromJson;

  }


  Organization.WithId({this.Id,this.name,  this.country,this.Email,
    this.parentId,this.description,this.address1,this.city,this.state,
    this.phoneNo,this.zipCode,this.orgType,this.address2,required this.Org_admin
    //this.children
  }){
    //print(jsonEncode("OrgUser :$Orgusers"));
    print('Json String');
    print( GetOrgUsersJsonList());
  }

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);

  factory Organization.fromJsonWithUsers(Map<String, dynamic> json) =>
      _$OrganizationModelFromJsonWithUsers(json);

  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);
  Map<String, dynamic> toJsonwithId() => _$OrganizationModelToJsonwithId(this);
}

Organization _$OrganizationModelFromJson(Map<String, dynamic> json1) {
  return Organization(
      Id: json1['id'],
      name: json1['name'] as String?,
      Email:  json1['email'] as String?,
      country  : json1['country'] as String?,
      phoneNo  : json1['phone1'] as String?,
      description: json1['description'] as String?,
      address1: json1['addressLine1'] as String?,
      address2: json1['addressLine2'] as String?,
      city: json1['city'] as String?,
      parentId: json1['parentId'],
      state: json1['state'] as String?,
      zipCode: json1['postalCode'] as String?,
      orgType: json1['orgType'] as String?

    //  children: json[{'children'}] as List,
  );


}


Organization _$OrganizationModelFromJsonWithUsers(Map<String, dynamic> json1) {
  var org= Organization(
      Id: json1['id'],
    name: json1['name'] as String?,
      Email:  json1['email'] as String?,
      country  : json1['country'] as String?,
      phoneNo  : json1['phone1'] as String?,
    description: json1['description'] as String?,
    address1: json1['addressLine1'] as String?,
      address2: json1['addressLine2'] as String?,
    city: json1['city'] as String?,
    parentId: json1['parentId'],
      state: json1['state'] as String?,
    zipCode: json1['postalCode'] as String?,
  orgType: json1['orgType'] as String?
  //  children: json[{'children'}] as List,
  );
  List<OrgAdmin> OrgusersFromJson = [] ;
  var list = json1['users'] as List;
  // Iterable list = json.decode(json1['users']);
  OrgusersFromJson = list.map((model) => OrgAdmin.fromJson(model)).toList();
  org.Org_admin=OrgusersFromJson;
//print(list.length);
return org;

}

Map<String, dynamic> _$OrganizationModelToJson(Organization instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.Email,
  'country': instance.country,
   'city': instance.city,
    'phone1': instance.phoneNo,
    'parentId' :instance.parentId,
    'description': instance.description,
    'state': instance.state,
   'postalCode': instance.zipCode,
   'addressLine1':instance.address1,
  'addressLine2':instance.address2,
  'orgType':instance.orgType,
  'users':instance.GetOrgUsersJsonList()//jsonEncode(instance.Orgusers)
 // 'children':instance.children

};
Map<String, dynamic> _$OrganizationModelToJsonwithId(Organization instance) =>
    <String, dynamic>{
  'id' : instance.Id,
  'name': instance.name,
  'email': instance.Email,
  'country': instance.country,
  'city': instance.city,
  'phone1': instance.phoneNo,
  'parentId' :instance.parentId,
  'description': instance.description,
  'state': instance.state,
  'postalCode': instance.zipCode,
  'addressLine1':instance.address1,
  'addressLine2':instance.address2,
  'orgType':instance.orgType,
  'users':instance.GetOrgUsersJsonList()
  //'children':instance.children
};