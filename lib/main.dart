import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/login.dart';
import 'package:power_consumption_analyzer_frontend/main_popup_menu_botton.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_manager.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_request_handler.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_manager.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_request_handler.dart';
import 'package:power_consumption_analyzer_frontend/request_handler.dart';
import 'package:power_consumption_analyzer_frontend/user_request_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  GetIt.I.registerSingleton<PowerSocketCategoryManager>(
      PowerSocketCategoryManager());
  GetIt.I.registerSingleton<PowerSocketManager>(PowerSocketManager());
  GetIt.I.registerSingleton<RequestHandler>(RequestHandler());
  GetIt.I.registerSingleton<UserRequestHandler>(UserRequestHandler());
  GetIt.I.registerSingleton<PowerSocketRequestHandler>(
      PowerSocketRequestHandler());
  GetIt.I.registerSingleton<PowerSocketCategoryRequestHandler>(
      PowerSocketCategoryRequestHandler());
  // RequestHandler.I.baseUrl = 'http://localhost:3000/api';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PowerSocketCategoryManager>(
          create: (context) => GetIt.I<PowerSocketCategoryManager>(),
        ),
        ChangeNotifierProvider<PowerSocketManager>(
          create: (context) => GetIt.I<PowerSocketManager>(),
        ),
      ],
      child: MaterialApp(
        title: 'Power Consumption Analyzer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Power Consumption Analyzer'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      FutureBuilder(
        future: Future.wait([
          PowerSocketCategoryManager.I.fetchAllCategory(),
          PowerSocketManager.I.fetchAllPowerSocket(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            context.watch<PowerSocketCategoryManager>().getAllCategory();
            context.watch<PowerSocketManager>().getAllPowerSocket();
            return _buildPowerSocketList();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '0.00',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '本月',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '0.00',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '本月預估',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '0.00',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
    // dataList.forEach((element) {
    //   Menu menu = Menu.fromJson(element);
    //   print(menu.name);
    // });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<PowerSocketCategoryManager>().getAllCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.perm_identity),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
          ),
          MainPopupMenuButton(),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Sockets',
            icon: Icon(Icons.home),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            label: 'Stats',
            icon: Icon(Icons.bar_chart),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSocketList() {
    return ListView.builder(
      itemCount: PowerSocketCategoryManager.I.getAllCategory().length + 1,
      itemBuilder: (context, index) {
        if (index < PowerSocketCategoryManager.I.getAllCategory().length) {
          String categoryName =
              PowerSocketCategoryManager.I.getAllCategoryList()[index].name;
          List<PowerSocket> powerSockets =
              PowerSocketManager.I.getPowerSocketsByCategory(categoryName);
          return _buildExpansionTile(
            categoryName: categoryName,
            powerSockets: powerSockets,
          );
        } else {
          List<PowerSocket> powerSockets = PowerSocketManager.I
              .getPowerSocketsExceptCategories(PowerSocketCategoryManager.I
                  .getAllCategoryList()
                  .map((e) => e.name)
                  .toList());
          return _buildExpansionTile(
            powerSockets: powerSockets,
          );
        }
      },
    );
  }

  ExpansionTile _buildExpansionTile({
    String? categoryName,
    required List<PowerSocket> powerSockets,
  }) {
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        categoryName ?? 'Uncategorized',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: powerSockets.map(_buildListTile).toList(),
    );
  }

  Widget _buildListTile(PowerSocket powerSocket) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController powerSocketNameController =
                      TextEditingController();
                  TextEditingController powerSocketCategoryNameController =
                      TextEditingController();
                  powerSocketNameController.text = powerSocket.name ?? '';
                  powerSocketCategoryNameController.text =
                      powerSocket.category ?? '';
                  return AlertDialog(
                    title: const Text('Edit Power Socket'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: powerSocketNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: powerSocketCategoryNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Category',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await PowerSocketRequestHandler.I.updatePowerSocket(
                              userId: UserRequestHandler.I.userId,
                              powerSocketId: powerSocket.id,
                              name: powerSocketNameController.text,
                              category: powerSocketCategoryNameController.text,
                            );
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) async {
              try {
                await PowerSocketRequestHandler.I.deletePowerSocket(
                  userId: UserRequestHandler.I.userId,
                  powerSocketId: powerSocket.id,
                );
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
        ],
      ),
      child: ListTile(
        leading: const SizedBox(),
        title: Text(powerSocket.name ?? 'Unknown'),
        trailing: Text('0.00 W'),
      ),
    );
    ListTile(
      leading: const SizedBox(),
      title: Text(powerSocket.name ?? 'Unknown'),
      trailing: Text('0.00 W'),
    );
  }
}

class Menu {
  late String name;
  IconData? icon;
  List<Menu> subMenu = [];

  Menu({required this.name, required this.subMenu, required this.icon});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {
      subMenu.clear();
      json['subMenu'].forEach((v) {
        subMenu.add(Menu.fromJson(v));
      });
    }
  }
}
