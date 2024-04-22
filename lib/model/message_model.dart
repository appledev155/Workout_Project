class MessageModel {
  final String? message;
  final String? userId;
  final String? name;
  MessageModel({this.message, this.userId, this.name});

  factory MessageModel.fromRawJson(Map<String, dynamic> jsonData) {
    return MessageModel(
        message: jsonData['message'],
        userId: jsonData['fromUserId'],
        name: jsonData['name']);
  }
}
