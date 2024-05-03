import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 25.00),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Michel Rechard",
                          ),
                          Text(
                            "+91 99009 90099",
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert_outlined)
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    Icon(Icons.home), // Placeholder for the first item, assuming it's always there
                    SizedBox(width: 10),
                    Text("Home"), // Placeholder for the first item, assuming it's always there
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: drawerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = drawerList[index];
                          return Row(
                            children: [
                              Icon(item['icon']), // Removed const keyword here
                              SizedBox(width: 10),
                              Expanded(child: Text(item['title'])),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
    );
  }
}

List drawerList = [
  {"icon": Icons.home, "title": "Home"},
  {"icon": Icons.person_add_alt_1, "title": "Profile"},
  {"icon": Icons.call_to_action_rounded, "title": "Actions"},
  {"icon": Icons.settings, "title": "Settings"},
];
