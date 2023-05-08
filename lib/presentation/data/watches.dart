import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/watches/entities/watches_list.dart';

List<WatchesList> watches = [
  const WatchesList(
    name: 'رقمية',
    imgUrl:
        'https://media.gq.com/photos/628fb606ef6cfbae4e494244/master/w_2000,h_1333,c_limit/watch-7.jpg',
    deviceList: [
      ItemList(
        deviceName: 'رقمية',
        deviceImg:
            'https://media.gq.com/photos/628fb606ef6cfbae4e494244/master/w_2000,h_1333,c_limit/watch-7.jpg',
        price: '123',
        category: 'ساعة رقمية',
        description: 'بعض التفاصيل للساعة',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
  const WatchesList(
    name: 'سوار معدني',
    imgUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2ZK0ngTmb14y5Z228lsCW7bovEX13rt0Q-x8wxLGMnqNeh2zhKS8lTkp_1eTpm38iuPk&usqp=CAU',
    deviceList: [
      ItemList(
        deviceName: 'سوار معدني',
        deviceImg:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2ZK0ngTmb14y5Z228lsCW7bovEX13rt0Q-x8wxLGMnqNeh2zhKS8lTkp_1eTpm38iuPk&usqp=CAU',
        price: '123',
        category: 'سوار معدني',
        description: 'بعض التفاصيل للساعة',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
];
