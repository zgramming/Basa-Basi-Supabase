// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InboxModel _$InboxModelFromJson(Map<String, dynamic> json) {
  return InboxModel(
    id: json['id'] as int,
    user: json['user'] == null
        ? null
        : ProfileModel.fromJson(json['user'] as Map<String, dynamic>),
    sender: json['sender'] == null
        ? null
        : ProfileModel.fromJson(json['sender'] as Map<String, dynamic>),
    inboxChannel: json['inbox_channel'] as String?,
    inboxLastMessage: json['inbox_last_message'] as String?,
    inboxLastMessageDate: GlobalFunction.fromJsonMilisecondToDateTime(
        json['inbox_last_message_date'] as int?),
    inboxLastMessageStatus: _$enumDecodeNullable(
        _$MessageStatusEnumMap, json['inbox_last_message_status']),
    inboxLastMessageType: _$enumDecodeNullable(
        _$MessageTypeEnumMap, json['inbox_last_message_type']),
    isArchived: json['is_archived'] as bool?,
    isDeleted: json['is_deleted'] as bool?,
    lastTypingDate: GlobalFunction.fromJsonMilisecondToDateTime(
        json['last_typing_date'] as int?),
    totalUnreadMessage: json['total_unread_message'] as int?,
    createdAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['created_at'] as int?),
    updatedAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['updated_at'] as int?),
    deletedAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['deleted_at'] as int?),
  );
}

Map<String, dynamic> _$InboxModelToJson(InboxModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'sender': instance.sender,
      'inbox_channel': instance.inboxChannel,
      'inbox_last_message': instance.inboxLastMessage,
      'inbox_last_message_date': GlobalFunction.toJsonMilisecondFromDateTime(
          instance.inboxLastMessageDate),
      'inbox_last_message_status':
          _$MessageStatusEnumMap[instance.inboxLastMessageStatus],
      'inbox_last_message_type':
          _$MessageTypeEnumMap[instance.inboxLastMessageType],
      'is_archived': instance.isArchived,
      'is_deleted': instance.isDeleted,
      'last_typing_date':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.lastTypingDate),
      'total_unread_message': instance.totalUnreadMessage,
      'created_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.createdAt),
      'updated_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.updatedAt),
      'deleted_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.deletedAt),
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
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
