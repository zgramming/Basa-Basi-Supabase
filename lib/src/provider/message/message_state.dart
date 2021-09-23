import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../network/model/network.dart';

class MessageState extends Equatable {
  final List<MessageModel> items;
  const MessageState({
    this.items = const [],
  });

  int get total => items.length;

  MessageState upsert({
    required MessageModel value,
  }) {
    final isExists = items.firstWhereOrNull((element) => element.id == value.id);

    if (isExists != null) {
      return copyWith(
        items: [
          for (final item in items)
            if (item.id == value.id) value else item
        ],
      );
    } else {
      return copyWith(items: [...items, value]);
    }
  }

  MessageState addAll({
    required List<MessageModel> values,
  }) =>
      copyWith(items: [...values]);

  MessageState add({
    required MessageModel value,
  }) {
    final result = copyWith(items: [value, ...items]).items;
    return copyWith(items: result);
  }

  MessageState update(MessageModel value) {
    items[items.indexWhere((element) => element.id == value.id)] = value;

    return copyWith(items: items);
  }

  MessageState delete({
    required int id,
  }) =>
      copyWith(items: [...items.where((element) => element.id != id).toList()]);

  MessageState updateAllMessageToRead({
    required int idUser,
  }) {
    return copyWith(
      items: [
        for (final item in items)
          if (item.idSender == idUser) item.copyWith(messageStatus: MessageStatus.read) else item
      ],
    );
  }

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  MessageState copyWith({
    List<MessageModel>? items,
  }) {
    return MessageState(
      items: items ?? this.items,
    );
  }
}
