import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultrapack_mobile/providers/InventorySelections.dart';
import 'package:ultrapack_mobile/providers/BackpacksModel.dart';
import 'package:ultrapack_mobile/screens/Backpacks.dart';
import 'package:ultrapack_mobile/screens/Inventory/Inventory.dart';
import 'package:ultrapack_mobile/screens/NewBackpack.dart';
import 'package:ultrapack_mobile/services/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(UltrapackApp());
}

class UltrapackApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InventorySelections()),
        ChangeNotifierProvider(create: (context) => BackpacksModel())
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
            '/newbackpack': (context) => NewBackpack(),
          }),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    var backpacks = context.read<BackpacksModel>();
    backpacks.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title!),
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
          ],
        ),
      ),
    );
  }
}
