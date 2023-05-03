import 'package:netzoon/domain/devices/entities/device.dart';
import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';

List<Device> devices = [
  const Device(
    name: 'حواسيب',
    imgUrl:
        'https://media.istockphoto.com/id/1140541722/photo/modern-laptop-on-white-background.jpg?s=170667a&w=0&k=20&c=T00CzYcAaqwrlZHuF1UgioIorHni-wy-AJ22rhOYt4I=',
    deviceList: [
      ItemList(
        deviceName: 'Mac',
        deviceImg:
            'https://media.istockphoto.com/id/1140541722/photo/modern-laptop-on-white-background.jpg?s=170667a&w=0&k=20&c=T00CzYcAaqwrlZHuF1UgioIorHni-wy-AJ22rhOYt4I=',
        price: '123',
        category: 'حواسيب',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
        images: [
          'https://media.istockphoto.com/id/1140541722/photo/modern-laptop-on-white-background.jpg?s=170667a&w=0&k=20&c=T00CzYcAaqwrlZHuF1UgioIorHni-wy-AJ22rhOYt4I='
        ],
        vedio: '',
      ),
    ],
  ),
  const Device(
    name: 'طاولات',
    imgUrl:
        'https://media.istockphoto.com/id/941224542/vector/real-wood-table-on-a-white-background.jpg?s=170667a&w=0&k=20&c=bR59-yb-Xc-BM2zPNv-SJDuy6KSpWxoNgUGAthxTxmY=',
    deviceList: [
      ItemList(
        deviceName: 'طاولة خشبية',
        deviceImg:
            'https://media.istockphoto.com/id/941224542/vector/real-wood-table-on-a-white-background.jpg?s=170667a&w=0&k=20&c=bR59-yb-Xc-BM2zPNv-SJDuy6KSpWxoNgUGAthxTxmY=',
        price: '123',
        category: 'pc',
        description: 'this is the pc of the year',
        images: [],
        vedio: '',
      ),
    ],
  ),
  const Device(
    name: 'كراسي',
    imgUrl: 'https://m.media-amazon.com/images/I/51yifZpYZUL._AC_SY450_.jpg',
    deviceList: [
      ItemList(
        deviceName: 'كرسي',
        deviceImg:
            'https://m.media-amazon.com/images/I/51yifZpYZUL._AC_SY450_.jpg',
        price: '123',
        category: 'pc',
        description: 'this is the pc of the year',
        images: [],
        vedio: '',
      ),
    ],
  ),
];
