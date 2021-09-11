// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePost _$MessagePostFromJson(Map<String, dynamic> json) {
  return MessagePost(
    idSender: json['id_sender'] as int?,
    inboxChannel: json['inbox_channel'] as String?,
    messageContent: json['message_content'] as String?,
    messageDate: GlobalFunction.fromJsonMilisecondToDateTime(
        json['message_date'] as int?),
    messageFileUrl: json['message_file_url'] as String?,
    messageStatus: _$enumDecode(_$MessageStatusEnumMap, json['message_status']),
    messageType: _$enumDecode(_$MessageTypeEnumMap, json['message_type']),
    createdAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['created_at'] as int?),
  );
}

Map<String, dynamic> _$MessagePostToJson(MessagePost instance) =>
    <String, dynamic>{
      'id_sender': instance.idSender,
      'inbox_channel': instance.inboxChannel,
      'message_content': instance.messageContent,
      'message_date':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.messageDate),
      'message_file_url': instance.messageFileUrl,
      'message_status': _$MessageStatusEnumMap[instance.messageStatus],
      'message_type': _$MessageTypeEnumMap[instance.messageType],
      'created_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.createdAt),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$MessageStatusEnumMap = {
  MessageStatus.none: 'none',
  MessageStatus.pending: 'pending',
  MessageStatus.send: 'send',
  MessageStatus.read: 'read',
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.imageWithText: 'image_with_text',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.none: 'none',
};
