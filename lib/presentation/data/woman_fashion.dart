import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/woman_fashion/entities/woman_fashion_list.dart';

List<WomanFashionList> womanFashion = [
  const WomanFashionList(
    name: 'فساتين',
    imgUrl:
        'https://thumbs.dreamstime.com/z/black-polka-dot-retro-dress-white-background-35673897.jpg',
    deviceList: [
      ItemList(
        deviceName: 'فساتين',
        deviceImg:
            'https://thumbs.dreamstime.com/z/black-polka-dot-retro-dress-white-background-35673897.jpg',
        price: '123',
        category: 'فساتين',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
  const WomanFashionList(
    name: 'بلايز',
    imgUrl:
        'https://previews.123rf.com/images/windu/windu1203/windu120300008/12918952-women-t-shirt-isolated-on-white-background.jpg',
    deviceList: [
      ItemList(
        deviceName: 'بلوزة',
        deviceImg:
            'https://previews.123rf.com/images/windu/windu1203/windu120300008/12918952-women-t-shirt-isolated-on-white-background.jpg',
        price: '123',
        category: 'pc',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
];
