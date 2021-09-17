import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../network/model/network.dart';

class InboxState extends Equatable {
  final List<InboxModel> items;
  const InboxState({
    this.items = const [],
  });

  InboxState addAll(List<InboxModel> values) => copyWith(items: [...values]);

  InboxState delete() => copyWith(items: []);

  InboxState updateOrInsert(InboxModel value) {
    final index = items.indexWhere((element) => element.id == value.id);
    final oldRecord = items.firstWhereOrNull((element) => element.id == value.id);

    if (oldRecord != null) {
      items[index] = oldRecord.copyWith(
        idSender: value.idSender,
        totalUnreadMessage: value.totalUnreadMessage,
        lastTypingDate: value.lastTypingDate,
        isArchived: value.isArchived,
        deletedAt: value.deletedAt,
        isPinned: value.isPinned,
        inboxLastMessage: value.inboxLastMessage,
        inboxLastMessageDate: value.inboxLastMessageDate,
        inboxLastMessageStatus: value.inboxLastMessageStatus,
        inboxLastMessageType: value.inboxLastMessageType,
        isDeleted: value.isDeleted,
        updatedAt: value.updatedAt,
      );
      return copyWith(items: items);
    } else {
      return copyWith(items: [...items, value]);
    }
  }

  // InboxState add(InboxModel value) => copyWith(items: [...items, value]);

  // InboxState deleteByChannel(InboxModel value) =>
  //     copyWith(items: [...items.where((element) => element.inboxChannel != value.inboxChannel)]);

  // InboxState deleteById(InboxModel value) =>
  //     copyWith(items: [...items.where((element) => element.id != value.id)]);

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  InboxState copyWith({
    List<InboxModel>? items,
  }) {
    return InboxState(
      items: items ?? this.items,
    );
  }
}
