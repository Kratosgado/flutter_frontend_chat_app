// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/v1.dart' as uuid;

part 'models.g.dart';

@JsonSerializable()
@embedded
class User {
  late String id;
  // Id get userId => fastHash(id);
  String? email;
  String? username;
  String? profilePic;
  //  DateTime createdAt;
  //  DateTime updatedAt;
  //  List<Chat> conversations;
  //  List<Message> messages;
  //  List<Picture> pictures;

  User({
    this.email,
    this.username,
    this.profilePic,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
@embedded
class Message {
  String id = const uuid.UuidV1().generate();
  // Id get messageId => fastHash(id);

  //  DateTime createdAt;
  //  DateTime updatedAt;
  late String text;
  String? picture;
  @enumerated
  MessageStatus status = MessageStatus.SENDING;

  // final chat = IsarLinks<Chat>();
  String? chatId;
  //  chat = IsarLink<Chat>();
  String? senderId;

  Message({
    //  this.id,
    // required this.createdAt,
    // required this.updatedAt,
    //  this.text,
    this.picture,
    this.chatId,
    this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable(explicitToJson: true)
@Collection()
class Chat {
  late String id;
  Id get chatId => fastHash(id);

  late String convoName;
  //  DateTime createdAt;
  //  DateTime updatedAt;
  // message
  // @Ignore()
  late List<Message> messages;

  // user
  // @Ignore()
  late List<User> users;
  // @JsonKey(includeFromJson: false, includeToJson: false)
  // @UsersJsonToIsar()
  // IsarLinks<User> users = IsarLinks<User>();

  Chat({
    required this.id,
    required this.convoName,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

int fastHash(String id) {
  var hash = 0xcbf29ce484222352;

  var i = 0;
  while (i < id.length) {
    final codeUnit = id.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}

enum MessageStatus { SENDING, SENT, DELIVERED, SEEN }
