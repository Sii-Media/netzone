import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/watches/entities/watches_list.dart';

List<WatchesList> watches = [
  const WatchesList(
    name: 'رقمية',
    imgUrl:
        'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZGlnaXRhbCUyMHdhdGNofGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    deviceList: [
      ItemList(
        deviceName: 'رقمية',
        deviceImg:
            'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZGlnaXRhbCUyMHdhdGNofGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        price: '123',
        category: 'ساعة رقمية',
        description: 'بعض التفاصيل للساعة',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
  const WatchesList(
    name: 'سوار معدني',
    imgUrl:
        'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHdhdGNofGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    deviceList: [
      ItemList(
        deviceName: 'سوار معدني',
        deviceImg:
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHdhdGNofGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        price: '123',
        category: 'سوار معدني',
        description: 'بعض التفاصيل للساعة',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
];
