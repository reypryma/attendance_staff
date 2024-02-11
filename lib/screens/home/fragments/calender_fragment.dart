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
        FutureBuilder(
          future: attendanceProvider.getAttendanceHistory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Container();
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
        )
      ],
    );
  }
}
