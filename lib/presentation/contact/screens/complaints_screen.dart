import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/complaints/entities/complaints.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/contact/blocs/add_complaint/add_complaint_bloc.dart';
import 'package:netzoon/presentation/contact/blocs/get_complaints/get_complaint_bloc.dart';
import 'package:netzoon/presentation/contact/widgets/questionformfield.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/map_to_date.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen>
    with ScreenLoader<ComplaintsScreen> {
  final getComplaitBloc = sl<GetComplaintBloc>();
  final addComplainBloc = sl<AddComplaintBloc>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _textFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController textController = TextEditingController();
  final GlobalKey<FormFieldState> _addressFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    getComplaitBloc.add(GetComplaintsRequested());
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BackgroundWidget(
        widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<AddComplaintBloc, AddComplaintState>(
              bloc: addComplainBloc,
              listener: (context, state) {
                if (state is AddComplaintInProgress) {
                  startLoading();
                } else if (state is AddComplaintFailure) {
                  stopLoading();

                  final failure = state.message;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        failure,
                        style: const TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                      backgroundColor: AppColor.red,
                    ),
                  );
                } else if (state is AddComplaintSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'success',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  getComplaitBloc.add(GetComplaintsRequested());
                },
                color: AppColor.white,
                backgroundColor: AppColor.backgroundColor,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 13.sp,
                              color: AppColor.backgroundColor,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'الشكاوى',
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        QuestionFormField(
                          textController: addressController,
                          hintText: 'العنوان',
                          onChanged: (text) {
                            _addressFormFieldKey.currentState?.validate();
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        QuestionFormField(
                          textController: textController,
                          hintText: 'الموضوع',
                          onChanged: (text) {
                            _textFormFieldKey.currentState?.validate();
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'هذا الحقل مطلوب';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              onTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                addComplainBloc.add(PostComplaintEvent(
                                    address: addressController.text,
                                    text: textController.text));
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30.h,
                                width: 130.w,
                                color: AppColor.backgroundColor,
                                child: Center(
                                  child: Text(
                                    'إرسال',
                                    style: TextStyle(
                                        fontSize: 13.sp, color: AppColor.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        BlocBuilder<GetComplaintBloc, GetComplaintState>(
                          bloc: getComplaitBloc,
                          builder: (context, state) {
                            if (state is GetComplaintInProgress) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.backgroundColor,
                                ),
                              );
                            } else if (state is GetComplaintFailure) {
                              final failure = state.message;
                              return Center(
                                child: Text(
                                  failure,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25.sp,
                                  ),
                                ),
                              );
                            } else if (state is GetComplaintSuccess) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: state.complaints.length,
                                itemBuilder: (context, index) {
                                  return ComplaintsDetails(
                                    complaints: state.complaints[index],
                                    num: index + 1,
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class ComplaintsDetails extends StatelessWidget {
  final Complaints complaints;
  final int num;
  const ComplaintsDetails({
    super.key,
    required this.complaints,
    required this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TitleAndNumber(
            title: 'الرقم',
            number: '$num',
          ),
          SizedBox(
            height: 20.h,
          ),
          TitleAndNumber(
            title: 'بتاريخ',
            number: formatDate(complaints.createdAt ?? ''),
          ),
          SizedBox(
            height: 20.h,
          ),
          TitleAndNumber(
            title: 'العنوان',
            number: complaints.address,
          ),
          SizedBox(
            height: 20.h,
          ),
          TitleAndNumber(
            title: 'الرد',
            number: complaints.reply ?? 'لا يوجد رد الى الان',
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

class TitleAndNumber extends StatelessWidget {
  const TitleAndNumber({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 14.sp,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              color: AppColor.black,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
