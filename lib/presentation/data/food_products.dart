import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';
import 'package:netzoon/domain/food_products/entities/food_products_list.dart';

List<FoodProductList> foodProducts = [
  const FoodProductList(
    name: 'مشروبات',
    imgUrl:
        'https://images.pexels.com/photos/110472/pexels-photo-110472.jpeg?auto=compress&cs=tinysrgb&w=600',
    deviceList: [
      ItemList(
        deviceName: 'مشروبات',
        deviceImg:
            'https://images.pexels.com/photos/110472/pexels-photo-110472.jpeg?auto=compress&cs=tinysrgb&w=600',
        price: '123',
        category: 'مشروبات',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
  const FoodProductList(
    name: 'لحوم',
    imgUrl:
        'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8bWVhdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    deviceList: [
      ItemList(
        deviceName: 'لحوم',
        deviceImg:
            'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8bWVhdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        price: '123',
        category: 'لحوم',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
  const FoodProductList(
    name: 'مجمدات',
    imgUrl:
        'https://images.unsplash.com/photo-1629037713217-fdb10c3684bb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGNhbm5lZCUyMGZvb2R8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
    deviceList: [
      ItemList(
        deviceName: 'مجمدات',
        deviceImg:
            'https://images.unsplash.com/photo-1629037713217-fdb10c3684bb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGNhbm5lZCUyMGZvb2R8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        price: '123',
        category: 'مجمدات',
        description: 'بعض التفاصيل',
        year: '2021',
        property: 'بعض الخواص',
      ),
    ],
  ),
];
