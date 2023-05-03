import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/perfumes/entities/perfume_list.dart';

List<PerfumeList> perfumes = [
  const PerfumeList(
    name: 'عطور',
    imgUrl:
        'https://c8.alamy.com/comp/KH07DT/variety-of-perfume-bottles-over-white-background-with-clipping-path-KH07DT.jpg',
    deviceList: [
      ItemList(
        deviceName: 'عطور',
        deviceImg:
            'https://c8.alamy.com/comp/KH07DT/variety-of-perfume-bottles-over-white-background-with-clipping-path-KH07DT.jpg',
        price: '123',
        category: 'عطور',
        description: 'وصف للعطور',
        year: '2021',
        property: 'بعض الخواص',
        images: [],
        vedio: '',
      ),
    ],
  ),
];
