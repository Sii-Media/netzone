// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import '../../../injection_container.dart';
import 'chat_page_screen.dart';
import 'contacts_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  late GroupChannelCollection collection;
  List<GroupChannel> channelList = [];
  bool hasMore = false;
  bool _isLoadingMessages = false;
  int unreadCount = 0;
  final authBloc = sl<AuthBloc>();

  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmpty = true
        ..order = GroupChannelListQueryOrder.latestLastMessage
        ..limit = 15;
      return await query.next();
    } catch (e) {
      print('getGroupChannels: ERROR: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc.add(AuthCheckRequested());
    getLastConversation();
  }

  void getLastConversation() async {
    setState(() {
      _isLoadingMessages = true;
    });
    collection = GroupChannelCollection(
      query: GroupChannelListQuery()
        ..order = GroupChannelListQueryOrder.latestLastMessage,
      handler: MyGroupChannelCollectionHandler(this),
    )..loadMore();
    setState(() {
      _isLoadingMessages = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: RefreshIndicator(
            onRefresh: () async {
              collection = GroupChannelCollection(
                query: GroupChannelListQuery()
                  ..order = GroupChannelListQueryOrder.latestLastMessage,
                handler: MyGroupChannelCollectionHandler(this),
              )..loadMore();
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              bloc: authBloc,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: Text(
                        'Messages',
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                        child: _isLoadingMessages == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: AppColor.backgroundColor,
                                ),
                              )
                            : collection.channelList.isNotEmpty
                                ? _list(state)
                                : const Center(
                                    child: Text(
                                    'no messages',
                                    style: TextStyle(
                                        color: AppColor.backgroundColor),
                                  ))),
                    hasMore ? _moreButton() : Container(),
                  ],
                );
              },
            )),
        // widget: FutureBuilder(
        //   future: getGroupChannels(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData == false || snapshot.data == null) {
        //       // Nothing to display yet - good place for a loading indicator
        //       return Container();
        //     }
        //     List<GroupChannel>? channels = snapshot.data;
        //     return ListView.builder(
        //         itemCount: channels?.length,
        //         itemBuilder: (context, index) {
        //           GroupChannel channel = channels![index];
        //           return ListTile(
        //             // Display all channel members as the title
        //             title: Text(
        //               [for (final member in channel.members) member.nickname]
        //                   .join(", "),
        //             ),
        //             // Display the last message presented
        //             subtitle: Text(channel.lastMessage?.message ?? ''),
        //             onTap: () {
        //               // gotoChannel(channel.channelUrl);
        //             },
        //           );
        //         });
        //   },
        // ),
        // widget: ListView(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(
        //         vertical: 15,
        //         horizontal: 20,
        //       ),
        //       child: Text(
        //         'Messages',
        //         style: TextStyle(
        //           color: AppColor.backgroundColor,
        //           fontSize: 25.sp,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 15),
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 15),
        //         decoration: BoxDecoration(
        //             color: AppColor.white,
        //             borderRadius: BorderRadius.circular(20),
        //             boxShadow: [
        //               BoxShadow(
        //                 color: AppColor.secondGrey.withOpacity(0.5),
        //                 blurRadius: 10,
        //                 spreadRadius: 2,
        //                 offset: const Offset(0, 3),
        //               ),
        //             ]),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             SizedBox(
        //               width: 250.w,
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 15),
        //                 child: TextFormField(
        //                   decoration: const InputDecoration(
        //                       hintText: 'Search', border: InputBorder.none),
        //                 ),
        //               ),
        //             ),
        //             const Icon(
        //               Icons.search,
        //               color: AppColor.backgroundColor,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     // const RecentChats(),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const ContactsScreen();
            }),
          ).then((value) => getLastConversation());
        },
        backgroundColor: AppColor.backgroundColor,
        child: const Icon(
          Icons.message,
        ),
      ),
    );
  }

  Widget _list(AuthState state) {
    return ListView.builder(
      itemCount: channelList.length,
      itemBuilder: (BuildContext context, int index) {
        final groupChannel = channelList[index];
        unreadCount = groupChannel.unreadMessageCount;
        final userIds = groupChannel.members.map((e) => e.userId).toList();
        userIds.sort((a, b) => a.compareTo(b));
        final senderId = groupChannel.lastMessage?.sender?.userId ?? '';
        final profileUrl = groupChannel.lastMessage?.sender?.profileUrl ?? '';

        String? lastMessage;
        if (groupChannel.lastMessage != null) {
          if (groupChannel.lastMessage is FileMessage) {
            lastMessage = (groupChannel.lastMessage! as FileMessage).name ?? '';
          } else {
            lastMessage = groupChannel.lastMessage!.message;
          }
        }

        return GestureDetector(
          onDoubleTap: () {
            // Get.toNamed('/group_channel/update/${groupChannel.channelUrl}')
            //     ?.then((groupChannel) {
            //   if (groupChannel != null) {
            //     for (int index = 0; index < channelList.length; index++) {
            //       if (channelList[index].channelUrl ==
            //           groupChannel.channelUrl) {
            //         setState(() => channelList[index] = groupChannel);
            //         break;
            //       }
            //     }
            //   }
            // });
          },
          onLongPress: () async {
            // await groupChannel.deleteChannel();
          },
          child: Column(
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: state is Authenticated
                        ? state.user.userInfo.username ==
                                groupChannel.members[0].userId
                            ? groupChannel.members[1].profileUrl
                            : groupChannel.members[0].profileUrl
                        : 'https://lh3.googleusercontent.com/EbXw8rOdYxOGdXEFjgNP8lh-YAuUxwhOAe2jhrz3sgqvPeMac6a6tHvT35V6YMbyNvkZL4R_a2hcYBrtfUhLvhf-N2X3OB9cvH4uMw=w1064-v0',
                    width: 30.w,
                    height: 30.h,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        state is Authenticated
                            ? state.user.userInfo.username ==
                                    groupChannel.members[0].userId
                                ? groupChannel.members[1].userId
                                : groupChannel.members[0].userId
                            : groupChannel.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: groupChannel.unreadMessageCount == 0
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: AppColor.backgroundColor,
                                width: 22,
                                height: 22,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  unreadCount.toString(),
                                  style: const TextStyle(
                                    color: AppColor.white,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: (lastMessage != null)
                          ? Row(
                              children: [
                                // Widgets.imageNetwork(
                                //     profileUrl, 16.0, Icons.account_circle),
                                // const Icon(Icons.account_circle, size: 16),
                                profileUrl.isNotEmpty
                                    ? Image.network(
                                        profileUrl,
                                        height: 16,
                                        fit: BoxFit.fitHeight,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                              Icons.account_circle,
                                              size: 16);
                                        },
                                      )
                                    : const Icon(
                                        Icons.account_circle,
                                      ),

                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      '$senderId: $lastMessage',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateTime.fromMillisecondsSinceEpoch(
                          groupChannel.createdAt! * 1000,
                        ).toString(),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (state is Authenticated) {
                    final other = userIds[0] == state.user.userInfo.username
                        ? userIds[1]
                        : userIds[0];
                    final otherimage = state.user.userInfo.username ==
                            groupChannel.members[0].userId
                        ? groupChannel.members[1].profileUrl
                        : groupChannel.members[0].profileUrl;
                    // final otherimage =
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ChatPageScreen(
                        userId: state.user.userInfo.username ?? '',
                        otherUserId: other,
                        title: other,
                        image: otherimage,
                      );
                    })).then((value) {
                      _refresh();
                      setState(() {
                        unreadCount = 0;
                      });
                    });
                  } else {
                    null;
                  }
                },
              ),
              const Divider(height: 1),
            ],
          ),
        );
      },
    );
  }

  Widget _moreButton() {
    return Container(
      width: double.maxFinite,
      height: 32.0,
      color: Colors.purple[200],
      child: IconButton(
        icon: const Icon(Icons.expand_more, size: 16.0),
        color: Colors.white,
        onPressed: () {
          if (collection.hasMore && !collection.isLoading) {
            collection.loadMore();
          }
        },
      ),
    );
  }

  void _refresh() {
    setState(() {
      channelList = collection.channelList;
      hasMore = collection.hasMore;
    });
  }
}

class MyGroupChannelCollectionHandler extends GroupChannelCollectionHandler {
  final _ChatHomeScreenState state;

  MyGroupChannelCollectionHandler(this.state);

  @override
  void onChannelsAdded(
      GroupChannelContext context, List<GroupChannel> channels) {
    state._refresh();
  }

  @override
  void onChannelsUpdated(
      GroupChannelContext context, List<GroupChannel> channels) {
    state._refresh();
  }

  @override
  void onChannelsDeleted(
      GroupChannelContext context, List<String> deletedChannelUrls) {
    state._refresh();
  }
}
