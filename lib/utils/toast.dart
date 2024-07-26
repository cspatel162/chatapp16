
import 'package:chatapp16/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void showToast(String message, {bool isError = true}) {
  HapticFeedback.lightImpact();
  Get.showSnackbar(GetSnackBar(
    backgroundColor: isError ? Colors.red : Colors.black,
    message: message.tr,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}

void successToast(String message) {
  HapticFeedback.lightImpact();
  Get.showSnackbar(GetSnackBar(
    backgroundColor: Colors.green,
    message: message.tr,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}

Future<bool> clearCartAlert() async {
  HapticFeedback.lightImpact();
  bool clean = false;
  await Get.generalDialog(
    pageBuilder: (context, __, ___) => AlertDialog(
      title: Text('Warning'.tr),
      content: Text("_____ add Text ____ ".tr),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            clean = false;
          },
          child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium')),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            clean = true;
          },
          child: Text('Clear Cart'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
        )
      ],
    ),
  );
  return clean;
}
