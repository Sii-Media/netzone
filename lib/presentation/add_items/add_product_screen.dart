import 'package:flutter/material.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Container(),
        ),
      ),
    );
  }
}
