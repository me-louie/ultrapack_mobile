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
    // final List<int> colorCodes = <int>[600, 500, 100];
    return Scaffold(
      appBar: AppBar(title: Text('Backpacks')),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: ElevatedButton.icon(
            onPressed: () {
              print('new bp');
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
                title: _backpacks[index].name,
                description: _backpacks[index].description,
                weight: _backpacks[index].weight);
          },
        ))
      ]),
    );
  }
}

class BackpackListItem extends StatelessWidget {
  const BackpackListItem(
      {required this.title, required this.description, required this.weight});

  final String title;
  final String description;
  final int weight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Feedback.forTap(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBackpack(title, description, weight)));
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
                    Text('$title',
                        style: Theme.of(context).textTheme.bodyText1),
                    Text('$description',
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
