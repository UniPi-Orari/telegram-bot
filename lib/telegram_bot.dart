import 'package:unipi_orario_wrapper/unipi_orario_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:televerse/televerse.dart';

Future<List<String>> getLessons(String course) async {
  final wrapper = WrapperService();
  var courseCounter = 0;
  List<Lesson> lessons = await wrapper.fetchLessonsObj(
    calendarId: "6319d930e209821793111b45",
    clientId: "628de8b9b63679f193b87046",
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 7)),
  );

  List<String> output = [];
  course = course.toUpperCase();

  for (var lesson in lessons) {
    if (lesson.courseName == "CORSO $course") {
      courseCounter += 1;
      String formattedStartDate =
          DateFormat('dd-MM-yyyy - kk:mm').format(lesson.startDateTime);
      String formattedEndDate =
          DateFormat('dd-MM-yyyy - kk:mm').format(lesson.endDateTime);
      output.add(
          "<b>${lesson.name}</b> [${lesson.courseName}] \n<i>🟢Inizio lezione:</i> <b>$formattedStartDate</b> \n<i>⛔Fine lezione:</i> <b>$formattedEndDate</b>");
    }
  }
  if (courseCounter == 0) {
    output.add("error");
    output.add(
        "<b><i>Non mi prendere per il culo e metti un corso valido coglione ;D</i></b>");
  }
  return output;
}

String formatLessons(List lessons) {
  String output = "";
  for (var lesson in lessons) {
    output += "$lesson\n\n";
  }
  return output;
}

InlineKeyboard buildKeyboard() {
  final keyboard = InlineKeyboard();
  keyboard.add("Ricarica", "repeat_lessons");
  return keyboard;
}
