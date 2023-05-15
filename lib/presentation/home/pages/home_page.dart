import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/categories/main_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
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
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/blocs/deals_list_widget.dart';
import 'package:netzoon/presentation/deals/deals_screen.dart';
import 'package:netzoon/presentation/ecommerce/screens/ecommerce.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';
import 'package:netzoon/presentation/home/widgets/images_slider.dart';
import 'package:netzoon/presentation/home/widgets/list_of_categories.dart';
import 'package:netzoon/presentation/home/widgets/list_of_items.dart';
import 'package:netzoon/presentation/home/widgets/slider_news_widget.dart';
import 'package:netzoon/presentation/home/widgets/tender_widget.dart';
import 'package:netzoon/presentation/home/widgets/title_and_button.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/news/news_screen.dart';
import 'package:netzoon/presentation/tenders/blocs/tendersItem/tenders_item_bloc.dart';
import 'package:netzoon/presentation/tenders/tender_categories_screen.dart';

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

  final newsBloc = sl<NewsBloc>();
  final tenderItemBloc = sl<TendersItemBloc>();
  final dealsItemBloc = sl<DealsItemsBloc>();
  final elcDeviceBloc = sl<ElecDevicesBloc>();
  final deviceBloc = sl<ElecDevicesBloc>();
  final manFashionBloc = sl<ElecDevicesBloc>();
  final womanFashionBloc = sl<ElecDevicesBloc>();
  final foodsBloc = sl<ElecDevicesBloc>();
  final perfumesBloc = sl<ElecDevicesBloc>();
  final watchesBloc = sl<ElecDevicesBloc>();

  @override
  void initState() {
    newsBloc.add(GetAllNewsEvent());
    tenderItemBloc.add(const GetTendersItemEvent());
    dealsItemBloc.add(GetDealsItemEvent());
    elcDeviceBloc.add(const GetElcDevicesEvent(department: 'Elec'));
    deviceBloc.add(const GetElcDevicesEvent(department: 'Devices'));
    manFashionBloc.add(const GetElcDevicesEvent(department: 'MenFashion'));
    womanFashionBloc.add(const GetElcDevicesEvent(department: 'WomanFashion'));
    foodsBloc.add(const GetElcDevicesEvent(department: 'Foods'));
    perfumesBloc.add(const GetElcDevicesEvent(department: 'Perfumes'));
    watchesBloc.add(const GetElcDevicesEvent(department: 'Watches'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        newsBloc.add(GetAllNewsEvent());
        tenderItemBloc.add(const GetTendersItemEvent());
        dealsItemBloc.add(GetDealsItemEvent());
        elcDeviceBloc.add(const GetElcDevicesEvent(department: 'Elec'));
        deviceBloc.add(const GetElcDevicesEvent(department: 'Devices'));
        manFashionBloc.add(const GetElcDevicesEvent(department: 'MenFashion'));
        womanFashionBloc
            .add(const GetElcDevicesEvent(department: 'WomanFashion'));
        foodsBloc.add(const GetElcDevicesEvent(department: 'Foods'));
        perfumesBloc.add(const GetElcDevicesEvent(department: 'Perfumes'));
        watchesBloc.add(const GetElcDevicesEvent(department: 'Watches'));
      },
      color: AppColor.white,
      backgroundColor: AppColor.backgroundColor,
      child: SingleChildScrollView(
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
                        filter: 'Elec',
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: elcDeviceBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'Elec',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        filter: 'Devices',
                        items: devices,
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: deviceBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'Devices',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        filter: 'MenFashion',
                        items: menfasion,
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: manFashionBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'MenFashion',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        filter: 'WomanFashion',
                        items: womanFashion,
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: womanFashionBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'WomanFashion',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        filter: 'Foods',
                        items: foodProducts,
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: foodsBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'Foods',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        filter: 'Perfumes',
                        items: perfumeslist,
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: perfumesBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'Perfumes',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        filter: 'Watches',
                        items: watches,
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: watchesBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 219, 235)
                            .withOpacity(0.8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: ListofItems(
                        filter: 'Watches',
                        // devices: elecDevices,
                        elec: state.elecDevices,
                      ),
                    );
                  }
                  return Container();
                },
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
                        return const TenderCategoriesScreen(
                          title: 'فئات المناقصات',
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: BlocBuilder<TendersItemBloc, TendersItemState>(
                    bloc: tenderItemBloc,
                    builder: (context, state) {
                      if (state is TendersItemInProgress) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.backgroundColor,
                          ),
                        );
                      } else if (state is TendersItemFailure) {
                        final failure = state.message;
                        return Center(
                          child: Text(
                            failure,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else if (state is TendersItemSuccess) {
                        return TenderWidget(
                          tenders: state.tenderItems,
                          buttonText: 'بدء المناقصة',
                          subTitle: 'اسم الشركة',
                          desTitle1: 'تاريخ البدأ',
                          desTitle2: 'تاريخ الانتهاء',
                        );
                      }
                      return Container();
                    },
                  )),
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
                child: BlocBuilder<DealsItemsBloc, DealsItemsState>(
                  bloc: dealsItemBloc,
                  builder: (context, state) {
                    if (state is DealsItemsInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      );
                    } else if (state is DealsItemsFailure) {
                      final failure = state.message;
                      return Center(
                        child: Text(
                          failure,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    } else if (state is DealsItemsSuccess) {
                      return DealsListWidget(
                        deals: state.dealsItems,
                        buttonText: 'شراء الصفقة',
                        subTitle: 'البائع:',
                        desTitle1: 'السعر قبل',
                        desTitle2: 'السعر بعد',
                      );
                    }
                    return Container();
                  },
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
              BlocBuilder<NewsBloc, NewsState>(
                bloc: newsBloc,
                builder: (context, state) {
                  if (state is NewsInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is NewsFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is NewsSuccess) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: SliderNewsWidget(
                          controller: controller, news: state.news),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
