import 'package:flutter/material.dart';
import 'package:netzoon/presentation/categories/widgets/list_gridview.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class CategoriesMainScreen extends StatelessWidget {
  const CategoriesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: const SizedBox(
          child: ListGridView(),
        ),
      ),
    );
  }
}
