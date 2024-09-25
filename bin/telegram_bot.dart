import 'dart:convert';
import 'dart:developer';
import 'package:televerse/televerse.dart';
import '../env.dart' as env;
import 'package:telegram_bot/telegram_bot.dart' as telegram_bot;
import 'dart:io' as io;

final stopwatch = Stopwatch();
Bot bot = Bot(env.token);
final conv = Conversation(bot);
var botUptimeUsages = 0;
Map<String, dynamic> usersData = {};

Future<void> loadUserData() async {
  var file = io.File('data/users_data.json');
  if (await file.exists()) {
    String fileContent = await file.readAsString();
    usersData = jsonDecode(fileContent);
    print('User data loaded: $usersData');
  } else {
    print('No user data file found, creating a new one.');
    usersData = {};
  }
}

Future<void> saveUserData() async {
  final file = io.File('data/users_data.json');
  String jsonData = jsonEncode(usersData);
  await file.writeAsString(jsonData);
  print('User data saved - $jsonData');
}

void main() async {
  stopwatch.start();
  await loadUserData();

  final menu = KeyboardMenu().resized();
  bot.attachMenu(menu);

  bot.command('start', (ctx) async {
    var keyboard = telegram_bot.buildKeyboard();
    botUptimeUsages += 1;
    await ctx.reply(
        'Dimmi in che cazzo di corso vai (A, B, C) e sappi che funziona solo per informatica',
        replyMarkup: menu);

    final courseCtx = await conv.waitForTextMessage(chatId: ctx.chat!.getId());
    var course = courseCtx?.message?.text?.toUpperCase();

    final userId = courseCtx!.chat!.id.toString();
    // print(userId);

    // Create a new entry for the user if it doesn't exist
    if (!usersData.containsKey(userId)) {
      usersData[userId] = {'course': ''}; // Initialize with empty string
    }

    if (course != null && course.length == 1) {
      usersData[userId]['course'] = course; // Update user's course
      await saveUserData();

      var lessons = await telegram_bot.getLessons(course);
      if (lessons.isNotEmpty && lessons[0] != "error") {
        courseCtx.reply(telegram_bot.formatLessons(lessons),
            parseMode: ParseMode.html, replyMarkup: keyboard);
      } else {
        courseCtx.reply(
            "Non mi prendere per il culo e metti un corso valido coglione ;D");
      }
    } else {
      await ctx.reply(
          "Non mi prendere per il culo e metti un corso valido coglione ;D");
    }

    print("$botUptimeUsages callbacks till uptime [${stopwatch.elapsed}]");
  });

  bot.callbackQuery('repeat_lessons', (ctx) async {
    final userId = ctx.chat!.id.toString();

    if (usersData.containsKey(userId)) {
      var userCourse = usersData[userId]['course'];
      if (userCourse.isNotEmpty) {
        // Check if userCourse is not empty
        var lessons = await telegram_bot.getLessons(userCourse);
        var keyboard =
            telegram_bot.buildKeyboard(); // Ensure keyboard is always included
        if (lessons.isNotEmpty && lessons[0] != "error") {
          await ctx.reply(telegram_bot.formatLessons(lessons),
              parseMode: ParseMode.html, replyMarkup: keyboard);
        } else {
          await ctx.reply(
              "Non ci sono lezioni disponibili per il corso memorizzato",
              replyMarkup: keyboard);
        }
      } else {
        await ctx
            .reply("Nessun corso memorizzato. Per favore, inizia con /start.");
      }
    } else {
      await ctx.reply("Non ho dati su di te. Inizia con /start");
    }
    print("callback from $userId");
  });

  bot.text('pisa', (ctx) async {
    await ctx.reply('merda');
    print("pisa merda");
  });

  bot.help((ctx) async => await ctx.reply('''
  /start: ti chiede il corso e ti fornisce gli orari delle lezioni
  /help: minchia prova ad indovinare coglione
  '''));

  bot.onError((err) {
    log(
      "Something went wrong: $err",
      error: err.error,
      stackTrace: err.stackTrace,
    );
    print("Caught error:\n$err");
  });

  print("[bot starting..]");
  await bot.start();
}
