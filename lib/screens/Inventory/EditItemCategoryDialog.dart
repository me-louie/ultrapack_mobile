import 'package:flutter/material.dart';

class EditItemCategoryDialog extends StatefulWidget {
  @override
  _EditItemCategoryDialogState createState() => _EditItemCategoryDialogState();
}

class _EditItemCategoryDialogState extends State<EditItemCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text('Edit categories'));
  }
}
