// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
@Collection()
class User {
  String id;
  Id get userId => fastHash(id);
  String email;
  String username;
  String? profilePic;
  //  DateTime createdAt;
  //  DateTime updatedAt;
  //  List<Chat> conversations;
  //  List<Message> messages;
  //  List<Picture> pictures;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.profilePic,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
@Collection()
class Message {
  String id;
  Id get messageId => fastHash(id);

  //  DateTime createdAt;
  //  DateTime updatedAt;
  String text;
  String? picture;
  @enumerated
  MessageStatus status = MessageStatus.sending;

  final chat = IsarLinks<Chat>();
  String? chatId;
  //  chat = IsarLink<Chat>();
  String? senderId;

  Message({
    required this.id,
    // required this.createdAt,
    // required this.updatedAt,
    required this.text,
    this.picture,
    required this.chatId,
    required this.senderId,
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
  // late List<Message> messages;
  @Backlink(to: 'chat')
  // @JsonKey(includeFromJson: false, includeToJson: false)
  @MessagesJsonToIsar()
  IsarLinks<Message> messages = IsarLinks<Message>();

  // user
  // @Ignore()
  // late List<User> users;
  // @JsonKey(includeFromJson: false, includeToJson: false)
  @UsersJsonToIsar()
  IsarLinks<User> users = IsarLinks<User>();

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

enum MessageStatus { sending, sent, delivered, seen }

class MessagesJsonToIsar implements JsonConverter<IsarLinks<Message>, List<dynamic>> {
  const MessagesJsonToIsar();
  @override
  fromJson(json) {
    final messages = json.map((e) => Message.fromJson(e));
    var isar = IsarLinks<Message>();
    isar.addAll(messages) ;
    return isar;
  }

  @override
  List<Map<String, dynamic>> toJson(IsarLinks<Message> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class UsersJsonToIsar implements JsonConverter<IsarLinks<User>, List<dynamic>> {
  const UsersJsonToIsar();
  @override
  fromJson(json) {
    final users = json.map((e) => User.fromJson(e));
    var isar = IsarLinks<User>();
    isar.addAll(users) ;
    return isar;
  }

  @override
  List<Map<String, dynamic>> toJson(IsarLinks<User> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
