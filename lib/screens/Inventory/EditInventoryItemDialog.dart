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
  List<Category> _categories = [];

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
    _categories = await CategoryService.fetchCategories();
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
                children: List.generate(_categories.length, (int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(_categories[index].name),
                  backgroundColor: Color(_categories[index].tagColor),
                  selected: false,
                  onSelected: (bool value) {
                    print(value);
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
            if (initialName != _editNameController.text ||
                initialWeight != _editWeightController.text) {
              Model updated = Item(
                  id: widget.item.id,
                  name: _editNameController.text,
                  weight: int.tryParse(_editWeightController.text)!);
              DB.update(Item.table, updated);
              widget.updateInventoryList();
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    //   },
    // );
  }
  // }
}
