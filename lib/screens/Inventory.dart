import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/models/InventorySelections.dart';
import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../services/db.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final _textController = TextEditingController();
  final _weightController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  List<Item> _inventory = [];
  List<Item> _selections = [];

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inventory')),
      body: Column(children: [
        IconTheme(
          data: IconThemeData(color: Theme.of(context).accentColor),
          child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(10.0),
              // margin: EdgeInsets.all(10.0),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  print('delete btn');
                },
              )),
        ),
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          // reverse: true,
          itemBuilder: (context, int index) {
            final item = _inventory[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                print(item);
                db.delete(Item.table, item);
                refresh();
              },
              child: InventoryItem(item.name, item.weight),
            );
          },
          itemCount: _inventory.length,
        )),
        Divider(height: 10.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  Widget _buildTextComposer() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _textController,
                      // onSubmitted: _handleSubmitted,
                      decoration: InputDecoration(hintText: 'Add a new item.'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item.';
                        }
                      },
                      focusNode: _focusNode,
                    ),
                    Divider(
                      height: 1,
                    ),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(hintText: 'Weight (g)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a weight.';
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSubmitted(_textController.text,
                            int.tryParse(_weightController.text)!);
                      }
                    }))
          ],
        ));
  }

  void _handleSubmitted(String text, int weight) async {
    _textController.clear();
    _weightController.clear();
    Model item = Item(name: text, weight: weight);
    await db.insert(Item.table, item);
    setState(() {});
    refresh();
    _focusNode.requestFocus();
  }

  // void _deleteSelections() async {
  //   for (Model item in _selections) {
  //     db.delete(Item.table, item);
  //   }
  //   refresh();
  // }

  void refresh() async {
    List<Map<String, dynamic>> _results = await db.query(Item.table);
    _inventory = _results.map((item) => Item.fromMap(item)).toList();
    setState(() {});
  }
}

class InventoryItem extends StatefulWidget {
  final String name;
  final int weight;
  InventoryItem(this.name, this.weight);

  @override
  _InventoryItemState createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  bool? _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: [
          CheckboxListTile(
            title: Text('${widget.name}'),
            subtitle: Text('${widget.weight} g'),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value;
              });
              // var selections = context.read<InventorySelections>();
              // selections.add()
              print(this);
            },
            secondary: const Icon(Icons.wb_sunny),
          ),
          Divider(
            height: 2.0,
          )
        ]));
  }
}
