import 'package:flutter/material.dart';

Future<DateTime?> getDateFunction(
    {required BuildContext context,
    bool isOnlyFuture = false,
    bool isOldDate = false,
    bool isForAge = false}) async {
  print(isOnlyFuture ? DateTime.now() : DateTime(1900));
  return await showDatePicker(
      context: context,
      initialDate: isForAge
          ? DateTime.now().subtract(Duration(days: 16 * 365))
          : DateTime.now(),
      firstDate: isOnlyFuture
          ? DateTime.now()
          : DateTime(
              1900), //DateTime.now() - not to allow to choose before today.
      lastDate: isOldDate
          ? DateTime.now()
          : isForAge
              ? DateTime.now().subtract(Duration(days: 16 * 365))
              : DateTime(2101));
}

Future<DateTime?> getValidDateDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime startDate,
  required DateTime lastDate,
}) async {
  return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: startDate,
      lastDate: lastDate);
}
