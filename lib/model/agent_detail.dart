import 'package:equatable/equatable.dart';

class AgentDetail extends Equatable {
  final int? id;
  final String? agencyName,
      agencyNameAr,
      agentName,
      profileImage,
      agentPhoneNumber;
  final List? propList;

  const AgentDetail(
      {this.id,
      this.agencyName,
      this.agencyNameAr,
      this.agentName,
      this.profileImage,
      this.propList,
      this.agentPhoneNumber});

  @override
  List<Object> get props => [
        id!,
        agencyName!,
        agencyNameAr!,
        agentName!,
        profileImage!,
        agentPhoneNumber!,
        propList!
      ];

  @override
  String toString() => '{id: $id}';

  factory AgentDetail.recJson(Map<dynamic, dynamic> rec, stdCode) {
    String phoneNumber = '';

    if (rec['agentDetails']['phoneNumber'] != null) {
      String phoneNumbertemp =
          stdCode + rec['agentDetails']['phoneNumber'].toString();
      phoneNumber = phoneNumbertemp.replaceAll(stdCode + '0', stdCode);
    }
    return AgentDetail(
        id: rec['agentDetails']['id'],
        agencyName: ('${rec['agencyDetails']}' != '[]')
            ? rec['agencyDetails']['agency_name']
            : '',
        agencyNameAr: ('${rec['agencyDetails']}' != '[]')
            ? rec['agencyDetails']['agency_name_ar']
            : '',
        agentName: rec['agentDetails']['displayName'] ?? '',
        profileImage: rec['agentDetails']['photo_url'] ?? '',
        agentPhoneNumber: phoneNumber,
        propList: rec['PropertyTypeArr']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agencyName': agencyName,
      'agencyNameAr': agencyNameAr,
      'agentName': agentName,
      'profileImage': profileImage,
      'agentPhoneNumber': agentPhoneNumber,
      'propList': propList
    };
  }
}
