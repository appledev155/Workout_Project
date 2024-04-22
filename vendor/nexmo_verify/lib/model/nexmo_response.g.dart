part of 'nexmo_response.dart';

NexmoResponse _$NexmoResponseFromJson(Map<String, dynamic> json) {
  return NexmoResponse(
      requestId: json['request_id'] ?? '',
      status: json['status'] ?? '',
      errorText: json['error_text'] ?? '');
}

Map<String, dynamic> _$NexmoResponseToJson(NexmoResponse instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'status': instance.status,
      'error_text': instance.errorText
    };
