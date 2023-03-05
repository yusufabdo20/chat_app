class MessageModel {
  final String msg;
  final  id;
  MessageModel(this.msg, this.id);
  factory MessageModel.fromJson(dynamic json) {
    return MessageModel(
      json["msg"],
      json['id'],
    );
  }
}
