import 'package:attendance_staff/models/attendance_model.dart';
import 'package:attendance_staff/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class CalenderFragment extends StatefulWidget {
  const CalenderFragment({Key? key}) : super(key: key);

  @override
  State<CalenderFragment> createState() => _CalenderFragmentState();
}

class _CalenderFragmentState extends State<CalenderFragment> {
  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20, top: 60, bottom: 10),
          child: const Text(
            "My Attendance",
            style: TextStyle(fontSize: 25),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              attendanceProvider.attendanceHistoryMonth,
              style: const TextStyle(fontSize: 25),
            ),
            OutlinedButton(
                onPressed: () async {
                  final selectedDate =
                      await SimpleMonthYearPicker.showMonthYearPickerDialog(
                          context: context, disableFuture: true);
                  String pickedMonth =
                      DateFormat('MMMM yyyy').format(selectedDate);
                  attendanceProvider.attendanceHistoryMonth = pickedMonth;
                },
                child: const Text("Pick a month")),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: attendanceProvider.getAttendanceHistory(),
            builder: (context, AsyncSnapshot<List<AttendanceModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      AttendanceModel attendanceData = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 12, left: 20, right: 20, bottom: 10),
                        height: 150,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(2, 2)),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    DateFormat("EE \n dd")
                                        .format(attendanceData.createdAt),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Check in",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      width: 80,
                                      child: Divider(),
                                    ),
                                    Text(
                                      attendanceData.checkIn,
                                      style: const TextStyle(fontSize: 25),
                                    )
                                  ],
                                )),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Check Out",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      width: 80,
                                      child: Divider(),
                                    ),
                                    Text(
                                      attendanceData.checkOut?.toString() ??
                                          '--/--',
                                      style: const TextStyle(fontSize: 25),
                                    )
                                  ],
                                )),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
              }
              return const LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.grey,
              );
            },
          ),
        )
      ],
    );
  }
}
