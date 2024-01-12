// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:flutter_frontend_chat_app/data/network/services/hive.service.dart';
import 'package:flutter_frontend_chat_app/resources/utils.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/v1.dart' as uuid;

part 'models.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? password;
  @HiveField(2)
  String? token;
  @HiveField(3)
  late User user;
  @HiveField(4)
  bool isActive;
  Account({
    required this.id,
    this.password,
    this.token,
    required this.user,
    required this.isActive,
  });
}

@JsonSerializable()
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? username;
  @HiveField(3)
  String? profilePic;
  //  DateTime createdAt;
  //  DateTime updatedAt;

  User({
    required this.id,
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
@HiveType(typeId: 2)
class Message extends HiveObject {
  @HiveField(0)
  String id = const uuid.UuidV1().generate();
  // Id get messageId => fastHash(id);

  //  DateTime createdAt;
  //  DateTime updatedAt;
  @HiveField(1)
  late String text;
  @HiveField(2)
  String? picture;
  @HiveField(3)
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
@HiveType(typeId: 3)
class Chat extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  late String convoName;
  //  DateTime createdAt;
  //  DateTime updatedAt;

  @HiveField(2)
  // @JsonToHiveList()
  late List<Message> messages;
  @HiveField(3)
  late List<User> users;

  Chat({
    required this.id,
    required this.convoName,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

@HiveType(typeId: 4)
enum MessageStatus {
  @HiveField(0, defaultValue: true)
  SENDING,
  @HiveField(1)
  SENT,
  @HiveField(2)
  DELIVERED,
  @HiveField(3)
  SEEN
}

class JsonToHiveList implements JsonConverter<HiveList<Message>, List<dynamic>> {
  const JsonToHiveList();

  @override
  HiveList<Message> fromJson(List<dynamic> json) {
    final source = json.map((chat) => Message.fromJson(chat)).toList();
    final box = Hive.box<Message>(HiveService.messageBoxName);
    var messages = HiveList<Message>(box);

    // messages.box.putAll({for (var message in source) message.id: message});
    () async => {
          await messages.box.putAll({for (var message in source) message.id: message}),
        };
    return messages;
  }

  @override
  List toJson(HiveList<Message> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
