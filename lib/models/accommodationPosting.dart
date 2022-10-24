import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AccommodationPosting {
  final int? id;
  final int? rent;
  final int? sizeInSqft;
  final int? noofBedrooms;
  final double? noofBathrooms;
  final String? utilitiesIncluded;
  final String? furnished;
  final String? description;
  final String? appliances;
  final String? petFriendly;
  final String? barrier_free_entrancesAndRamps;
  final String? visualAids;
  final String? accessibleWashroomsInSuite;
  final int? advancePayment;
  final String? personalOutdoorSpace;
  final String? smokingPermitted;
  final String? location;
  final String? forRentBy;
  final String? photo;
  final String? city;
  final String? title;
  final String? state;
  final String? streetAddress;
  final String? country;
  final String? zipCode;
  final int? phoneNumber;
  final int? accommodationType_Id;
  final int? aggreementType_id;

  AccommodationPosting({
    this.id,
    this.rent,
    this.location,
    this.description,
    this.accessibleWashroomsInSuite,
    this.accommodationType_Id,
    this.advancePayment,
    this.aggreementType_id,
    this.appliances,
    this.barrier_free_entrancesAndRamps,
    this.forRentBy,
    this.furnished,
    this.noofBathrooms,
    this.noofBedrooms,
    this.personalOutdoorSpace,
    this.petFriendly,
    this.photo,
    this.sizeInSqft,
    this.smokingPermitted,
    this.utilitiesIncluded,
    this.visualAids,
    this.title,
    this.phoneNumber,
    this.city,
    this.state,
    this.country,
    this.streetAddress,
    this.zipCode,
  });

  // GetAccommodationtypeIdJsonList()
  // {
  //   List<Map<String?,dynamic>> accommodationType_IdFromJson=[] ;
  //   for(int i=0;i<accommodationType_Id!.length;i++)
  //   {
  //     Map<String?, dynamic> myUser = accommodationType_Id![i].toJson();
  //     var userBody = json.encode(myUser);
  //     accommodationType_IdFromJson.add(myUser);
  //   }
  //   return accommodationType_IdFromJson;
  //
  // }
  // GetAccommodationagreementJsonList()
  // {
  //   List<Map<String?,dynamic>> aggreementType_idFromJson=[] ;
  //   for(int i=0;i<aggreementType_id!.length;i++)
  //   {
  //     Map<String?, dynamic> myUser = aggreementType_id![i].toJson();
  //     var userBody = json.encode(myUser);
  //     aggreementType_idFromJson.add(myUser);
  //   }
  //   return aggreementType_idFromJson;
  //
  // }

  AccommodationPosting.WithId({
    this.id,
    this.rent,
    this.location,
    this.description,
    this.accessibleWashroomsInSuite,
    this.accommodationType_Id,
    this.advancePayment,
    this.aggreementType_id,
    this.appliances,
    this.barrier_free_entrancesAndRamps,
    this.forRentBy,
    this.furnished,
    this.noofBathrooms,
    this.noofBedrooms,
    this.personalOutdoorSpace,
    this.petFriendly,
    this.photo,
    this.sizeInSqft,
    this.smokingPermitted,
    this.utilitiesIncluded,
    this.visualAids,
    this.title,
    this.phoneNumber,
    this.city,
    this.state,
    this.country,
    this.streetAddress,
    this.zipCode,
  });

  factory AccommodationPosting.fromJson(Map<String?, dynamic> json) =>
      _$AccommodationPostingFromJson(json);

  Map<String?, dynamic> toJson() =>
      _$_$AccommodationPostingFromJsonToJson(this);

  Map<String?, dynamic> toJsonWithId() =>
      _$_$AccommodationPostingFromJsonToJsonWithId(this);
}

AccommodationPosting _$AccommodationPostingFromJson(
    Map<String?, dynamic> json) {
  return AccommodationPosting(
    id: json['id'] as int?,
    description: json['description'],
    rent: json['rent'],
    accessibleWashroomsInSuite: json['accessibleWashroomsInSuite'],
    accommodationType_Id: json['accommodationType_Id'],
    advancePayment: json['advancePayment'],
    aggreementType_id: json['aggreementType_id'],
    appliances: json['appliances'],
    barrier_free_entrancesAndRamps: json['barrier_free_entrancesAndRamps'],
    forRentBy: json['forRentBy'],
    furnished: json['furnished'],
    //noofBathrooms:  json['noofBathrooms'] // /,
    noofBathrooms: json['noofBathrooms'] is int
        ? (json['noofBathrooms'] as int).toDouble()
        : json['noofBathrooms'],
    noofBedrooms: json['noofBedrooms'],
    personalOutdoorSpace: json['personalOutdoorSpace'],
    petFriendly: json['petFriendly'],
    location: json['location'],
    photo: json['photo'],
    sizeInSqft: json['sizeInSqft'],
    smokingPermitted: json['smokingPermitted'],
    utilitiesIncluded: json['utilitiesIncluded'],
    visualAids: json['visualAids'],
    city: json['city'],
    country: json['country'],
    phoneNumber: json['phoneNumber'],
    state: json['state'],
    streetAddress: json['streetAddress'],
    title: json['title'],
    zipCode: json['zipcode'],
  );
}

Map<String?, dynamic> _$_$AccommodationPostingFromJsonToJson(
        AccommodationPosting instance) =>
    <String?, dynamic>{
      'rent': instance.rent,
      'id': instance.id,
      'visualAids': instance.visualAids,
      'utilitiesIncluded': instance.utilitiesIncluded,
      'smokingPermitted': instance.smokingPermitted,
      'sizeInSqft': instance.sizeInSqft,
      'photo': instance.photo,
      'petFriendly': instance.petFriendly,
      'description': instance.description,
      'personalOutdoorSpace': instance.personalOutdoorSpace,
      'noofBedrooms': instance.noofBedrooms,
      'noofBathrooms': instance.noofBathrooms,
      'furnished': instance.furnished,
      'forRentBy': instance.forRentBy,
      'barrier_free_entrancesAndRamps': instance.barrier_free_entrancesAndRamps,
      'appliances': instance.appliances,
      'accommodationType_Id': instance.accommodationType_Id,
      'aggreementType_id': instance.aggreementType_id,
      'advancePayment': instance.advancePayment,
      'location': instance.location,
      'accessibleWashroomsInSuite': instance.accessibleWashroomsInSuite,
      'city': instance.city,
      'title': instance.title,
      'state': instance.state,
      'streetAddress': instance.streetAddress,
      'country': instance.country,
      'zipCode': instance.zipCode,
      'phoneNumber': instance.phoneNumber
    };

Map<String?, dynamic> _$_$AccommodationPostingFromJsonToJsonWithId(
        AccommodationPosting instance) =>
    <String?, dynamic>{
      'rent': instance.rent,
      'id': instance.id,
      'visualAids': instance.visualAids,
      'utilitiesIncluded': instance.utilitiesIncluded,
      'smokingPermitted': instance.smokingPermitted,
      'sizeInSqft': instance.sizeInSqft,
      'photo': instance.photo,
      'petFriendly': instance.petFriendly,
      'description': instance.description,
      'personalOutdoorSpace': instance.personalOutdoorSpace,
      'noofBedrooms': instance.noofBedrooms,
      'noofBathrooms': instance.noofBathrooms,
      'furnished': instance.furnished,
      'forRentBy': instance.forRentBy,
      'barrier_free_entrancesAndRamps': instance.barrier_free_entrancesAndRamps,
      'appliances': instance.appliances,
      'accommodationType_Id': instance.accommodationType_Id,
      'aggreementType_id': instance.aggreementType_id,
      'advancePayment': instance.advancePayment,
      'location': instance.location,
      'accessibleWashroomsInSuite': instance.accessibleWashroomsInSuite,
    };
