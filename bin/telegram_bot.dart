import 'dart:convert';

import 'package:telegram_bot/telegram_bot.dart' as telegram_bot;
import 'package:unipi_orario_wrapper/unipi_orario_wrapper.dart';
import 'package:televerse/televerse.dart';
import 'dart:developer';

import '../env.dart' as env;

Bot bot = Bot(env.token);
final conv = Conversation(bot);

void main() async {
  final menu = KeyboardMenu()
      .text("Seleziona Corso", telegram_bot.courseHandler)
      .text("Seleziona Giorno", telegram_bot.dayHandler)
      // .text("Seleziona per CalendarId", calendarIdHandler)
      .resized();
  bot.attachMenu(menu);

  // bot.command('start', (ctx) async {
  //   await ctx.reply('Ciao!', replyMarkup: menu);
  //   print("started new instance ${telegram_bot.test()}");
  // });
  bot.command('start', (ctx) async {
    await ctx.reply(
        'Dimmi in che cazzo di corso vai(A,B,C) e sappi che funziona solo per informatica',
        replyMarkup: menu);
    final courseCtx = await conv.waitForTextMessage(chatId: ctx.id);

    // String res = courseCtx?.message?.text?.length == 1
    //     ? await telegram_bot.getLessons(courseCtx!.message!.text!)
    //     : "male";
    List res = [];
    if (courseCtx?.message?.text?.length == 1) {
      print(await telegram_bot.getLessons(courseCtx!.message!.text!));
      res = await telegram_bot.getLessons(courseCtx.message!.text!);
      // return Users.fromJson(jsonresponse[0]);
      // res = await telegram_bot.getLessons(courseCtx.message!.text!);
    }

    courseCtx?.reply(res[0]);
    print("started new instance $res");
  });

  bot.command('die', (ctx) async {
    await ctx.reply('mori!');
    print("morto");
  });

  bot.onError((err) {
    log(
      "Something went wrong: $err",
      error: err.error,
      stackTrace: err.stackTrace,
    );
  });

  print("bot starting..");
  await bot.start();
}
