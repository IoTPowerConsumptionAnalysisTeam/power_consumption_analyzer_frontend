import 'package:flutter/material.dart';
import 'package:power_consumption_analyzer_frontend/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Consumption Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Power Consumption Analyzer'),
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
  List dataList = [
    {
      "name": "Living Room",
      "icon": Icons.home,
      "subMenu": [
        {"name": "Orders"},
        {"name": "Invoices"}
      ]
    },
    {
      "name": "Bedroom",
      "icon": Icons.bed,
      "subMenu": [
        {
          "name": "Promotions",
          "subMenu": [
            {"name": "Catalog Price Rule"},
            {"name": "Cart Price Rules"}
          ]
        },
        {
          "name": "Communications",
          "subMenu": [
            {"name": "Newsletter Subscribers"}
          ]
        },
        {
          "name": "SEO & Search",
          "subMenu": [
            {"name": "Search Terms"},
            {"name": "Search Synonyms"}
          ]
        },
        {
          "name": "User Content",
          "subMenu": [
            {"name": "All Reviews"},
            {"name": "Pending Reviews"}
          ]
        }
      ]
    }
  ];

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          Menu menu = Menu.fromJson(dataList[index]);
          return _buildList(menu);
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

  Widget _buildList(Menu list) {
    if (list.subMenu.isEmpty) {
      return Builder(builder: (context) {
        return ListTile(
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => SubCategory(list.name))),
            leading: const SizedBox(),
            title: Text(list.name));
      });
    }
    return ExpansionTile(
      leading: Icon(list.icon),
      title: Text(
        list.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: list.subMenu.map(_buildList).toList(),
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
