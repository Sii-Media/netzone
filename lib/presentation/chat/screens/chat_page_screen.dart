import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:netzoon/presentation/home/widgets/not_now_alert.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatPageScreen extends StatefulWidget {
  const ChatPageScreen({
    super.key,
    required this.userId,
    required this.otherUserId,
    required this.title,
    required this.image,
  });
  final String userId;
  final String otherUserId;
  final String title;
  final String image;
  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  final appId = 'D27C6110-9DB9-4EBE-AA85-CF39E2AF562E';
  // final userId = 'Wesam';
  // final otherUserId = 'Edmon';
  List<BaseMessage> _messages = [];
  late GroupChannel _channel;

  bool _isLoadingMessages = false;
  @override
  void initState() {
    super.initState();
    setup();
    SendbirdChat.addChannelHandler('dashchat', MyGroupChannelHandler(this));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addMessage(BaseMessage message) {
    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BaseMessage> reversedMessages = List.from(_messages.reversed);
    // final usersImages = _channel.members.map((e) => e.profileUrl).toList();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: AppColor.backgroundColor,
            leadingWidth: 30,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    width: 35.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: AppColor.backgroundColor,

                        // strokeWidth: 10,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  width: 140.w,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4, left: 4),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: GestureDetector(
                  onTap: () {
                    notNowAlert(context);
                  },
                  child: const Icon(
                    Icons.call,
                    size: 25,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  notNowAlert(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Icon(
                    Icons.video_call,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _isLoadingMessages
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : DashChat(
                currentUser: asDashChatUser(SendbirdChat.currentUser),
                onSend: (dashmessage) {
                  final sendMessage =
                      _channel.sendUserMessageWithText(dashmessage.text);
                  setState(() {
                    _messages.add(sendMessage);
                  });
                },
                messages: asDashChatMessages(reversedMessages),
                typingUsers: const [],
                messageOptions: const MessageOptions(
                  containerColor: Color(0xFFE1E1E2),
                  textColor: AppColor.black,
                  currentUserContainerColor: AppColor.backgroundColor,
                  currentUserTextColor: AppColor.white,
                  showTime: true,
                ),
              ));
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    return [
      for (BaseMessage sbmessage in messages)
        ChatMessage(
          user: asDashChatUser(sbmessage.sender),
          text: sbmessage.message,
          createdAt: DateTime.now(),
        )
    ];
  }

  ChatUser asDashChatUser(User? user) {
    return ChatUser(
      id: user?.userId ?? '',
      firstName: user?.nickname,
      profileImage: user?.profileUrl,
    );
  }

  void setup() async {
    try {
      setState(() {
        _isLoadingMessages = true;
      });
      final sendbird = SendbirdChat.init(appId: appId);
      final user = await SendbirdChat.connect(widget.userId);
      final query = GroupChannelListQuery()
        ..limit = 1
        ..userIdsIncludeFilter = [widget.otherUserId];

      final channels = await query.next();
      if (channels.isEmpty) {
        setState(() {
          _isLoadingMessages = true;
        });
        _channel = await GroupChannel.createChannel(GroupChannelCreateParams()
          ..isDistinct = true
          ..name = "${widget.userId}-${widget.otherUserId}"
          ..operatorUserIds = [widget.userId, widget.otherUserId]
          ..userIds = [
            widget.userId,
            widget.otherUserId,
          ]);
        setState(() {
          _isLoadingMessages = false;
        });
      }
      _channel = channels[0];
      await SendbirdChat.markAsRead(channelUrls: [_channel.channelUrl]);

      setState(() {
        _isLoadingMessages = true;
      });

      final messages = await _channel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
      setState(() {
        _messages = messages;
        _isLoadingMessages = false;
      });
    } catch (e) {
      print(e);
    }
  }
}

class MyGroupChannelHandler extends GroupChannelHandler {
  final _ChatPageScreenState _state;

  MyGroupChannelHandler(this._state);
  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    _state._addMessage(message);
  }
}
/*ListView(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 80,
          right: 20,
          left: 20,
        ),
        children: const [
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
          ChatSample(),
        ],
      ),
      bottomSheet: const ChatBottomSheet(),*/