import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultrapack_mobile/models/Category.dart';
import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:ultrapack_mobile/services/CategoryService.dart';
import 'package:ultrapack_mobile/services/db.dart';

class EditInventoryItemDialog extends StatefulWidget {
  final Item item;
  final Function updateInventoryList;

  EditInventoryItemDialog(
      {required this.item, required this.updateInventoryList});

  @override
  _EditInventoryItemDialogState createState() =>
      _EditInventoryItemDialogState();
}

class _EditInventoryItemDialogState extends State<EditInventoryItemDialog> {
  final _editNameController = TextEditingController();
  final _editWeightController = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _selectedCategories = [];
  Set<Category> _initialCategorySet = {};

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editWeightController.dispose();
    super.dispose();
  }

  void refresh() async {
    _allCategories = await CategoryService.fetchCategories();
    _selectedCategories =
        await CategoryService.getItemCategories(widget.item.id!);
    _initialCategorySet = _selectedCategories.toSet();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String initialName = widget.item.name;
    String initialWeight = widget.item.weight.toString();

    _editNameController.text = initialName;
    _editWeightController.text = initialWeight;

    return AlertDialog(
      title: Text('Edit'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
              controller: _editNameController,
              decoration: InputDecoration(
                icon: Icon(Icons.backpack_rounded),
                border: UnderlineInputBorder(),
                labelText: 'Item',
              ),
            ),
            TextFormField(
              controller: _editWeightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  icon: Icon(Icons.fitness_center),
                  border: UnderlineInputBorder(),
                  labelText: 'Weight (g)'),
            ),
            Wrap(
                children: List.generate(_allCategories.length, (int i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(_allCategories[i].name),
                  backgroundColor: Color(_allCategories[i].tagColor),
                  selected: _selectedCategories.contains(_allCategories[i]),
                  onSelected: (bool value) {
                    if (value) {
                      _selectedCategories.add(_allCategories[i]);
                    } else {
                      _selectedCategories.remove(_allCategories[i]);
                    }
                    setState(() {});
                    print('ON CLICK, # selected:');
                    print(_selectedCategories.length);
                  },
                ),
              );
            }))
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          style: TextButton.styleFrom(primary: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            _updateCategories();
            _updateItem(initialName, initialWeight);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    //   },
    // );
  }

  Future<List<Object?>?> _updateCategories() async {
    Set<Category> _selectedSet = _selectedCategories.toSet();
    if (_selectedSet.containsAll(_initialCategorySet) &&
        _initialCategorySet.containsAll(_selectedSet)) {
      return null;
    }
    Set<Category> catsToAdd = _selectedSet.difference(_initialCategorySet);
    Set<Category> catsToRemove = _initialCategorySet.difference(_selectedSet);
    return await CategoryService.updateItemCategories(
        widget.item.id!, catsToAdd, catsToRemove);
  }

  void _updateItem(String initialName, String initialWeight) {
    if (initialName != _editNameController.text ||
        initialWeight != _editWeightController.text) {
      Model updated = Item(
          id: widget.item.id,
          name: _editNameController.text,
          weight: int.tryParse(_editWeightController.text)!);
      DB.update(Item.table, updated);
      widget.updateInventoryList();
    }
  }
}
