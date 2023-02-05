// ignore_for_file: depend_on_referenced_packages, unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tryingthistime/Language.dart';

import 'package:tryingthistime/SpeechApi.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate This',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranslateScreen(),
    );
  }
}

class TranslateScreen extends StatefulWidget {
  TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  var _translatedText = "Tanslated Text will appear here";
  final translator = GoogleTranslator();
  String toLang = "en";

  //  var translation = await translator.translate("I would buy a car, if I had money.", from: 'en', to: 'it');

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate This'),
      ),
      body: Column(
        children: [
          Expanded(child: Text(_text)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("English")),
              const Icon(Icons.arrow_forward),
              // ElevatedButton(onPressed: () {}, child: const Text("Spanish")),
              //a dropdown button that will display the list of languages taken from the map inside Language class
              DropdownButton<String>(
                value: toLang,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    toLang = newValue!;
                  });
                },
                items: Language.languagesList()
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              ElevatedButton(onPressed: () {}, child: const Text("Translate")),
            ],
          ),
          const Divider(),
          Expanded(
            child: Text(_translatedText),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        glowColor: Colors.blue,
        endRadius: 90.0,
        duration: const Duration(milliseconds: 2000),
        // repeat: true,
        animate: _isListening,
        showTwoGlows: true,
        child: Material(
          // Replace this child with your own
          elevation: 8.0,
          shape: const CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            // ignore: sort_child_properties_last
            child: FloatingActionButton(
              onPressed: () {
                var trans = toggelRecording();
                setState(() {
                  _isListening = !_isListening;
                });
              },
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
            radius: 40.0,
          ),
        ),
      ),
    );
  }

  Future toggelRecording() async {
    await SpeechApi.toggleRecording(
      onResult: (val) => setState(() {
        _text = val;
        // print(_text + " " + _confidence.toString());
        // print("object");
      }),
    );
    var trans = retrieveTranslation(_text).then((value) {
      setState(() {
        _translatedText = value;
      });
      // print(value);
      return value;
    });
    return trans;
  }

  Future<String> retrieveTranslation(String text) async {
    var translatedText = await translator.translate(text, from: 'en', to: 'es');
    return translatedText.toString();
  }
}
