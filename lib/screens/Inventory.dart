import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:flutter/scheduler.dart' show timeDilation;


import '../services/db.dart';

class Inventory extends StatefulWidget {
  // final List<InventoryItem> items;
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Item> _inventory = [];

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
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          // reverse: true,
          itemBuilder: (context, int index) {
            final item = _inventory[index];
            return InventoryItem(item.name, item.weight);
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
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Add a new item'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _handleSubmitted(_textController.text)))
          ],
        ));
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    Model item = Item(name: text, weight: 5);
    await db.insert(Item.table, item);
    setState(() {});
    refresh();
    _focusNode.requestFocus();
  }

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
  bool ? _isChecked = false;
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
            },
            secondary: const Icon(Icons.wb_sunny),
          ),
          Divider(
            height: 2.0,
          )
        ]));
  }
}
