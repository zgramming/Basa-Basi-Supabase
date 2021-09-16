import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../network.dart';

part 'inbox_model.g.dart';

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('image_with_text')
  imageWithText,
  @JsonValue('file')
  file,
  @JsonValue('voice')
  voice,
  @JsonValue('none')
  none
}

const messageTypeValues = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.imageWithText: 'image_with_text',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.none: 'none',
};

enum MessageStatus {
  @JsonValue('none')
  none,
  @JsonValue('pending')
  pending,
  @JsonValue('send')
  send,
  @JsonValue('read')
  read
}

const messageStatusValues = {
  MessageStatus.none: 'none',
  MessageStatus.pending: 'pending',
  MessageStatus.send: 'send',
  MessageStatus.read: 'read',
};

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class InboxModel extends Equatable {
  final int id;
  final ProfileModel? user;
  final int? idSender;
  final ProfileModel? pairing;
  final String? inboxChannel;
  final String? inboxLastMessage;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? inboxLastMessageDate;
  final MessageStatus? inboxLastMessageStatus;
  final MessageType? inboxLastMessageType;
  @JsonKey(defaultValue: false)
  final bool? isArchived;
  @JsonKey(defaultValue: false)
  final bool? isDeleted;
  @JsonKey(defaultValue: false)
  final bool? isPinned;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? lastTypingDate;
  final int? totalUnreadMessage;

  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? createdAt;

  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? updatedAt;

  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? deletedAt;

  const InboxModel({
    this.id = 0,
    this.user,
    this.idSender,
    this.pairing,
    this.inboxChannel = 'default_inbox_channel',
    this.inboxLastMessage,
    this.inboxLastMessageDate,
    this.inboxLastMessageStatus = MessageStatus.none,
    this.inboxLastMessageType = MessageType.none,
    this.isArchived = false,
    this.isDeleted = false,
    this.isPinned,
    this.lastTypingDate,
    this.totalUnreadMessage = 0,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory InboxModel.fromJson(Map<String, dynamic> json) => _$InboxModelFromJson(json);
  Map<String, dynamic> toJson() => _$InboxModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      user,
      idSender,
      pairing,
      inboxChannel,
      inboxLastMessage,
      inboxLastMessageDate,
      inboxLastMessageStatus,
      inboxLastMessageType,
      isArchived,
      isDeleted,
      isPinned,
      lastTypingDate,
      totalUnreadMessage,
      createdAt,
      updatedAt,
      deletedAt,
    ];
  }

  @override
  bool get stringify => true;

  InboxModel copyWith({
    int? id,
    ProfileModel? user,
    int? idSender,
    ProfileModel? pairing,
    String? inboxChannel,
    String? inboxLastMessage,
    DateTime? inboxLastMessageDate,
    MessageStatus? inboxLastMessageStatus,
    MessageType? inboxLastMessageType,
    bool? isArchived,
    bool? isDeleted,
    bool? isPinned,
    DateTime? lastTypingDate,
    int? totalUnreadMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return InboxModel(
      id: id ?? this.id,
      user: user ?? this.user,
      idSender: idSender ?? this.idSender,
      pairing: pairing ?? this.pairing,
      inboxChannel: inboxChannel ?? this.inboxChannel,
      inboxLastMessage: inboxLastMessage ?? this.inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate ?? this.inboxLastMessageDate,
      inboxLastMessageStatus: inboxLastMessageStatus ?? this.inboxLastMessageStatus,
      inboxLastMessageType: inboxLastMessageType ?? this.inboxLastMessageType,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      isPinned: isPinned ?? this.isPinned,
      lastTypingDate: lastTypingDate ?? this.lastTypingDate,
      totalUnreadMessage: totalUnreadMessage ?? this.totalUnreadMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
