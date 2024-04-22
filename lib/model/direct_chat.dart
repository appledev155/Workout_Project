class DirectChat {
  final String? name;
  final String? senderID;
  final String? reciverID;
  final String? photourl;

  DirectChat({this.name, this.senderID, this.reciverID, this.photourl});

  factory DirectChat.fromJson(json) {
    return DirectChat(
        name: json['name'] ?? '',
        senderID: json['sender_id'] ?? '',
        reciverID: json['receiver_id'] ?? '',
        photourl: json['photo_url'] ?? '');
  }
}
