import 'package:flutter/material.dart';
//import 'package:flutter_buttons/flutter_buttons.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './app_localizations.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:math';

final FirebaseAnalytics analytics = FirebaseAnalytics();
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('ru', ''), // Russian, no country code
        // ... other locales the app supports
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      title: 'Adviser',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Adviser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _answerText = "";
  Random rnd = new Random();
  bool _firstScreen = true;

  Future<void> _sendAnalyticsEvent(
      FirebaseAnalytics analytics, String eventName) async {
    await analytics.logEvent(name: eventName);
  }

  void _yesOrNo() {
    _sendAnalyticsEvent(analytics, "tapButtonYesNo");
    var _answer = AppLocalizations.of(context).translate("yes_no_answer");
    var _answerList = _answer.substring(1, _answer.length - 1).split(',');
    int index = rnd.nextInt(_answerList.length);

    setState(() {
      _answerText = _answerList[index];
    });
  }

  void _when() {
    _sendAnalyticsEvent(analytics, "tapButtonWhen");
    var _answer = AppLocalizations.of(context).translate("when_answer");
    var _answerList = _answer.substring(1, _answer.length - 1).split(',');
    int index = rnd.nextInt(_answerList.length);
    setState(() {
      _answerText = _answerList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_firstScreen) {
      _answerText = AppLocalizations.of(context).translate('hello_text');
      _firstScreen = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("title_text")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: AppLocalizations.of(context).translate("about"),
            onPressed: () {
              _sendAnalyticsEvent(analytics, "tapButtonAbout");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutRoute()),
              );
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/wiseCatBackground.png"),
            colorFilter: new ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.modulate),
            alignment: Alignment.bottomCenter,
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text("I am here to give you an answers.",textAlign: TextAlign.center,),
              //Text("Just press one of the buttons.",textAlign: TextAlign.center,),
              //Text("But don\'t take it seriously :)",textAlign: TextAlign.center,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _answerText,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  onPressed: _yesOrNo,
                  title:
                      AppLocalizations.of(context).translate("yes_no_button"),
                  buttonColor: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  onPressed: _when,
                  title: AppLocalizations.of(context).translate('when_button'),
                  buttonColor: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child:
                    Text(AppLocalizations.of(context).translate("bottom_text")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("about")),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate("about_application"),
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              AppLocalizations.of(context).translate("about_personal_section"),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
