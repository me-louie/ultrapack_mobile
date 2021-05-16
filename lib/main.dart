import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/models/InventorySelections.dart';
import 'package:ultrapack_mobile/screens/Backpacks.dart';
import 'package:ultrapack_mobile/screens/Inventory.dart';
import 'package:ultrapack_mobile/screens/NewBackpack.dart';
import 'models/Backpack.dart';
import 'services/backpacks_db.dart';
import 'services/items_db.dart';
import 'models/Counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ItemsDB.init();
  await BackpacksDB.init();

  // Backpack elfin = Backpack(
  //     name: 'Elfin Lakes',
  //     description: 'Our fav snowshoeing destination',
  //     weight: 0);
  // BackpacksDB.insert(Backpack.table, elfin);
  // Backpack pano = Backpack(
  //     name: 'Panorama Ridge', description: 'Miki\'s fav hike in BC', weight: 0);
  // BackpacksDB.insert(Backpack.table, pano);
  runApp(UltrapackApp());
}

class UltrapackApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Counter()),
        ChangeNotifierProvider(create: (context) => InventorySelections())
      ],
      child: MaterialApp(
          title: 'ultrapack',
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.lightGreen,
          ),
          home: HomePage(title: 'ultrapack'),
          routes: {
            '/inventory': (context) => Inventory(),
            '/backpacks': (context) => Backpacks(),
            '/newbackpack': (context) => NewBackpack()
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
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen)),
                onPressed: () {
                  Navigator.pushNamed(context, '/inventory');
                },
                child: Text('Inventory')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/backpacks');
                },
                child: Text('Backpacks')),
            // Text(
            //   'You have pushed the button this many times:',
            // ),
            // Consumer<Counter>(
            //   builder: (context, counter, child) => Text(
            //     '${counter.value}',
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var counter = context.read<Counter>();
      //     counter.incrementCounter();
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
