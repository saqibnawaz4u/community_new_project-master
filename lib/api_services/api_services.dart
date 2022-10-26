import 'dart:async';
import 'dart:convert';
import 'package:community_new/models/accommodationAggrement.dart';
import 'package:community_new/models/accommodationAmenities.dart';
import 'package:community_new/models/accommodationType.dart';
import 'package:community_new/models/rssFeedChangeHistory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/UserEvent.dart';
import '../models/UserMasjids.dart';
import '../models/accommodationPosting.dart';
import '../models/event.dart';
import '../models/masjid.dart';
import '../models/organization.dart';
import '../models/ramadanTimes.dart';
import '../models/role.dart';
import '../models/user.dart';
import '../models/aladhan.dart';

class ApiServices {
  static String baseUrl =
      'http://ijtimaee.com/api'; //'http://192.168.1.7:8040/api';

  //publishedapiurl
  //http://ijtimaee.com/api/CommunityEvent
  static String UserUrl = baseUrl + '/user';
  static String EventUrl = baseUrl + '/communityevent';
  static String MasjidUrl = baseUrl + '/masjid';
  static String endUserMasjidUrl = baseUrl + '/endusermasjids';
  static String endUserEventUrl = baseUrl + '/enduserevents';
  static String RoleUrl = baseUrl + '/role';
  static String OrganizationUrl = baseUrl + '/organization';
  static String accTypeUrl = baseUrl + '/accommodationtype';
  static String agreementTypeUrl = baseUrl + '/accommodationagreement';
  static String amenitiesUrl = baseUrl + '/accommodationamenities';
  static String postingAccommodationUrl = baseUrl + '/accommodationposting';
  static String RamadanTimesUrl = baseUrl + '/ramadantimes';
  static String eidTimingUrl = baseUrl + '/eidtimings';
  static String yearlyTimingUrl = baseUrl + '/yearlyiqamatime';
  static String aladhanUrl = baseUrl +
      '/aladhan/getprayertimecity?city=karachi&country=pakistan&method=5';
  static String RssfeedchangehistoryURl = baseUrl + '/rssfeedchangehistory';
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  //general fetch function
  // static Future fetch(String apiName) async {
  //   Map<String, String> header = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //  // print("$baseUrl/$apiName");
  //   //return null;
  //   return await http.get ( Uri.parse ( "$baseUrl/$apiName", ),headers: header );
  //  // return await http.get ( Uri.parse ( 'http://localhost:8040/api/role' ),headers: header );
  // }

  static Future fetch(String apiName,
      {String? actionName, String? param1, String? param2}) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    // print("$baseUrl/$apiName");
    //return null;
    String strTargetUrl = baseUrl + "/" + apiName;

    if (actionName != null) strTargetUrl = strTargetUrl + "/" + actionName;

    if (param1 != null) strTargetUrl = strTargetUrl + "/" + param1;
    if (param2 != null) strTargetUrl = strTargetUrl + "/" + param2;
    return await http.get(Uri.parse(strTargetUrl), headers: header);

    //   if(actionName==null){
    //   return await http.get ( Uri.parse
    //     ( "$baseUrl/$apiName"),headers : header);
    //   // return await http.get ( Uri.parse ( 'http://localhost:8040/api/role'),
    //     // headers: header );
    // }
    // else{
    //     return await http.get ( Uri.parse
    //       ( "$baseUrl/$apiName/$actionName", ),headers: header );
    //   }
  }

  static Future fetchCodeBook(String apiName,
      {String? tableName, String? codeName}) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    // print("$baseUrl/$apiName");
    //return null;

    if (tableName == null && codeName == null) {
      return await http.get(
          Uri.parse(
            "$baseUrl/$apiName",
          ),
          headers: header);
      // return await http.get ( Uri.parse ( 'http://localhost:8040/api/role' ),headers: header );
    } else {
      return await http.get(
          Uri.parse(
            "$baseUrl/$apiName/$tableName/$codeName",
          ),
          headers: header);
    }
  }

//starting post get update delete of user
  //http get
  // static Future fetchUser() async {
  //   Map<String, String> header = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //   return await http.get ( Uri.parse ( UserUrl, ),headers: header );
  // }

// http get by id
  static Future fetchForEdit(int? id, String apiName) async {
    return await http.get(Uri.parse('$baseUrl/$apiName/$id'));
    // Response res = await http.get ( Uri.parse ( "$UserUrl/$id" ) );
    // return res;
  }

  //http delete
  // Future<void> deleteUser(int id) async {
  //
  //   Response res = await delete ( Uri.parse ( "$UserUrl/$id" ) );
  //     print(res.statusCode);
  //   if (res.statusCode == 200) {
  //     print ( "DELETED" );
  //   } else {
  //     throw "Unable to delete user.";
  //   }
  // }

  //delete
  Future<void> deleteFn(int id, String apiName) async {
    Response res = await delete(Uri.parse("$baseUrl/$apiName/$id"));
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("DELETED");
    } else {
      throw "Unable to delete.";
    }
  }

  Future<void> deleteendUserMaterial(
      String apiName, int id, int? materialId) async {
    Response res = await delete(Uri.parse("$baseUrl/$apiName/$id/$materialId"));
    print(res.statusCode);
    if (res.statusCode == 200) {
      print("DELETED");
    } else {
      throw "Unable to delete.";
    }
  }

//http post
  static Future postUser(User user) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myUser = user.toJson();
    var userBody = json.encode(myUser);
    var res =
        await http.post(Uri.parse(UserUrl), headers: header, body: userBody);
    print(res.statusCode);
    return res.statusCode;
  }

//http update
  static Future postUserbyid(String id, User user) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myUser = user.toJsonwithId();
    var userBody = json.encode(myUser);
    print(userBody);
    var res = await http.put(Uri.parse('$UserUrl/$id'),
        headers: header, body: userBody);
    print("user updated${res.body}");
    return res.statusCode;
  }
//ending post get update delete of user

// accommodation type posting
  static Future postaccType(accommodationType accType) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myAccType = accType.toJson();
    var accTypeBody = json.encode(myAccType);
    var res = await http.post(Uri.parse(accTypeUrl),
        headers: header, body: accTypeBody);
    print(res.statusCode);
    print("acc updated${res.body}");
    return res.statusCode;
  }
//end

  //accommodation agreement type
  static Future postAgreementType(accommodationAgreement agreementType) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myagType = agreementType.toJson();
    var accTypeBody = json.encode(myagType);
    var res = await http.post(Uri.parse(agreementTypeUrl),
        headers: header, body: accTypeBody);
    print(res.statusCode);
    return res.statusCode;
  }
//end

  static Future postAmenitiesType(accommodationAmenities amenitiesType) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myAmenitiesType = amenitiesType.toJson();
    var amenitiesTypeBody = json.encode(myAmenitiesType);
    var res = await http.post(Uri.parse(amenitiesUrl),
        headers: header, body: amenitiesTypeBody);
    print(res.statusCode);
    print("amenities updated${res.body}");
    return res.statusCode;
  }

  //starting post get update delete of event
  // static Future fetchEvent() async {
  //   return await http.get ( Uri.parse ( EventUrl) );
  // }
//post event
  static Future postEvent(Event event) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myEvent = event.toJson();
    print(myEvent);
    var eventBody = json.encode(myEvent);
    var res =
        await http.post(Uri.parse(EventUrl), headers: header, body: eventBody);
    print(res.body);
    return res.statusCode;
  }

  //http update
  static Future postEventbyid(String id, Event event) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myEvent = event.toJsonwithId();
    var eventBody = json.encode(myEvent);
    print(eventBody);
    var res = await http.put(Uri.parse('$EventUrl/$id'),
        headers: header, body: eventBody);
    print("event updated${res.body}");
    return res.statusCode;
  }

//ending post get update delete of user

  //start masjid crud
  // static Future fetchMasjid() async {
  //   return await http.get ( Uri.parse ( 'http://localhost:8040/api/masjid' ) );
  // }
  static Future postMasjid(Masjid masjid) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myMasjid = masjid.toJson();
    var masjidBody = json.encode(myMasjid);
    var res = await http.post(Uri.parse(MasjidUrl),
        headers: header, body: masjidBody);
    print(res.statusCode);
    return res.statusCode;
  }

  static Future postmasjidbyid(String id, Masjid masjid) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myMasjid = masjid.toJsonWithId();
    var masjidBody = json.encode(myMasjid);
    print(masjidBody);
    var res = await http.put(Uri.parse('$MasjidUrl/$id'),
        headers: header, body: masjidBody);
    print("masjid updated${res.body}");
    return res.statusCode;
  }

  static Future postendUsermasjid(UserMasjids endUserMasjid) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myendUserMasjid = endUserMasjid.toJson();
    var masjidBody = json.encode(myendUserMasjid);
    print(masjidBody);
    var res = await http.post(Uri.parse(endUserMasjidUrl),
        headers: header, body: masjidBody);
    return res.statusCode;
  }

  static Future postendUserEvents(UserEvents endUserEvents) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myendUserevent = endUserEvents.toJson();
    var eventBody = json.encode(myendUserevent);
    print(eventBody);
    var res = await http.post(Uri.parse(endUserEventUrl),
        headers: header, body: eventBody);
    return res.statusCode;
  }

  //start of role crud
// http get by id
//   static Future fetchRoleForEdit(int id) async {
//     return await http.get ( Uri.parse ( 'http://localhost:8040/api/role/$id' ) );
//     // Response res = await http.get ( Uri.parse ( "$UserUrl/$id" ) );
//     // return res;
//   }
//http post
  static Future postRole(Role role) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myRole = role.toJson();
    var roleBody = json.encode(myRole);
    var res =
        await http.post(Uri.parse(RoleUrl), headers: header, body: roleBody);
    print(res.statusCode);
    return res.statusCode;
  }

  //http update
  static Future postRolebyid(String id, Role role) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myRole = role.toJsonwithId();
    var roleBody = json.encode(myRole);
    print(roleBody);
    var res = await http.put(Uri.parse('$RoleUrl/$id'),
        headers: header, body: roleBody);
    print("role updated${res.body}");
    return res.statusCode;
  }

  //organization
  //http post
  static Future postOrganization(Organization organization) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myUser = organization.toJson();
    var userBody = json.encode(myUser);
    var res = await http.post(Uri.parse(OrganizationUrl),
        headers: header, body: userBody);
    print(res.statusCode);
    return res.statusCode;
  }

//http update
  static Future postOrganizationbyid(
      String id, Organization organization) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myOrganization = organization.toJsonwithId();
    var organizationBody = json.encode(myOrganization);
    print("before posting: " + organizationBody);
    var res = await http.put(Uri.parse('$OrganizationUrl/$id'),
        headers: header, body: organizationBody);
    print("organization updated${res.body}");
    return res.statusCode;
  }

  // posting accommodation  [POST]
  static Future postAccommodationfn(AccommodationPosting postingAcc) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var mypostingAcc = postingAcc.toJson();
    print(mypostingAcc);
    var eventBody = json.encode(mypostingAcc);
    var res = await http.post(Uri.parse(postingAccommodationUrl),
        headers: header, body: eventBody);
    print(res.body);
    return res.statusCode;
  }

  //posting accommodation [PUT]
  static Future postaccommodationbyid(
      String id, AccommodationPosting accPosting) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var myaccPosting = accPosting.toJsonWithId();
    var myaccPostingBody = json.encode(myaccPosting);
    print("before posting: " + myaccPostingBody);
    var res = await http.put(Uri.parse('$postingAccommodationUrl/$id'),
        headers: header, body: myaccPostingBody);
    print("myaccPostingBody updated${res.body}");
    return res.statusCode;
  }

  // posting ramadanTimes  [POST]
  static Future postRamadanTimes(RamadanTimes ramadantimes) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var postingRamdan = ramadantimes.toJson();
    print(postingRamdan);
    var ramBody = json.encode(postingRamdan);
    var res = await http.post(Uri.parse(RamadanTimesUrl),
        headers: header, body: ramBody);
    print(res.body);
    return res.statusCode;
  }

  // posting rssfeedchangehistory  [POST]
  static Future rssFeedChangeHistory(
      RssFeedChangeHistory rssFeedChangeHistory) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var rssfeedPosting = rssFeedChangeHistory.toJson();
    print(rssfeedPosting);
    var rssfeedBody = json.encode(rssfeedPosting);
    var res = await http.post(Uri.parse(RssfeedchangehistoryURl),
        headers: header, body: rssfeedBody);
    print(res.body);
    return res.statusCode;
  }

  // posting aladhan  [POST]
  static Future alAdhan(Aladhan aladhan) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var adhanPosting = aladhan.toJson();
    print(adhanPosting);
    var adhanBody = json.encode(adhanPosting);
    var res = await http.post(Uri.parse(aladhanUrl),
        headers: header, body: adhanBody);
    print(res.body);
    return res.statusCode;
  }
}
