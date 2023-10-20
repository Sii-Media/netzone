import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/constant/colors.dart';
import '../blocs/comments/comments_bloc.dart';

class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({
    super.key,
    required this.commentBloc,
    required this.newsId,
  });
  final CommentsBloc commentBloc;
  final String newsId;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              alignment: Alignment.centerRight,
              width: 250.w,
              child: TextFormField(
                controller: textController,
                style: const TextStyle(color: AppColor.black),
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate('Type Something'),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: GestureDetector(
              onTap: () {
                commentBloc.add(
                    AddCommentEvent(newsId: newsId, text: textController.text));
                textController.clear();
              },
              child: Icon(
                Icons.send,
                color: AppColor.backgroundColor,
                size: 25.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
