import 'package:attendance_staff/models/user_model.dart';
import 'package:attendance_staff/providers/attendance_provider.dart';
import 'package:attendance_staff/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AttendanceFragment extends StatefulWidget {
  const AttendanceFragment({Key? key}) : super(key: key);

  @override
  State<AttendanceFragment> createState() => _AttendanceFragmentState();
}

class _AttendanceFragmentState extends State<AttendanceFragment> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();

  @override
  void initState() {
    Provider.of<AttendanceProvider>(context, listen: false).getTodayAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 32),
                      child: const Text(
                        "Welcome",
                        style: TextStyle(color: Colors.black54, fontSize: 30),
                      ),
                    ),
                    Consumer<DBService>(
                      builder: (context, dbService, child) {
                        return FutureBuilder(
                          future: dbService.getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserModel user = snapshot.data!;
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  user.name != '' ? user.name : "#${user.employeeId}",
                                  style: const TextStyle(fontSize: 25),
                                ),
                              );
                            }
                            return const SizedBox(
                              width: 60,
                              child: LinearProgressIndicator(),
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 32),
                      child: const Text(
                        "Today's Status",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 32),
                      height: 150,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Check In",
                                  style: TextStyle(fontSize: 20, color: Colors.black54),
                                ),
                                const SizedBox(
                                  width: 80,
                                  child: Divider(),
                                ),
                                Text(
                                  attendanceProvider.attendanceModel?.checkIn ?? '--/--',
                                  style: const TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Check Out",
                                  style: TextStyle(fontSize: 20, color: Colors.black54),
                                ),
                                const SizedBox(
                                  width: 80,
                                  child: Divider(),
                                ),
                                Text(
                                  attendanceProvider.attendanceModel?.checkOut ?? '--/--',
                                  style: const TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat("dd MMMM yyyy").format(DateTime.now()),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) => Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat("hh:mm:ss a").format(DateTime.now()),
                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomRight,
                  child: Builder(builder: (context) => Align(
                    alignment: Alignment.bottomCenter,
                    child: SlideAction(
                      text: attendanceProvider.attendanceModel?.checkIn == null
                          ? "Slide to Check in"
                          : "Slide to Check Out",
                      textStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                      outerColor: Colors.white,
                      innerColor: Colors.redAccent,
                      key: key,
                      onSubmit: () async {
                        await attendanceProvider.markAttendance(context);
                        key.currentState!.reset();
                      },
                    ),
                  ),),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
