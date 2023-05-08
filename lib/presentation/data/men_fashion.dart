import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/men_fashion/entities/men_fashion_list.dart';

List<MenFashionList> menFashion = [
  const MenFashionList(
    name: 'ملابس رياضية',
    imgUrl:
        'https://img.freepik.com/premium-photo/sport-fashion-style-trend-man-tshirt-shorts-isolated-white-background-bearded-man-blue-casual-clothes-macho-active-wear-workout-training-fitness-gym-activity_474717-50973.jpg?w=360',
    deviceList: [
      ItemList(
        deviceName: 'رياضية',
        deviceImg:
            'https://img.freepik.com/premium-photo/sport-fashion-style-trend-man-tshirt-shorts-isolated-white-background-bearded-man-blue-casual-clothes-macho-active-wear-workout-training-fitness-gym-activity_474717-50973.jpg?w=360',
        price: '123',
        category: 'ملابس رياضية',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
        images: [
          'https://img.freepik.com/premium-photo/sport-fashion-style-trend-man-tshirt-shorts-isolated-white-background-bearded-man-blue-casual-clothes-macho-active-wear-workout-training-fitness-gym-activity_474717-50973.jpg?w=360'
        ],
        vedio: '',
      ),
    ],
  ),
  const MenFashionList(
    name: 'تيشيرتات',
    imgUrl: 'https://m.media-amazon.com/images/I/710oR+PvLUL._UL1212_.jpg',
    deviceList: [
      ItemList(
        deviceName: 'تيشيرت',
        deviceImg:
            'https://m.media-amazon.com/images/I/710oR+PvLUL._UL1212_.jpg',
        price: '123',
        category: 'تيشيرت',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
  const MenFashionList(
    name: 'بنطلونات',
    imgUrl:
        'https://previews.123rf.com/images/nanastudio/nanastudio1903/nanastudio190300704/119056220-a-stack-of-clothes-jeans-pants-on-a-white-background-isolation.jpg',
    deviceList: [
      ItemList(
        deviceName: 'بنطلون جينز',
        deviceImg:
            'https://previews.123rf.com/images/nanastudio/nanastudio1903/nanastudio190300704/119056220-a-stack-of-clothes-jeans-pants-on-a-white-background-isolation.jpg',
        price: '123',
        category: 'بنطلون جينز',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
];
