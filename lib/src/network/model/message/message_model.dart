import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../network.dart';

part 'message_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class MessageModel extends Equatable {
  final int? id;
  final int? idSender;
  final String? inboxChannel;
  final String? messageContent;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? messageDate;
  final String? messageFileUrl;
  final MessageStatus? messageStatus;
  final MessageType? messageType;

  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? createdAt;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? updatedAt;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? deletedAt;
  final int? deletedIdUser;
  final int? likedIdUser;

  const MessageModel({
    this.id = 0,
    this.idSender,
    this.inboxChannel = 'default inbox channel',
    this.messageContent = 'Halooo',
    this.messageDate,
    this.messageFileUrl = '',
    this.messageStatus = MessageStatus.none,
    this.messageType = MessageType.none,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deletedIdUser,
    this.likedIdUser,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      idSender,
      inboxChannel,
      messageContent,
      messageDate,
      messageFileUrl,
      messageStatus,
      messageType,
      createdAt,
      updatedAt,
      deletedAt,
      deletedIdUser,
      likedIdUser,
    ];
  }

  @override
  bool get stringify => true;

  MessageModel copyWith({
    int? id,
    int? idSender,
    String? inboxChannel,
    String? messageContent,
    DateTime? messageDate,
    String? messageFileUrl,
    MessageStatus? messageStatus,
    MessageType? messageType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? deletedIdUser,
    int? likedIdUser,
  }) {
    return MessageModel(
      id: id ?? this.id,
      idSender: idSender ?? this.idSender,
      inboxChannel: inboxChannel ?? this.inboxChannel,
      messageContent: messageContent ?? this.messageContent,
      messageDate: messageDate ?? this.messageDate,
      messageFileUrl: messageFileUrl ?? this.messageFileUrl,
      messageStatus: messageStatus ?? this.messageStatus,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedIdUser: deletedIdUser ?? this.deletedIdUser,
      likedIdUser: likedIdUser ?? this.likedIdUser,
    );
  }
}
