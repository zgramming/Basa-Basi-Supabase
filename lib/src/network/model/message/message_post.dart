import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../network.dart';

part 'message_post.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class MessagePost extends Equatable {
  final int? idSender;
  final String? inboxChannel;
  final String? messageContent;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? messageDate;
  final String? messageFileUrl;
  final MessageStatus messageStatus;
  final MessageType messageType;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? createdAt;

  const MessagePost({
    this.idSender,
    this.inboxChannel,
    this.messageContent,
    this.messageDate,
    this.messageFileUrl,
    this.messageStatus = MessageStatus.none,
    this.messageType = MessageType.none,
    this.createdAt,
  });

  factory MessagePost.fromJson(Map<String, dynamic> json) => _$MessagePostFromJson(json);
  Map<String, dynamic> toJson() => _$MessagePostToJson(this);

  @override
  List<Object?> get props {
    return [
      idSender,
      inboxChannel,
      messageContent,
      messageDate,
      messageFileUrl,
      messageStatus,
      messageType,
      createdAt,
    ];
  }

  @override
  bool get stringify => true;

  MessagePost copyWith({
    int? idSender,
    String? inboxChannel,
    String? messageContent,
    DateTime? messageDate,
    String? messageFileUrl,
    MessageStatus? messageStatus,
    MessageType? messageType,
    DateTime? createdAt,
  }) {
    return MessagePost(
      idSender: idSender ?? this.idSender,
      inboxChannel: inboxChannel ?? this.inboxChannel,
      messageContent: messageContent ?? this.messageContent,
      messageDate: messageDate ?? this.messageDate,
      messageFileUrl: messageFileUrl ?? this.messageFileUrl,
      messageStatus: messageStatus ?? this.messageStatus,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
