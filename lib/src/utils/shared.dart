String getConversationID({
  required int you,
  required int senderId,
}) {
  if (you.hashCode <= senderId.hashCode) {
    return "${you}_$senderId";
  } else {
    return "${senderId}_$you";
  }
}

bool isTyping() {
  return true;
}
