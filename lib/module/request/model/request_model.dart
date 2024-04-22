import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final int? id;
  final int? userId;
  final String? userName;
  final String? email;
  final String? photoUrl;
  final String? agencyNameEn;
  final String? agencyNameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? phone;
  final dynamic location;
  final String? budget;
  final int? isDeleted;
  final dynamic contactType;
  final int? status;
  final int? channelExist;
  final String? friendlyName;
  final dynamic channelId;
  final int? createdTimetoken;
  final int? updatedTimetoken;

  const RequestModel(
      {this.id,
      this.userId,
      this.userName,
      this.email,
      this.photoUrl,
      this.agencyNameEn,
      this.agencyNameAr,
      this.descriptionEn,
      this.descriptionAr,
      this.phone,
      this.location,
      this.budget,
      this.isDeleted,
      this.contactType,
      this.status,
      this.channelExist,
      this.friendlyName,
      this.channelId,
      this.createdTimetoken,
      this.updatedTimetoken});

  @override
  List<Object> get props => [
        id!,
        userId!,
        userName!,
        email!,
        photoUrl!,
        agencyNameEn!,
        agencyNameAr!,
        descriptionEn!,
        descriptionAr!,
        phone!,
        location!,
        budget!,
        isDeleted!,
        contactType!,
        status!,
        channelExist!,
        friendlyName!,
        channelId!,
        createdTimetoken!,
        updatedTimetoken!
      ];

  RequestModel copyWith({int? id}) {
    RequestModel requestModel = RequestModel(
        id: id ?? this.id,
        userId: userId,
        userName: userName,
        email: email,
        photoUrl: photoUrl,
        agencyNameEn: agencyNameEn,
        agencyNameAr: agencyNameAr,
        descriptionEn: descriptionEn,
        descriptionAr: descriptionAr,
        phone: phone,
        location: location,
        budget: budget,
        isDeleted: isDeleted,
        contactType: contactType,
        status: status,
        channelExist: channelExist,
        friendlyName: friendlyName,
        channelId: channelId,
        createdTimetoken: createdTimetoken,
        updatedTimetoken: updatedTimetoken);
    return requestModel;
  }

  @override
  String toString() =>
      '{id: $id, userId: $userId, userName: $userName, email: $email, photoUrl: $photoUrl, agencyNameEn: $agencyNameEn, agencyNameAr: $agencyNameAr, descriptionEn: $descriptionEn, descriptionAr: $descriptionAr, phone: $phone, location: $location, budget: $budget, isDeleted: $isDeleted, contactType: $contactType, status: $status, channelExist: $channelExist, friendlyName: $friendlyName, channelId: $channelId, createdTimetoken: $createdTimetoken, updatedTimetoken: $updatedTimetoken}';

  factory RequestModel.recJson(
      Map<String, dynamic> rec,
      agencyEn,
      agencyAr,
      status,
      userId,
      userName,
      email,
      photoUrl,
      channelExist,
      friendlyName,
      channelId,
      createdTimetoken,
      updatedTimetoken) {
    return RequestModel(
      id: rec['id'] ?? 0,
      userId: userId ?? 0,
      userName: userName ?? '',
      email: email ?? '',
      photoUrl: photoUrl ?? '',
      agencyNameEn: agencyEn ?? '',
      agencyNameAr: agencyAr ?? '',
      descriptionEn: rec['description_en'] ?? '',
      descriptionAr: rec['description_ar'] ?? '',
      phone: rec['phone'] ?? '',
      location: rec['location'] ?? '',
      budget: rec['budget'] ?? '',
      isDeleted: rec['is_deleted'] ?? 0,
      contactType: rec['contact_type'] ?? '',
      status: status,
      channelExist: channelExist ?? 0,
      friendlyName: friendlyName ?? '',
      channelId: channelId.toString(),
      createdTimetoken: createdTimetoken ?? 0,
      updatedTimetoken: updatedTimetoken ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'email': email,
      'photoUrl': photoUrl,
      'agencyNameEn': agencyNameEn,
      'agencyNameAr': agencyNameAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'phone': phone,
      'location': location,
      'budget': budget,
      'is_deleted': isDeleted,
      'contact_type': contactType,
      'channelExist': channelExist,
      'friendlyName': friendlyName,
      'status': status,
      'channelId': channelId,
      'createdTimetoken': createdTimetoken,
      'updatedTimetoken': updatedTimetoken
    };
  }
}
