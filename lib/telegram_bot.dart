import 'dart:convert';

import 'package:televerse/televerse.dart';
import 'package:unipi_orario_wrapper/unipi_orario_wrapper.dart';
import 'package:intl/intl.dart';

int test() {
  return 0;
}

// Future è una funzione con async
Future<void> courseHandler(Context ctx) async {
  await ctx.reply("course");
}

Future<void> dayHandler(Context ctx) async {
  await ctx.reply("day");
}

Future getLessons(String course) async {
  final wrapper = WrapperService();
  List<Lesson> lessons = await wrapper.fetchLessonsObj(
    calendarId: "6319d930e209821793111b45",
    clientId: "628de8b9b63679f193b87046",
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 7)),
  );

  var output = [];

  for (var lesson in lessons) {
    if (lesson.courseName == "CORSO $course") {
      String formattedStartDate =
          DateFormat('dd-MM-yyyy - kk:mm').format(lesson.startDateTime);
      String formattedEndDate =
          DateFormat('dd-MM-yyyy - kk:mm').format(lesson.endDateTime);
      output.add(
          lesson.name + lesson.name + formattedStartDate + formattedEndDate);
    }
  }
  return output;
}
