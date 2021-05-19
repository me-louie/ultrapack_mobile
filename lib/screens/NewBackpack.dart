import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Backpack.dart';
import 'package:ultrapack_mobile/models/InventorySelections.dart';
import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:ultrapack_mobile/services/db.dart';
import 'package:provider/provider.dart';

import 'Inventory.dart';
import 'MyBackpack.dart';

class NewBackpack extends StatefulWidget {
  @override
  _NewBackpackState createState() => _NewBackpackState();
}

class _NewBackpackState extends State<NewBackpack> {
  int _index = 0;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  List<Item> _inventory = [];

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Item.table);
    _inventory = _results.map((item) => Item.fromMap(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return Scaffold(
        appBar: AppBar(title: Text('Pack a new Backpack')),
        body: Container(
            child: Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index <= 0) {
              Navigator.pop(context);
              return;
            }
            setState(() {
              _index--;
            });
          },
          onStepContinue: () async {
            if (formKeys[_index].currentState!.validate()) {
              if (_index >= 2) {
                String name = _nameController.text;
                String description = _descriptionController.text;
                Model backpack =
                    new Backpack(name: name, description: description);
                int backpackId = await DB.insert(Backpack.table, backpack);

                var selections = context.read<InventorySelections>();
                selections.addSelectionsToPack(backpackId);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyBackpack(backpackId, name, description)));
                return;
              }
              setState(() {
                _index++;
              });
            }
          },
          onStepTapped: (index) {
            if (index < _index) {
              setState(() {
                _index = index;
              });
            }
            if (formKeys[_index].currentState!.validate()) {
              setState(() {
                _index = index;
              });
            }
          },
          steps: [
            Step(
                title: Text('Name:'),
                isActive: _index >= 0,
                content: Form(
                  key: formKeys[0],
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                          controller: _nameController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.backpack_rounded),
                            hintText: 'Where are you bringing this pack?',
                          ),
                          focusNode: _focusNode)),
                )),
            Step(
                title: Text('Description'),
                isActive: _index >= 1,
                content: Form(
                  key: formKeys[1],
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: _descriptionController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Provide a short description.',
                        ),
                      )),
                )),
            Step(
                title: Text('Add items'),
                isActive: _index >= 2,
                content: Form(
                  key: formKeys[2],
                  child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                          itemCount: _inventory.length,
                          itemBuilder: (context, int index) {
                            return InventoryItem(
                                _inventory[index].id,
                                _inventory[index].name,
                                _inventory[index].weight);
                          })),
                ))
          ],
        )));
  }
}
