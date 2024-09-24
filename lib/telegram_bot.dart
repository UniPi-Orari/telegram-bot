import 'package:televerse/televerse.dart';
import 'package:unipi_orario_wrapper/unipi_orario_wrapper.dart';
import 'package:intl/intl.dart';

// Future è una funzione con async
// Future<void> courseHandler(Context ctx) async {
//   await ctx.reply("course");
// }

Future<void> dayHandler(Context ctx) async {
  await ctx.reply("day");
}

// var botUptimeUsages = 0;
// Future<void> start(Context ctx, conv) async {
//   botUptimeUsages += 1;
//   await ctx.reply(
//     'Dimmi in che cazzo di corso vai(A,B,C) e sappi che funziona solo per informatica',
//   );
//   final courseCtx = await conv.waitForTextMessage(chatId: ctx.id);

//   // String res = courseCtx?.message?.text?.length == 1
//   //     ? await telegram_bot.getLessons(courseCtx!.message!.text!)
//   //     : "male";
//   var res = [];
//   if (courseCtx?.message?.text?.length == 1) {
//     res = await getLessons(courseCtx!.message!.text!);
//   }

//   courseCtx?.reply(formatLessons(res));
//   print("$botUptimeUsages callback");
// }

Future getLessons(String course) async {
  final wrapper = WrapperService();
  var courseCounter = 0;
  List<Lesson> lessons = await wrapper.fetchLessonsObj(
    calendarId: "6319d930e209821793111b45",
    clientId: "628de8b9b63679f193b87046",
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 7)),
  );

  var output = [];
  course = course.toUpperCase();

  for (var lesson in lessons) {
    if (lesson.courseName == "CORSO $course") {
      courseCounter += 1;
      String formattedStartDate =
          DateFormat('dd-MM-yyyy - kk:mm').format(lesson.startDateTime);
      String formattedEndDate =
          DateFormat('dd-MM-yyyy - kk:mm').format(lesson.endDateTime);
      output.add(
          "${lesson.name} [${lesson.courseName}] \nInizio lezione: $formattedStartDate \nFine lezione: $formattedEndDate");
    }
  }
  if (courseCounter == 0) {
    output.add("error");
    output
        .add("Non mi prendere per il culo e matti un corso valido coglione ;D");
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
