import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/ecommerce/widgets/list_categories.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.items});

  final List<dynamic> items;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: ListCategoriesEcommerce(items: items),
        ),
      ),
    );
  }
}
