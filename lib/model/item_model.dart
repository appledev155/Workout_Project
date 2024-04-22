/* import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ItemModel extends Equatable {
  final int id;
  final String propertyKey;
  final String price;
  final String nameEnglish;
  final String nameArabic;
  final String type;
  final String location;
  final String locationAr;
  final List amenities;
  final int bedrooms;
  final int toilet;
  final String areaUnit;
  final String areaSqft;
  final String areaSqm;
  final String areaSqyd;
  final String propertyImage;
  final List propertyImagesArray;
  final String propertyType;
  final String propertyStatus;
  final String purpose;
  final String buildYear;
  final String descriptionArebic;
  final String descriptionEnglish;
  final String dbType;
  final String roleId;
  final String agencyImage;
  final String agencyName;
  final String agencyAddress;
  final String propertyAddedBy;
  final String userPhoneNumber;
  final int status;

  const ItemModel({
    this.id,
    this.propertyKey,
    this.price,
    this.nameEnglish,
    this.nameArabic,
    this.type,
    this.location,
    this.locationAr,
    this.amenities,
    this.bedrooms,
    this.toilet,
    this.areaUnit,
    this.areaSqm,
    this.areaSqft,
    this.areaSqyd,
    this.propertyImage,
    this.propertyImagesArray,
    this.propertyType,
    this.propertyStatus,
    this.purpose,
    this.buildYear,
    this.descriptionArebic,
    this.descriptionEnglish,
    this.dbType,
    this.roleId,
    this.agencyImage,
    this.agencyName,
    this.agencyAddress,
    this.propertyAddedBy,
    this.userPhoneNumber,
    this.status,
  });

  @override
  List<Object> get props => [
        id,
        propertyKey,
        price,
        nameEnglish,
        nameArabic,
        type,
        location,
        locationAr,
        amenities,
        bedrooms,
        toilet,
        areaUnit,
        areaSqm,
        areaSqft,
        areaSqyd,
        propertyImage,
        propertyImagesArray,
        propertyType,
        propertyStatus,
        purpose,
        buildYear,
        descriptionArebic,
        descriptionEnglish,
        dbType,
        roleId,
        agencyImage,
        agencyName,
        agencyAddress,
        propertyAddedBy,
        userPhoneNumber,
        status,
      ];

  @override
  String toString() => '{id: $id,status:$status}';

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      propertyKey: json['propertyKey'] as String,
      price: json['price'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameArabic: json['nameArabic'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      locationAr: json['locationAr'] as String,
      amenities: json['amenities'] as List,
      bedrooms: json['bedrooms'] as int,
      toilet: json['toilet'] as int,
      areaUnit: json['areaUnit'] as String,
      areaSqm: json['areaSqm'] as String,
      areaSqft: json['areaSqft'] as String,
      areaSqyd: json['areaSqyd'] as String,
      propertyImage: json['propertyImage'] as String,
      propertyImagesArray: json['propertyImagesArray'] as List,
      propertyType: json['propertyType'] as String,
      propertyStatus: json['propertyStatus'] as String,
      purpose: json['purpose'] as String,
      buildYear: json['buildYear'] as String,
      descriptionArebic: json['descriptionArebic'] as String,
      descriptionEnglish: json['descriptionEnglish'] as String,
      dbType: json['dbType'] as String,
      roleId: json['roleId'] as String,
      agencyImage: json['agencyImage'] as String,
      agencyName: json['agencyName'] as String,
      agencyAddress: json['agencyAddress'] as String,
      propertyAddedBy: json['propertyAddedBy'] as String,
      userPhoneNumber: json['userPhoneNumber'] as String,
      status: json['status'] as int,
    );
  }

  factory ItemModel.recJson(Map<String, dynamic> rec, stdCode) {
    //final _host =  env['HOST'];
    String propertyImage;
    String s3pathPropertiesPath, s3pathPropertiesPathMember, s3pathAgencyPath;
    String imagePath;
    String userPhoneNumber = '';
    String imageName = '';
    int listId = 0;
    final _propertyImageList = [];

    String s3URL = dotenv.env['S3URL'];

    s3pathPropertiesPath = s3URL + '/fit-in/400x0/assets/properties/';
    s3pathPropertiesPathMember =
        s3URL + '/fit-in/400x0/assets/properties_member/';
    s3pathAgencyPath = s3URL + '/fit-in/80x60/assets/users/agency_profile/';

    if (rec['db_type'] == 'admin') {
      imagePath = "$s3pathPropertiesPath";
    } else {
      imagePath = "$s3pathPropertiesPathMember";
    }

    if (rec['property_image'] != null) {
      imageName = rec['property_image'];
      listId = rec['id'];
      if (rec['db_type'] == 'admin') {
        propertyImage = "$s3pathPropertiesPath$listId/property/$imageName";
      } else {
        propertyImage =
            "$s3pathPropertiesPathMember$listId/property/$imageName";
      }
    }
    /* else {
      propertyImage = 'https://' + _host + '/images/skyblue/pro1.jpg';
      imagePath = 'https://' + _host + '/images/skyblue/';
    } */

    if (rec.containsKey("get_prop_images")) {
      rec['get_prop_images'].forEach((element) {
        if (element['path'] != null)
          _propertyImageList.add(imagePath + element['path']);
      });
    }
    if (rec.containsKey("get_floor_images")) {
      rec['get_floor_images'].forEach((element) {
        if (element['path'] != null) {
          if (propertyImage == null) {
            propertyImage = imagePath + element['path'];
          }
          _propertyImageList.add(imagePath + element['path']);
        }
      });
    }

    if (rec.containsKey("user_phoneNumber")) {
      String phoneNumber = stdCode + rec['user_phoneNumber'];
      userPhoneNumber = phoneNumber.replaceAll(stdCode + '0', stdCode);
    }

    return ItemModel(
      id: rec['id'],
      propertyKey: rec['property_key'],
      price: rec['price'],
      nameEnglish: rec['prop_name_1'],
      nameArabic: rec['prop_name_2'],
      type: rec['property_type_name'],
      location: rec['location'],
      locationAr: rec['location_ar'],
      amenities: (rec.containsKey("get_amenity"))
          ? rec['get_amenity']['amenityArr']
          : [],
      bedrooms: rec['bedrooms'],
      toilet: rec['toilet'],
      areaUnit: rec['property_area_unit'].toString(),
      areaSqft: rec['property_area_sqft'].toString(),
      areaSqm: rec['property_area_sqm'].toString(),
      areaSqyd: rec['property_area_sqyd'].toString(),
      propertyImage: propertyImage,
      propertyImagesArray: _propertyImageList,
      propertyType: rec['property_type'].toString(),
      propertyStatus: rec['property_status'].toString(),
      purpose: rec['purpose'],
      buildYear: rec['build_year'].toString(),
      descriptionArebic: (rec.containsKey("description_arebic"))
          ? rec['description_arebic']
          : '',
      descriptionEnglish: (rec.containsKey("description_english"))
          ? rec['description_english']
          : '',
      dbType: rec['db_type'],
      status: rec['status'],
      roleId: rec['role_id'].toString(),
      agencyImage: (rec.containsKey("agency_image"))
          ? s3pathAgencyPath + rec['agency_image']
          : '',
      agencyName: (rec.containsKey("agency_name")) ? rec['agency_name'] : '',
      agencyAddress:
          (rec.containsKey("agency_address")) ? rec['agency_address'] : '',
      propertyAddedBy: (rec.containsKey("property_added_by"))
          ? rec['property_added_by']
          : '',
      userPhoneNumber: userPhoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyKey': propertyKey,
      'status': status,
      'price': price,
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'type': type,
      'location': location,
      'locationAr': locationAr,
      'amenities': amenities,
      'bedrooms': bedrooms,
      'toilet': toilet,
      'areaUnit': areaUnit,
      'areaSqm': areaSqm,
      'areaSqft': areaSqft,
      'areaSqyd': areaSqyd,
      'propertyImage': propertyImage,
      'propertyImagesArray': propertyImagesArray,
      'propertyType': propertyType,
      'propertyStatus': propertyStatus,
      'purpose': purpose,
      'buildYear': buildYear,
      'descriptionArebic': descriptionArebic,
      'descriptionEnglish': descriptionEnglish,
      'dbType': dbType,
      'roleId': roleId,
      'agencyImage': agencyImage,
      'agencyName': agencyName,
      'agencyAddress': agencyAddress,
      'propertyAddedBy': propertyAddedBy,
      'userPhoneNumber': userPhoneNumber
    };
  }
}

class ItemImages {
  final List<String> images;

  ItemImages.fromJson(Map json) : images = json['property_images'] as List;

  String toString() => 'Images array $this.images';
}
 */

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ItemModel {
  final int? id, isAgent, userId, agencyId;
  final String? propertyKey;
  final String? price;
  final String? nameEnglish;
  final String? nameArabic;
  final String? type;
  final String? location;
  final String? locationAr;
  final List? amenities;
  final dynamic bedrooms;
  final int? toilet;
  final String? areaUnit;
  final String? areaSqft;
  final String? areaSqm;
  final String? areaSqyd;
  final String? propertyImage, rowImage;
  final List? propertyImagesArray, galleryImagesArray;
  final String? propertyType;
  final String? propertyStatus;
  final String? purpose;
  final String? buildYear;
  final String? descriptionArebic;
  final String? descriptionEnglish;
  final String? dbType;
  final String? roleId;
  final String? agencyImage;
  final String? agencyName, agencyNameAr;
  final String? agencyAddress;
  final String? propertyAddedBy;
  final String? userPhoneNumber, slug, priceType;
  final dynamic status;

  const ItemModel(
      {this.id,
      this.userId,
      this.isAgent,
      this.propertyKey,
      this.price,
      this.nameEnglish,
      this.nameArabic = '',
      this.type,
      this.location,
      this.locationAr,
      this.amenities,
      this.bedrooms,
      this.toilet,
      this.areaUnit,
      this.areaSqm,
      this.areaSqft,
      this.areaSqyd,
      this.propertyImage,
      this.propertyImagesArray,
      this.galleryImagesArray,
      this.rowImage,
      this.propertyType,
      this.propertyStatus,
      this.purpose,
      this.buildYear,
      this.descriptionArebic,
      this.descriptionEnglish,
      this.dbType,
      this.roleId,
      this.agencyImage,
      this.agencyName,
      this.agencyNameAr,
      this.agencyAddress,
      this.propertyAddedBy,
      this.userPhoneNumber,
      this.status,
      this.slug,
      this.priceType,
      this.agencyId});

  List<Object> get props => [
        id!,
        userId!,
        isAgent!,
        propertyKey!,
        price!,
        nameEnglish!,
        nameArabic!,
        type!,
        location!,
        locationAr!,
        amenities!,
        bedrooms!,
        toilet!,
        areaUnit!,
        areaSqm!,
        areaSqft!,
        areaSqyd!,
        propertyImage!,
        propertyImagesArray!,
        rowImage!,
        propertyType!,
        propertyStatus!,
        purpose!,
        buildYear!,
        descriptionArebic!,
        descriptionEnglish!,
        dbType!,
        roleId!,
        agencyImage!,
        agencyName!,
        agencyNameAr!,
        agencyAddress!,
        propertyAddedBy!,
        userPhoneNumber!,
        status!,
        slug!,
        priceType!,
        galleryImagesArray!,
        agencyId!
      ];

  @override
  String toString() {
    return '{"id": $id, "user_id": $userId, "isAgent" : $isAgent, "propertyKey" : "$propertyKey", "price": "$price", "nameEnglish": "$nameEnglish", "nameArabic": "$nameArabic", "type": "$type", "location": "$location", "locationAr" : "$locationAr", "amenities": ${jsonEncode(amenities)}, "bedrooms": $bedrooms, "toilet": $toilet, "areaUnit" : "$areaUnit", "areaSqm" : "$areaSqm", "areaSqft" : "$areaSqft", "areaSqyd" : "$areaSqyd", "propertyImage" : "$propertyImage", "propertyImagesArray" : ${jsonEncode(propertyImagesArray)}, "rowImage" : "$propertyImage", "propertyType" : "$propertyType", "propertyStatus" : "$propertyStatus", "purpose" : "$purpose", "buildYear" : "$buildYear", "descriptionArebic" : "$descriptionArebic", "descriptionEnglish" : "$descriptionEnglish", "dbType" : "$dbType", "roleId" : "$roleId",  "agencyImage" : "$agencyImage",  "agencyName" : "$agencyName", "agencyNameAr" : "$agencyNameAr", "agencyAddress" : "$agencyAddress", "propertyAddedBy" : "$propertyAddedBy",  "userPhoneNumber" : "$userPhoneNumber", "status" : "$status", "slug" : "$slug", "priceType" : "$priceType", "galleryImagesArray" : ${jsonEncode(propertyImagesArray)},  "agencyId" : $agencyId}';
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
        id: json['id'] ?? 0,
        propertyKey: json['propertyKey'] ?? '',
        price: json['price'].toString(),
        nameEnglish: json['nameEnglish'] ?? '',
        nameArabic: json['nameArabic'] ?? '',
        type: json['type'] ?? '',
        location: json['location'] ?? '',
        locationAr: json['locationAr'] ?? '',
        amenities:
            (json.containsKey('amenities')) ? json['amenities'] : [] as List,
        bedrooms: json['bedrooms'] ?? 0 as int,
        toilet: json['toilet'] ?? 0 as int,
        areaUnit: json['areaUnit'] ?? '',
        areaSqm: json['areaSqm'] ?? '',
        areaSqft: json['areaSqft'] ?? '',
        areaSqyd: json['areaSqyd'] ?? '',
        propertyImage: json['propertyImage'] ?? '',
        propertyImagesArray: (json.containsKey('propertyImagesArray'))
            ? json['propertyImagesArray']
            : [] as List,
        propertyType: json['propertyType'] ?? '',
        propertyStatus: json['propertyStatus'] ?? '',
        purpose: json['purpose'] ?? '',
        buildYear: json['buildYear'] ?? '',
        descriptionEnglish: json['descriptionEnglish'] ?? '',
        descriptionArebic: json['descriptionArebic'] ?? '',
        dbType: json['dbType'] ?? '',
        roleId: json['roleId'] ?? '',
        agencyImage: json['agencyImage'] ?? '',
        agencyName: json['agencyName'] ?? '',
        agencyAddress: json['agencyAddress'] ?? '',
        propertyAddedBy: json['propertyAddedBy'] ?? '',
        userId: json['user_id'] ?? 0,
        userPhoneNumber: json['userPhoneNumber'] ?? '',
        status: json['status'],
        slug: json['slug'] ?? '',
        agencyId: json['agency_id'] ?? 0);
  }

  factory ItemModel.recJson(Map<String, dynamic> rec, stdCode) {
    // print(rec);
    //final _host =  env['HOST'];
    String? propertyImage;
    String? s3pathPropertiesPath, s3pathPropertiesPathMember, s3pathAgencyPath;
    String? imagePath, galleryPath, galleryPathMember, imageViewPath;
    String? userPhoneNumber = '';
    String? imageName = '', rowImageUrl = '';
    int listId = 0;
    final _propertyImageList = [], _galleryList = [];

    String? s3URL = dotenv.env['S3URL'];

    s3pathPropertiesPath = '${s3URL!}/fit-in/1000x1000/assets/properties/';
    s3pathPropertiesPathMember =
        '$s3URL/fit-in/1000x1000/assets/properties_member/';
    galleryPath = '$s3URL/fit-in/400x0/assets/properties/';
    galleryPathMember = '$s3URL/fit-in/400x0/assets/properties_member/';

    s3pathAgencyPath = '$s3URL/fit-in/80x60/assets/users/agency_profile/';

    if (rec['db_type'] == 'admin') {
      imagePath = s3pathPropertiesPath;
      imageViewPath = galleryPath;
    } else {
      imagePath = s3pathPropertiesPathMember;
      imageViewPath = galleryPathMember;
    }

    if (rec['property_image'] != null) {
      imageName = rec['property_image'];
      listId = rec['id'];
      if (rec['db_type'] == 'admin') {
        propertyImage = "$s3pathPropertiesPath$listId/property/$imageName";

        rowImageUrl =
            '$s3URL/fit-in/400x0/assets/properties/$listId/property/$imageName';
      } else {
        propertyImage =
            "$s3pathPropertiesPathMember$listId/property/$imageName";

        rowImageUrl =
            '$s3URL/fit-in/400x0/assets/properties_member/$listId/property/$imageName';
      }
    }
    /* else {
      propertyImage = 'https://' + _host + '/images/skyblue/pro1.jpg';
      imagePath = 'https://' + _host + '/images/skyblue/';
    } */

    if (rec.containsKey("get_prop_images")) {
      rec['get_prop_images'].forEach((element) {
        if (element['path'] != null) {
          _propertyImageList.add(imagePath! + element['path']);
        }
        _galleryList.add(imageViewPath! + element['path']);
      });
    }
    if (rec.containsKey("get_floor_images")) {
      rec['get_floor_images'].forEach((element) {
        if (element['path'] != null) {
          if (propertyImage.runtimeType != Null && propertyImage! == null) {
            propertyImage = imagePath! + element['path'];
          }
          _propertyImageList.add(imagePath! + element['path']);
        }
      });
    }

    if (rec.containsKey("user_phoneNumber") &&
        rec['user_phoneNumber'] != null) {
      String phoneNumber = (stdCode != null)
          ? stdCode + rec['user_phoneNumber']
          : '+971' + rec['user_phoneNumber'];
      userPhoneNumber = (stdCode != null)
          ? phoneNumber.replaceAll(stdCode + '0', stdCode)
          : phoneNumber.replaceAll('+971' + '0', '+971');
    }
    return ItemModel(
        id: rec['id'],
        propertyKey: rec['property_key'],
        price: rec['price'],
        nameEnglish: rec['prop_name_1'],
        nameArabic: rec['prop_name_2'],
        type: rec['property_type_name'],
        location: rec['location'],
        locationAr: rec['location_ar'],
        amenities: (rec.containsKey("get_amenity"))
            ? (rec['get_amenity']['amenityArr'].runtimeType == List<dynamic>)
                ? rec['get_amenity']['amenityArr']
                : [rec['get_amenity']['amenityArr']]
            : [],
        bedrooms: rec['bedrooms'],
        toilet: rec['toilet'],
        areaUnit: rec['property_area_unit'].toString(),
        areaSqft: rec['property_area_sqft'].toString(),
        areaSqm: rec['property_area_sqm'].toString(),
        areaSqyd: rec['property_area_sqyd'].toString(),
        propertyImage: propertyImage,
        propertyImagesArray: _propertyImageList,
        galleryImagesArray: _galleryList,
        rowImage: rowImageUrl,
        propertyType: rec['property_type'].toString(),
        propertyStatus: rec['property_status'].toString(),
        purpose: rec['purpose'],
        buildYear: rec['build_year'].toString(),
        descriptionArebic: (rec.containsKey("description_arebic"))
            ? rec['description_arebic']
            : '',
        descriptionEnglish: (rec.containsKey("description_english"))
            ? rec['description_english']
            : '',
        dbType: rec['db_type'],
        status: rec['status'],
        roleId: rec['role_id'].toString(),
        isAgent: /* (rec.containsKey("is_agent")) ? */ rec['is_agent'] ?? 0,
        agencyImage: (rec.containsKey("agency_image"))
            ? (rec['db_type'] == 'admin')
                ? s3pathAgencyPath + rec['agency_image']
                : rec['agency_image']
            : rec['photo_url'] ?? '',
        agencyName: (rec.containsKey("agency_name")) ? rec['agency_name'] : '',
        agencyNameAr:
            (rec.containsKey("agency_name_ar")) ? rec['agency_name_ar'] : '',
        agencyAddress:
            (rec.containsKey("agency_address")) ? rec['agency_address'] : '',
        propertyAddedBy: (rec.containsKey("property_added_by"))
            ? rec['property_added_by']
            : '',
        userId: rec['user_id'],
        userPhoneNumber: userPhoneNumber,
        slug: rec['property_slug'],
        priceType: rec['price_type'],
        agencyId: rec.containsKey('agency_id')
            ? (rec['agency_id'] != null)
                ? rec['agency_id']
                : 0
            : 0);
  }

  ItemModel copyWith(
      {int? id,
      isAgent,
      userId,
      String? propertyKey,
      String? price,
      String? nameEnglish,
      String? nameArabic,
      String? type,
      String? location,
      String? locationAr,
      List? amenities,
      int? bedrooms,
      int? toilet,
      String? areaUnit,
      String? areaSqft,
      String? areaSqm,
      String? areaSqyd,
      String? propertyImage,
      rowImage,
      List? propertyImagesArray,
      galleryImagesArray,
      String? propertyType,
      String? propertyStatus,
      String? purpose,
      String? buildYear,
      String? descriptionArebic,
      String? descriptionEnglish,
      String? dbType,
      String? roleId,
      String? agencyImage,
      String? agencyName,
      agencyNameAr,
      String? agencyAddress,
      String? propertyAddedBy,
      String? userPhoneNumber,
      slug,
      priceType,
      int? status,
      agencyId}) {
    return ItemModel(
        id: id ?? this.id,
        isAgent: isAgent ?? this.isAgent,
        userId: userId ?? this.userId,
        propertyKey: propertyKey ?? this.propertyKey,
        price: price ?? this.price,
        nameEnglish: nameEnglish ?? this.nameEnglish,
        nameArabic: nameArabic ?? this.nameArabic,
        type: type ?? this.type,
        location: location ?? this.location,
        locationAr: locationAr ?? this.locationAr,
        amenities: amenities ?? this.amenities,
        bedrooms: bedrooms ?? this.bedrooms,
        toilet: toilet ?? this.toilet,
        areaUnit: areaUnit ?? this.areaUnit,
        areaSqft: areaSqft ?? this.areaSqft,
        propertyImage: propertyImage ?? this.propertyImage,
        propertyImagesArray: propertyImagesArray ?? this.propertyImagesArray,
        rowImage: rowImage ?? this.rowImage,
        propertyType: propertyType ?? this.propertyType,
        propertyStatus: propertyStatus ?? this.propertyStatus,
        purpose: purpose ?? this.purpose,
        buildYear: buildYear ?? this.buildYear,
        descriptionArebic: descriptionArebic ?? this.descriptionArebic,
        descriptionEnglish: descriptionEnglish ?? this.descriptionEnglish,
        dbType: dbType ?? this.dbType,
        roleId: roleId ?? this.roleId,
        agencyImage: agencyImage ?? this.agencyImage,
        agencyName: agencyName ?? this.dbType,
        agencyNameAr: agencyNameAr ?? this.agencyNameAr,
        agencyAddress: agencyAddress ?? this.agencyAddress,
        propertyAddedBy: propertyAddedBy ?? this.propertyAddedBy,
        userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
        status: status ?? this.status,
        slug: slug ?? this.slug,
        priceType: priceType ?? this.priceType,
        galleryImagesArray: galleryImagesArray ?? this.galleryImagesArray,
        agencyId: agencyId ?? this.agencyId);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'propertyKey': propertyKey,
      'status': status,
      'price': price,
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'type': type,
      'location': location,
      'locationAr': locationAr,
      'amenities': amenities,
      'bedrooms': bedrooms,
      'toilet': toilet,
      'areaUnit': areaUnit,
      'areaSqm': areaSqm,
      'areaSqft': areaSqft,
      'areaSqyd': areaSqyd,
      'propertyImage': propertyImage,
      'propertyImagesArray': propertyImagesArray,
      'rowImage': rowImage,
      'propertyType': propertyType,
      'propertyStatus': propertyStatus,
      'purpose': purpose,
      'buildYear': buildYear,
      'descriptionArebic': descriptionArebic,
      'descriptionEnglish': descriptionEnglish,
      'dbType': dbType,
      'roleId': roleId,
      'agencyImage': agencyImage,
      'agencyName': agencyName,
      'agencyNameAr': agencyNameAr,
      'agencyAddress': agencyAddress,
      'propertyAddedBy': propertyAddedBy,
      'userPhoneNumber': userPhoneNumber,
      'slug': slug,
      'isAgent': isAgent,
      'priceType': priceType,
      'galleryImagesArray': galleryImagesArray,
      'agencyId': agencyId
    };
  }
}

class ItemImages {
  final List<dynamic> images;

  ItemImages.fromJson(Map json) : images = json['property_images'] as List;

  String toString() => 'Images array $this.images';
}
