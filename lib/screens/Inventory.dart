import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Inventory extends StatelessWidget {
  // final List<InventoryItem> items;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inventory')),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        child: _buildTextComposer(),
      ),
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
}
