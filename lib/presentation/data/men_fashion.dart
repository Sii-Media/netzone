import 'package:netzoon/domain/men_fashion/entities/men_fashion.dart';
import 'package:netzoon/domain/men_fashion/entities/men_fashion_list.dart';

// List<MenFashion> menFashion = [
//   const MenFashion(
//       name: 'ملابس رياضية',
//       imgUrl:
//           'https://media.istockphoto.com/id/1125038961/photo/young-man-running-outdoors-in-morning.jpg?s=612x612&w=0&k=20&c=LVAlQIforg7ZRAF-bOvdvoD_k3ejEeimrWbGq2IA5ak='),
//   const MenFashion(
//       name: 'تيشيرتات',
//       imgUrl:
//           'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=600'),
//   const MenFashion(
//       name: 'بنطلونات',
//       imgUrl:
//           'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg?auto=compress&cs=tinysrgb&w=600'),
//   const MenFashion(
//       name: 'جواكيت',
//       imgUrl:
//           'https://images.pexels.com/photos/16170/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=600'),
// ];
List<MenFashionList> menFashion = [
  const MenFashionList(
    name: 'ملابس رياضية',
    imgUrl:
        'https://media.istockphoto.com/id/1125038961/photo/young-man-running-outdoors-in-morning.jpg?s=612x612&w=0&k=20&c=LVAlQIforg7ZRAF-bOvdvoD_k3ejEeimrWbGq2IA5ak=',
    deviceList: [
      MenFashion(
          deviceName: 'رياضية',
          deviceImg:
              'https://media.istockphoto.com/id/1125038961/photo/young-man-running-outdoors-in-morning.jpg?s=612x612&w=0&k=20&c=LVAlQIforg7ZRAF-bOvdvoD_k3ejEeimrWbGq2IA5ak='),
    ],
  ),
  const MenFashionList(
    name: 'تيشيرتات',
    imgUrl:
        'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      MenFashion(
        deviceName: 'تيشيرت',
        deviceImg:
            'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=600',
      ),
    ],
  ),
  const MenFashionList(
    name: 'بنطلونات',
    imgUrl:
        'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      MenFashion(
        deviceName: 'بنطلون جينز',
        deviceImg:
            'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg?auto=compress&cs=tinysrgb&w=600',
      ),
    ],
  ),
];
