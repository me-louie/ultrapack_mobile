import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/screens/MyBackpack.dart';
import 'package:ultrapack_mobile/services/db.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/providers/BackpacksModel.dart';

class Backpacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backpacks'),
      ),
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
        Consumer<BackpacksModel>(
          builder: (context, myBackpacks, child) => Flexible(
              child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: myBackpacks.length,
            itemBuilder: (BuildContext context, int index) {
              return BackpackListItem(
                  id: myBackpacks.getBackpacks[index].id,
                  title: myBackpacks.getBackpacks[index].name,
                  description: myBackpacks.getBackpacks[index].description);
            },
          )),
        )
      ]),
    );
  }
}

enum Options { edit, delete }

class BackpackListItem extends StatefulWidget {
  const BackpackListItem(
      {this.id, required this.title, required this.description});
  final int? id;
  final String title;
  final String description;

  @override
  _BackpackListItemState createState() => _BackpackListItemState();
}

class _BackpackListItemState extends State<BackpackListItem> {
  int _weight = 0;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    _weight = await DB.getBackpackWeight(widget.id!);
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
                builder: (context) => MyBackpack(widget.id!, widget.title,
                    widget.description, () => refresh())));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.backpack_rounded),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.title}',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('${widget.description}',
                                style: Theme.of(context).textTheme.bodyText2),
                            Text('Pack Weight (g): $_weight')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PopupMenuButton(
                  onSelected: (Options result) {
                    setState(() {
                      switch (result) {
                        case Options.delete:
                          _openDeleteDialog();
                          return;
                        case Options.edit:
                          return;
                        default:
                          return;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Options>>[
                        // const PopupMenuItem<options>(
                        //     value: options.edit, child: Text('Edit')),
                        const PopupMenuItem<Options>(
                          value: Options.delete,
                          child: Text('Delete'),
                        ),
                      ])
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDeleteDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'Are you sure you want to delete ',
                    style: TextStyle(fontWeight: FontWeight.normal)),
                TextSpan(
                    text: '${widget.title}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    var backpacks = context.read<BackpacksModel>();
                    backpacks.delete(widget.id!);
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }
}
