import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Category.dart';
import 'package:ultrapack_mobile/services/CategoryService.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  List<Category> _categories = [];
  Color currentColor = Colors.green;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void refresh() async {
    _categories = await CategoryService.fetchCategories();
    setState(() {});
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Categories')),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _categoryController,
                        decoration:
                            InputDecoration(hintText: 'Add a new category.'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category.';
                          }
                        },
                        // focusNode: _focusNode,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Select a color'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.colorize),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_outlined),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSubmitted(_categoryController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, int index) {
                    final String name = _categories[index].name;
                    final int id = _categories[index].id!;
                    final Color color = Color(_categories[index].tagColor);
                    return Chip(
                      backgroundColor: color,
                      label: Text('$name'),
                      onDeleted: () {
                        CategoryService.deleteCategory(id);
                        refresh();
                      },
                    );
                  }),
            )
          ],
        ));
  }

  void _handleSubmitted(String text) {
    _categoryController.clear();
    FocusScope.of(context).unfocus();
    CategoryService.addCategory(text, currentColor);
    refresh();
  }
}
