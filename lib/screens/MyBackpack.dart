import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/ItemsBackpacks.dart';
import 'package:ultrapack_mobile/services/db.dart';

class MyBackpack extends StatefulWidget {
  final String name;
  final String description;
  final int id;

  MyBackpack(this.id, this.name, this.description);

  @override
  _MyBackpackState createState() => _MyBackpackState();
}

class _MyBackpackState extends State<MyBackpack> {
  List<Item> _items = [];
  int _weight = 0;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.getBackpackItems(widget.id);
    _items = _results.map((item) => Item.fromMap(item)).toList();
    _weight = await DB.getBackpackWeight(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.name}'),
        ),
        body: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.backpack_rounded),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('Pack Weight (g): $_weight')],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      padding: EdgeInsets.all(4.0),
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              print(_items[index].id);
                              DB.deleteBackpackItem(ItemsBackpacks.table,
                                  _items[index].id!, widget.id);
                              refresh();
                            },
                            child: ListTile(
                              title: Text(_items[index].name),
                              subtitle:
                                  Text('${_items[index].weight.toString()} g'),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
