import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

Future<void> connectWithSendbird({required String username}) async {
  await SendbirdChat.connect(username);
}
