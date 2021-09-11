import 'package:equatable/equatable.dart';

import '../network.dart';

class InboxPost extends Equatable {
  final int idSender;
  final int idUser;
  final String inboxChannel;
  final String inboxLastMessage;
  final DateTime inboxLastMessageDate;
  final MessageStatus inboxLastMessageStatus;
  final MessageType inboxLastMessageType;
  final int totalUnreadMessage;
  final DateTime createdAt;

  const InboxPost({
    required this.idSender,
    required this.idUser,
    required this.inboxChannel,
    required this.inboxLastMessage,
    required this.inboxLastMessageDate,
    required this.inboxLastMessageStatus,
    required this.inboxLastMessageType,
    required this.totalUnreadMessage,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [
      idSender,
      idUser,
      inboxChannel,
      inboxLastMessage,
      inboxLastMessageDate,
      inboxLastMessageStatus,
      inboxLastMessageType,
      totalUnreadMessage,
      createdAt,
    ];
  }

  @override
  bool get stringify => true;

  InboxPost copyWith({
    int? idSender,
    int? idUser,
    String? inboxChannel,
    String? inboxLastMessage,
    DateTime? inboxLastMessageDate,
    MessageStatus? inboxLastMessageStatus,
    MessageType? inboxLastMessageType,
    int? totalUnreadMessage,
    DateTime? createdAt,
  }) {
    return InboxPost(
      idSender: idSender ?? this.idSender,
      idUser: idUser ?? this.idUser,
      inboxChannel: inboxChannel ?? this.inboxChannel,
      inboxLastMessage: inboxLastMessage ?? this.inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate ?? this.inboxLastMessageDate,
      inboxLastMessageStatus: inboxLastMessageStatus ?? this.inboxLastMessageStatus,
      inboxLastMessageType: inboxLastMessageType ?? this.inboxLastMessageType,
      totalUnreadMessage: totalUnreadMessage ?? this.totalUnreadMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
