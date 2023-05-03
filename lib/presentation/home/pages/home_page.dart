import 'package:flutter/material.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/categories/main_categories.dart';
import 'package:netzoon/presentation/data/advertisments.dart';
import 'package:netzoon/presentation/data/categories.dart';
import 'package:netzoon/presentation/data/deals.dart';
import 'package:netzoon/presentation/data/devices.dart';
import 'package:netzoon/presentation/data/electronic_devices.dart';
import 'package:netzoon/presentation/data/food_products.dart';
import 'package:netzoon/presentation/data/men_fashion.dart';
import 'package:netzoon/presentation/data/news.dart';
import 'package:netzoon/presentation/data/perfumes.dart';
import 'package:netzoon/presentation/data/tenders.dart';
import 'package:netzoon/presentation/data/watches.dart';
import 'package:netzoon/presentation/data/woman_fashion.dart';
import 'package:netzoon/presentation/deals/deals_screen.dart';
import 'package:netzoon/presentation/ecommerce/screens/ecommerce.dart';
import 'package:netzoon/presentation/home/widgets/images_slider.dart';
import 'package:netzoon/presentation/home/widgets/list_of_categories.dart';
import 'package:netzoon/presentation/home/widgets/list_of_food_products.dart';
import 'package:netzoon/presentation/home/widgets/list_of_items.dart';
import 'package:netzoon/presentation/home/widgets/list_of_men_fashion.dart';
import 'package:netzoon/presentation/home/widgets/list_of_office_devices.dart';
import 'package:netzoon/presentation/home/widgets/list_of_perfumes.dart';
import 'package:netzoon/presentation/home/widgets/list_of_watches.dart';
import 'package:netzoon/presentation/home/widgets/list_of_woman_fashion.dart';
import 'package:netzoon/presentation/home/widgets/slider_news_widget.dart';
import 'package:netzoon/presentation/home/widgets/tender_widget.dart';
import 'package:netzoon/presentation/home/widgets/title_and_button.dart';
import 'package:netzoon/presentation/news/news_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final categories = cat;
  final electronicDevices = elecDevices;
  final homeDevices = devices;
  final menfasion = menFashion;
  final womanfashion = womanFashion;
  final foodproduct = foodProducts;
  final perfumeslist = perfumes;
  final tendersList = tenders;
  final dealslist = deals;
  final newsList = news;
  final watchesList = watches;
  final advertismentList = advertisments;
  final List<String> images = [
    'https://media.istockphoto.com/id/1311148884/vector/abstract-globe-background.jpg?s=612x612&w=0&k=20&c=9rVQfrUGNtR5Q0ygmuQ9jviVUfrnYHUHcfiwaH5-WFE=',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoY6ZAIPLpK4ibf35Va-S-MsDM2NM8AHocfOxHrj3C&s',
    'https://static.vecteezy.com/system/resources/thumbnails/004/216/831/original/3d-world-news-background-loop-free-video.jpg',
  ];
  final PageController controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleAndButton(
              title: 'الفئات',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const CategoriesMainScreen();
                  }),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfCategories(
                categories: categories,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TitleAndButton(
              title: 'التجارة الالكترونية',
              icon: true,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'الالكترونيات',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: elecDevices,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListofItems(devices: elecDevices),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'أجهزة المنزل والمكتب',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: devices,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfOfficeDevices(
                devices: homeDevices,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'موضة رجالية',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: menfasion,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfMenFashion(
                menfashion: menfasion,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'موضة نسائية',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: womanFashion,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfWomanFashion(
                womanFashion: womanFashion,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'المنتجات الغذائية',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: foodProducts,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfFoodProducts(
                foodProducts: foodproduct,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'العطور',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: perfumeslist,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfPerfumes(
                perfumes: perfumeslist,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'ساعات',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return CategoriesScreen(
                      items: watches,
                    );
                  }),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 209, 219, 235).withOpacity(0.8),
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              child: ListOfWatches(
                watches: watchesList,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'الإعلانات',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AdvertisingScreen(
                        advertisment: advertismentList,
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SliderImages(advertisments: advertismentList),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'المناقصات',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const DealsCategoriesScreen(
                        title: 'فئات المناقصات',
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: TenderWidget(
                tenders: tendersList,
                buttonText: 'بدء المناقصة',
                subTitle: 'اسم الشركة',
                desTitle1: 'تاريخ البدأ',
                desTitle2: 'تاريخ الانتهاء',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'الصفقات',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const DealsCategoriesScreen(
                        title: 'فئات الصفقات',
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: TenderWidget(
                tenders: dealslist,
                buttonText: 'شراء الصفقة',
                subTitle: 'البائع:',
                desTitle1: 'السعر قبل',
                desTitle2: 'السعر بعد',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TitleAndButton(
              title: 'الأخبار',
              icon: true,
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return NewsScreen(
                      news: newsList,
                    );
                  }),
                );
              },
            ),
            const SizedBox(
              height: 7.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: SliderNewsWidget(controller: controller, news: newsList),
            ),
          ],
        ),
      ),
    );
  }
}
