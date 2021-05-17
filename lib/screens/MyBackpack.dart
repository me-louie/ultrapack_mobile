import 'package:flutter/material.dart';

class MyBackpack extends StatefulWidget {
  final String name;
  final String description;
  int weight;
  MyBackpack(this.name, this.description, this.weight);

  @override
  _MyBackpackState createState() => _MyBackpackState();
}

class _MyBackpackState extends State<MyBackpack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.name}')),
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
                        children: [
                          // Text('${widget.name}',
                          //     style: Theme.of(context).textTheme.bodyText1),
                          // Text('${widget.description}',
                          //     style: Theme.of(context).textTheme.bodyText2),
                          Text('Pack Weight (g): ${widget.weight}')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
