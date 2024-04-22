import 'package:json_annotation/json_annotation.dart';

part 'package:nexmo_verify/model/nexmo_response.g.dart';

@JsonSerializable()
class NexmoResponse extends Object {
  String? requestId;
  String? status;
  String? errorText;

  NexmoResponse({this.requestId, this.status, this.errorText});

  factory NexmoResponse.fromJson(Map<String, dynamic> json) =>
      _$NexmoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NexmoResponseToJson(this);
}
