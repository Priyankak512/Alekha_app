import 'package:flutter/material.dart';

class HomeFirstCommonContainer extends StatefulWidget {
  const HomeFirstCommonContainer({super.key});

  @override
  State<HomeFirstCommonContainer> createState() =>
      _HomeFirstCommonContainerState();
}

class _HomeFirstCommonContainerState extends State<HomeFirstCommonContainer> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: CommonHomeFirstContainerWidget(
          date: 'August 25,',
          day: 'Wednesday',
          toDay: 'Today',
        ),
      ),
    );
  }
}

class CommonHomeFirstContainerWidget extends StatelessWidget {
  const CommonHomeFirstContainerWidget({
    super.key,
    required this.date,
    required this.day,
    required this.toDay,
  });
  final String date;
  final String day;
  final String toDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.00)),
          color: Color.fromARGB(255, 197, 176, 201),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        day,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18.00),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 6.00),
                      child: Text(
                        toDay,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/house.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                title: const Text(
                  "Good Evening!",
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: const Text(
                  "Michel Rechard",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 219, 197, 223),
                      border: Border.all(color: Colors.orange),
                      shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.cake_sharp,
                      color: Colors.orange,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final List<dynamic> list = [
  {'id': 0, 'leading': 'Payment Application', 'trailing': 'System'},
  {'id': 1, 'leading': 'Reference Number', 'trailing': 'SYM12113OI'},
  {'id': 2, 'leading': 'Total', 'trailing': '15.00'},
  {'id': 3, 'leading': 'Details', 'trailing': 'Civil Employment'},
];
