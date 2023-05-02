import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/men_fashion/entities/men_fashion_list.dart';

List<MenFashionList> menFashion = [
  const MenFashionList(
    name: 'ملابس رياضية',
    imgUrl:
        'https://media.istockphoto.com/id/1125038961/photo/young-man-running-outdoors-in-morning.jpg?s=612x612&w=0&k=20&c=LVAlQIforg7ZRAF-bOvdvoD_k3ejEeimrWbGq2IA5ak=',
    deviceList: [
      ItemList(
        deviceName: 'رياضية',
        deviceImg:
            'https://media.istockphoto.com/id/1125038961/photo/young-man-running-outdoors-in-morning.jpg?s=612x612&w=0&k=20&c=LVAlQIforg7ZRAF-bOvdvoD_k3ejEeimrWbGq2IA5ak=',
        price: '123',
        category: 'ملابس رياضية',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
  const MenFashionList(
    name: 'تيشيرتات',
    imgUrl:
        'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      ItemList(
        deviceName: 'تيشيرت',
        deviceImg:
            'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=600',
        price: '123',
        category: 'تيشيرت',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
  const MenFashionList(
    name: 'بنطلونات',
    imgUrl:
        'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      ItemList(
        deviceName: 'بنطلون جينز',
        deviceImg:
            'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg?auto=compress&cs=tinysrgb&w=600',
        price: '123',
        category: 'بنطلون جينز',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
];
