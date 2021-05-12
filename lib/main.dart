import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/screens/Backpacks.dart';
import 'package:ultrapack_mobile/screens/Inventory.dart';
import 'models/Item.dart';
import 'services/db.dart';
import 'models/Counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.init();

  var Item1 = Item(id: 1, name: 'canoe', weight: 100);
  await db.insert('items_inventory', Item1);
  var Item2 = Item(id: 2, name: 'canoe2', weight: 102);
  await db.insert('items_inventory', Item2);

  // List<Map<String, dynamic>> items = await db.query('items_inventory');
  //
  // print(List.generate(items.length, (i) {
  //   return Item(
  //     id: items[i]['id'],
  //     name: items[i]['name'],
  //     weight: items[i]['weight'],
  //   );
  // }));

  runApp(UltrapackApp());
}

class UltrapackApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Counter())],
      child: MaterialApp(
          title: 'ultrapack',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(title: 'ultrapack'),
          routes: {
            '/inventory': (context) => Inventory(),
            '/backpacks': (context) => Backpacks()
          }),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inventory');
                },
                child: Text('Inventory')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/backpacks');
                },
                child: Text('Backpacks')),
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var counter = context.read<Counter>();
          counter.incrementCounter();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
