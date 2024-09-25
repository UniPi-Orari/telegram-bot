# 📚 Unipi Orari Informatica (UPIO) - Telegram Bot 💙
<img src="assets/logo.png" alt="logo" width="200"/>

Questo Bot permette agli studenti di ottenere l'orario delle lezioni direttamente su **Telegram!**


## 🚀 Funzionalità
<img src="assets/shocked-cat.gif" alt="shocked cat" width="200"/>

- 📅 **Recupero orari delle lezioni**: Tramite [un wrapper dell'api](https://github.com/UniPi-Orari/api-wrapper) dell'università
- 🔄 **Refresh dell'orario**: Basta premere un pulsante per ottenere l'orario aggiornato
- 🔍 **Dati utente specifici**: Il bot ricorda il corso che hai selezionato, così non devi inserirlo di nuovo!
- 📝 **Verifica del corso**: Assicura che l'utente inserisca un corso valido (A, B, C), altrimenti ti manda a fanculo :D

## 🔧 Come Funziona

1. **Avvia** il bot con il comando `/start`.
2. Il bot ti chiederà in quale corso sei iscritto (**A**, **B**, o **C**).
3. Recupera l'orario delle lezioni per i prossimi 7 giorni, includendo nome della lezione, orario di inizio e fine.
4. I risultati sono mostrati in un **messaggio formattato** con HTML per una lettura più facile.
5. Puoi cliccare sul pulsante per **ripetere la ricerca** in qualsiasi momento!

## 🛠️ Installazione

1. Clona il repository:

    ```bash
    git clone https://github.com/UniPi-Orari/telegram-bot
    ```

2. Installa le dipendenze:

    ```bash
    dart pub get
    ```

3. Configura il token del bot nel file `env.dart` nella root directory:

    ```dart
    library telegram_bot.globals;
    String token = "TOKEN";
    ```

4. Esegui il bot:

    ```bash
    dart run bin/telegram_bot.dart
    ```

## ⚙️ Comandi

- `/start` - Avvia la conversazione e seleziona il tuo corso.
- `/help` - Mostra un breve messaggio di aiuto con i comandi disponibili(anche se quali cazzo di comandi vuoi che abbia questo bot?)

## 💾 Memorizzazione dei Dati

- Le informazioni sul corso selezionato dagli utenti sono salvate in un file JSON (`users_data.json`), consentendo al bot di ricordare le preferenze degli utenti.
- Se non ci sono dati disponibili per l'utente, gli verrà chiesto di inserire nuovamente il corso.

## 🤖 Realizzato Con

- [**Televerse**](https://github.com/xooniverse/televerse): Una libreria Dart per costruire bot Telegram in modo semplice.




---

💻 With 💙 by [zubby](https://github.com/zubbyy) & [ale](https://github.com/aleeeee1)
