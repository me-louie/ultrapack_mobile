import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/providers/BackpacksModel.dart';
import 'package:ultrapack_mobile/providers/InventorySelections.dart';
import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:ultrapack_mobile/services/db.dart';

import 'EditInventoryItemDialog.dart';

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

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _weightController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inventory')),
      body: Column(children: [
        IconTheme(
          data: IconThemeData(color: Theme.of(context).accentColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    _openBackpackDialog();
                  },
                  child: Text('Add To Pack')),
              Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteSelections();
                    },
                  ))
            ],
          ),
        ),
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, int index) {
            final item = _inventory[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                DB.delete(Item.table, item);
                refresh();
              },
              child: GestureDetector(
                  onLongPress: () async {
                    //  _showEditDialog(item);
                    await showDialog(
                        context: context,
                        builder: (_) => EditInventoryItemDialog(
                            item: item,
                            updateInventoryList: () => {refresh()}));
                  },
                  child: InventoryItem(item.id, item.name, item.weight)),
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
                    icon: const Icon(Icons.add_outlined),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSubmitted(_textController.text,
                            int.tryParse(_weightController.text)!);
                      }
                    }))
          ],
        ));
  }

  Future<void> _openBackpackDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: Text('Backpacks'), children: <Widget>[
            Consumer<BackpacksModel>(
              builder: (context, backpacks, child) => Column(
                children: List.generate(
                    backpacks.length,
                    (index) => SimpleDialogOption(
                        onPressed: () {
                          var selections = context.read<InventorySelections>();
                          selections.addSelectionsToPack(
                              backpacks.getBackpacks[index].id!);
                          refresh();
                          Navigator.pop(context);
                          final snackBar = SnackBar(
                              content: Text(
                                  'Items added to ${backpacks.getBackpacks[index].name}'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Text(backpacks.getBackpacks[index].name))),
              ),
            )
          ]);
        });
  }

  void _handleSubmitted(String text, int weight) async {
    _textController.clear();
    _weightController.clear();
    Model item = Item(name: text, weight: weight);
    await DB.insert(Item.table, item);
    setState(() {});
    refresh();
    _focusNode.requestFocus();
  }

  void _deleteSelections() async {
    var selections = context.read<InventorySelections>();
    for (int id in selections.inventorySelections) {
      DB.deleteById(Item.table, id);
    }
    refresh();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Item.table);
    _inventory = _results.map((item) => Item.fromMap(item)).toList();
    setState(() {});
  }
}

class InventoryItem extends StatefulWidget {
  final int? id;
  final String name;
  final int weight;

  InventoryItem(this.id, this.name, this.weight);

  @override
  _InventoryItemState createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  bool? _isChecked;
  @override
  Widget build(BuildContext context) {
    var selections = context.read<InventorySelections>();
    _isChecked = selections.contains(widget.id!);

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
              var selections = context.read<InventorySelections>();
              selections.toggleSelection(widget.id!);
            },
            secondary: const Icon(Icons.wb_sunny),
          ),
          Divider(
            height: 2.0,
          )
        ]));
  }
}
