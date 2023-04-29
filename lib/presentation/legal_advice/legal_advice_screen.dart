import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class LegalAdviceScreen extends StatelessWidget {
  const LegalAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController search = TextEditingController();

    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration:
                      const BoxDecoration(color: AppColor.backgroundColor),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/00.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.white,
                            suffixIcon: InkWell(
                                child: const Icon(Icons.search), onTap: () {}),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            hintText: 'البحث في netzoon.com',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                              fontSize: 8.sp,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 135.w,
                      height: 130.h,
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 150.h,
                child: Center(
                  child: Text(
                    'استشارات قانونية',
                    style: TextStyle(fontSize: 22.sp, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 202.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: size.height - 200.h,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 12.h),
                      child: Text(
                        'تؤمن دولة الإمارات بضرورة تقديم المساعدة القانونية والقضائية للذين لا يستطيعون تحمل الرسوم القانونية. ووفقا لدستور الدولة، يحب أن يكون للجميع الحق والقدرة على توكيل محامي يملك القدرة للدفاع عنهم أثناء المحاكمة، ويجب ألا تشكل الظروف الاقتصادية والاجتماعية عائقا يمنع أي شخص من سهولة الوصول إلى العدالة.قانوني في عونك تقدم وزارة العدل خدمة مجانية في الاستشارات القانونية وترجمة المستندات المقدمة الى المحاكم للغير قادرين على الدفع. تم إنشاء قسم المساعدات القانونية بدائرة القضاء أبو ظبي بهدف توفير المساعدة القانونية المجانية لغير ميسوري الحال، والتوجيه القانوني المحايد لمراجعي الدائرة لدعم حقهم في سهولة الوصول إلى العدالة، سواء قبل رفع الدعوى أو خلالها مهما كان مركزهم القانوني فيها وتأتي هذه المبادرة تنفيذاً للموجهات الدستورية لدستور دولة الإمارات، والتي تقضي بأن يجد كل إنسان طريقاً ميسوراً للوصول إلى قاضيه الطبيعي، وألا تحول الظروف الاقتصادية أو الاجتماعية لأي شخص من وصوله إلى العدالة. وتشمل الخدمات المقدمة كل من التوجيه والإرشاد القانوني، وطلب تكليف محامي، ونفقات أمانة الخبرة، ونفقات الإعلان بالنشر. ويتم تقييم إمكانية تقديم هذه الخدمات للمستفيد وفقاً لمعايير الاستحقاق المتمثلة في جدية الطلب ومعيار الدخل.',
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
