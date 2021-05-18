import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Backpack.dart';
import 'package:ultrapack_mobile/screens/MyBackpack.dart';
import 'package:ultrapack_mobile/services/db.dart';

class Backpacks extends StatefulWidget {
  @override
  _BackpacksState createState() => _BackpacksState();
}

class _BackpacksState extends State<Backpacks> {
  List<Backpack> _backpacks = [];

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Backpack.table);
    _backpacks = _results.map((bp) => Backpack.fromMap(bp)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Backpacks')),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/newbackpack');
            },
            icon: Icon(Icons.add_circle),
            label: Text('Pack a new backpack'),
          ),
        ),
        Flexible(
            child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _backpacks.length,
          itemBuilder: (BuildContext context, int index) {
            return BackpackListItem(
              id: _backpacks[index].id,
              title: _backpacks[index].name,
              description: _backpacks[index].description,
            );
          },
        ))
      ]),
    );
  }
}

class BackpackListItem extends StatefulWidget {
  const BackpackListItem({
    this.id,
    required this.title,
    required this.description,
  });
  final int? id;
  final String title;
  final String description;

  @override
  _BackpackListItemState createState() => _BackpackListItemState();
}

class _BackpackListItemState extends State<BackpackListItem> {
  int weight = 0;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    weight = await DB.getBackpackWeight(widget.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Feedback.forTap(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBackpack(
                    widget.id!, widget.title, widget.description, weight)));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.backpack_rounded),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.title}',
                        style: Theme.of(context).textTheme.bodyText1),
                    Text('${widget.description}',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text('Pack Weight (g): $weight')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
