import 'package:flutter/material.dart';
import 'package:netzoon/domain/categories/entities/factory.dart';
import 'package:netzoon/presentation/categories/widgets/factories_categories.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class FactoryScreen extends StatelessWidget {
  const FactoryScreen({
    super.key,
    required this.factory,
  });
  final List<Factory> factory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     " المصانع",
                //     style: TextStyle(fontSize: 20.sp, color: Colors.black),
                //   ),
                // ),
                Expanded(
                  child: ViewFactoriesWidget(
                    factory: factory,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
