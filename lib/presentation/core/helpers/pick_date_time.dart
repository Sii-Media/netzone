import 'package:flutter/material.dart';

Future<DateTime?> pickDate(
        {required BuildContext context, required DateTime initialDate}) =>
    showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
