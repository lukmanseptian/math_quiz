import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MySnackbar {
  static SnackBar success({required String message}) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Sukses',
        message: message,
        contentType: ContentType.success,
        inMaterialBanner: true,
      ),
    );
  }

  static SnackBar failed({required String message}) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Oops',
        message: message,
        contentType: ContentType.failure,
        inMaterialBanner: true,
      ),
    );
  }
}
