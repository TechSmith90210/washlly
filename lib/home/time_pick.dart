import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import '../widgets/loadingWidget.dart';
import 'current_location.dart';

class time_picker extends StatefulWidget {
  const time_picker({Key? key}) : super(key: key);

  _time_picker createState() => _time_picker();
}

class _time_picker extends State<time_picker> {
  var user = sharedPreferences?.getString("uid");
  var fullName = sharedPreferences?.getString("FullName");
  var Email = sharedPreferences?.getString("email");
  var PhoneNumber = sharedPreferences?.getString("PhoneNumber");

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectDate = DateTime.now();
  final firstDate = DateTime(2000);
  final lastDate = DateTime(2100);
  final selectTime = TimeOfDay.now();
  var timeAndDate = '';

  @override
  Widget build(BuildContext context) {
    timeAndDate =
        "${selectDate.year}:${selectDate.month}:${selectDate.day} - ${selectedTime.hour}:${selectedTime.minute}";
    setState(() {
      timeAndDate;
    });
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(),
        title: const Text(
          "washly",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              timeAndDate,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.blueAccent,
              child: CalendarDatePicker(
                initialDate: selectDate,
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (DateTime value) {
                  setState(() {
                    selectDate = value;
                    selectDateFunctoin(selectDate);
                    timeAndDate;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: const Text("Choose Time"),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  fixedSize: Size(MediaQuery.of(context).size.width, 47),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => MapSample());
                  Navigator.push(context, route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectDateFunctoin(DateTime selectDate) {
    showDialog(
        context: context,
        builder: (c) {
          return circularProgress();
        });
    Navigator.pop(context);
    _selectTime(context);
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        selectedTime.format(context);
        timeAndDate;
        print(selectedTime);
      });
    }
    UploadSelectedDate(selectDate);
  }

  Future UploadSelectedDate(DateTime selectDate) async {
    await FirebaseFirestore.instance.collection("services").doc(user).update({
      // "timeAndDate": timeAndDate.toString(),
      "timeAndDate": timeAndDate =
          "${selectDate.year}:${selectDate.month}:${selectDate.day} - ${selectedTime.format(context)}",
      "FullName": fullName.toString(),
      "selectedDate": selectDate,
      "Email": Email.toString(),
      "PhoneNumber": PhoneNumber.toString(),
    }).then((value) async {
      await FirebaseFirestore.instance.collection("calendar").doc(user).set({
        // "timeAndDate": timeAndDate.toString(),
        "timeAndDate": timeAndDate =
            "${selectDate.year}:${selectDate.month}:${selectDate.day} - ${selectedTime.format(context)}",
        "name": fullName.toString(),
        "selected": selectDate,
        "Email": Email.toString(),
        "phoneNumber": PhoneNumber.toString(),
      });
      // Navigator.pop(context);
    });
  }
}
