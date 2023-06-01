import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.failure,
    required this.onPressed,
  });

  final String failure;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            failure,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
      ),
    );
  }
}
