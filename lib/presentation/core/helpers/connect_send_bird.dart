import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

Future<void> connectWithSendbird({required String username}) async {
  await SendbirdChat.connect(username);
}

Future<void> updateCurrentUserInfo(
    {String? nickname, String? profileFileInfo}) async {
  await SendbirdChat.updateCurrentUserInfo(
      nickname: nickname,
      profileFileInfo: FileInfo.fromFileUrl(fileUrl: profileFileInfo));
}
