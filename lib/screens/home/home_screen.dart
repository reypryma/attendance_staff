import 'package:attendance_staff/screens/home/fragments/attendance_fragment.dart';
import 'package:attendance_staff/screens/home/fragments/calender_fragment.dart';
import 'package:attendance_staff/screens/home/fragments/profile_fragment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeScreen(),);
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<IconData> navigationIcons = [
    FontAwesomeIcons.solidCalendarDays,
    FontAwesomeIcons.check,
    FontAwesomeIcons.solidUser
  ];

  List<Widget> fragments = [
    const CalenderFragment(),
    const AttendanceFragment(),
    const ProfileFragment()
  ];

  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: fragments,
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(-5, 5))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for(int i = 0; i < navigationIcons.length; i++)...{
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: Center(
                    child: FaIcon(
                      navigationIcons[i],
                      color: i == currentIndex
                          ? Colors.redAccent
                          : Colors.black54,
                      size: i == currentIndex ? 30 : 26,
                    ),
                  ),
                ),
              )
            }
          ],
        ),
      ),
    );
  }
}
