import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/woman_fashion/entities/woman_fashion_list.dart';

List<WomanFashionList> womanFashion = [
  const WomanFashionList(
    name: 'فساتين',
    imgUrl:
        'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZHJlc3Nlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    deviceList: [
      DeviceList(
        deviceName: 'فساتين',
        deviceImg:
            'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZHJlc3Nlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
      ),
    ],
  ),
  const WomanFashionList(
    name: 'بلايز',
    imgUrl:
        'https://images.pexels.com/photos/428338/pexels-photo-428338.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      DeviceList(
        deviceName: 'بلوزة',
        deviceImg:
            'https://images.pexels.com/photos/428338/pexels-photo-428338.jpeg?auto=compress&cs=tinysrgb&w=600',
      ),
    ],
  ),
];
