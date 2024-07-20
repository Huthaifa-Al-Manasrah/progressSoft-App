import 'package:flutter/material.dart';

class SnackBarMessage {
  void showSuccessSnackBar({required String message, required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.blue));
  }

  void showErrorSnackBar({required String message, required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }
}