import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/models/Item.dart';
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
        Flexible(child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (context, int index) {
            final item = _inventory[index];
            return InventoryItem(item.name);
          },
          itemCount: _inventory.length,
        )),
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

  void _handleSubmitted(String text) {
    _textController.clear();
    // InventoryItem item = InventoryItem(text, 5);
    // setState(() {
    //   _items.insert(0, item);
    // });
    // Returns focus to text field
    _focusNode.requestFocus();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await db.query(Item.table);
    _inventory = _results.map((item) => Item.fromMap(item)).toList();
    setState(() {});
  }
}

class InventoryItem extends StatelessWidget{
  final String name;
  InventoryItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(name));
  }
}

