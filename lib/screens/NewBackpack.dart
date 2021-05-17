import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Backpack.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:ultrapack_mobile/services/db.dart';

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
    GlobalKey<FormState>()
  ];

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
          onStepContinue: () {
            if (formKeys[_index].currentState!.validate()) {
              if (_index >= 1) {
                print('last');
                String name = _nameController.text;
                String description = _descriptionController.text;
                Model backpack = new Backpack(
                    name: name, description: description, weight: 0);
                DB.insert(Backpack.table, backpack);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyBackpack(name, description, 0)));
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
          ],
        )));
  }
}
