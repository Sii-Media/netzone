import 'package:netzoon/domain/devices/entities/device.dart';
import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';

List<Device> devices = [
  const Device(
    name: 'حواسيب',
    imgUrl:
        'https://images.pexels.com/photos/777001/pexels-photo-777001.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      ItemList(
        deviceName: 'Mac',
        deviceImg:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bWFjfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        price: '123',
        category: 'حواسيب',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
  const Device(
    name: 'طاولات',
    imgUrl:
        'https://images.pexels.com/photos/159213/hall-congress-architecture-building-159213.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      ItemList(
        deviceName: 'طاولة طعام',
        deviceImg:
            'https://cdn.decoist.com/wp-content/uploads/2014/03/Beautiful-dining-table-in-wood.jpg',
        price: '123',
        category: 'pc',
        description: 'this is the pc of the year',
      ),
    ],
  ),
  const Device(
    name: 'كراسي',
    imgUrl:
        'https://images.pexels.com/photos/416320/pexels-photo-416320.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      ItemList(
        deviceName: 'كرسي',
        deviceImg:
            'https://images.pexels.com/photos/416320/pexels-photo-416320.jpeg?auto=compress&cs=tinysrgb&w=600',
        price: '123',
        category: 'pc',
        description: 'this is the pc of the year',
      ),
    ],
  ),
];
