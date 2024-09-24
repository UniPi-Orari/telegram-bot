import 'package:telegram_bot/telegram_bot.dart'
    as telegram_bot; // api methods wrapper
import 'package:televerse/televerse.dart'; // dart telegram api
import 'dart:developer';

import '../env.dart' as env;

Bot bot = Bot(env.token);
final conv = Conversation(bot);
var botUptimeUsages = 0;

// to-do by day filter, calendar selector (if possible, idk)
void main() async {
  final menu = KeyboardMenu()
      //.text("/start", telegram_bot.start)
      //.text("Seleziona Giorno", telegram_bot.dayHandler)
      // .text("Seleziona per CalendarId", calendarIdHandler)
      .resized();
  bot.attachMenu(menu);

  // bot.command('start', (ctx) async {
  //   await ctx.reply('Ciao!', replyMarkup: menu);
  //   print("started new instance ${telegram_bot.test()}");
  // });
  bot.command('start', (ctx) async {
    botUptimeUsages += 1;
    await ctx.reply(
        'Dimmi in che cazzo di corso vai(A,B,C) e sappi che funziona solo per informatica',
        replyMarkup: menu);
    final courseCtx = await conv.waitForTextMessage(chatId: ctx.id);

    // String res = courseCtx?.message?.text?.length == 1
    //     ? await telegram_bot.getLessons(courseCtx!.message!.text!)
    //     : "male";
    var res = [];
    if (courseCtx?.message?.text?.length == 1) {
      res = await telegram_bot.getLessons(courseCtx!.message!.text!);
    } else {
      res.add("error");
    }
    if (res[0] == "error") {
      courseCtx!.reply(
          "Non mi prendere per il culo e matti un corso valido coglione ;D");
    } else {
      courseCtx!.reply(telegram_bot.formatLessons(res));
    }

    print("$botUptimeUsages callback");
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
  });

  print("[bot starting..]");
  await bot.start();
}
