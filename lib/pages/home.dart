// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, deprecated_member_use, unused_field, unused_element, prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sound_to_text/api/speech_api.dart';
import 'package:sound_to_text/constamts/constants.dart';
import 'package:sound_to_text/models/mesaj_model.dart';
import 'package:sound_to_text/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _MyHomePageState extends State<MyHomePage> {
  final lokasyonName = TextEditingController();
  var boxMesaj = Hive.box('mesaj');
  String? text;
  bool isListening = false;
  bool isplay = false;
  String? sesYazi;
  int keyIndex = 0;
  late List<MesajModel> kaydetList;
  late List<String> _sesList;

  //--------------------- Sesli Yönlendirme --------------------
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.0;
  double pitch = 1.4;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;
  Timer? timer;
  int seconds = 2;

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS || isWindows) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    isplay = true;
    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!).then((value) {
          setState(() {
            log("Sesli Bitiş    :$value");
            isplay = false;
            _newVoiceText = null;
          });
        });
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        isplay = true;
        seconds--;
        if (seconds == 0) {
          timer!.cancel();
          _speak();
        }
      });
    });
  }

  //------------------------- END -------------------------------------

  @override
  void initState() {
    initTts();
    kaydetList = <MesajModel>[];
    _sesList = <String>[];
    _newVoiceText = null;
    sesYazi = null;
    keyIndex = 0;
    text = 'Press the button and start speaking';
    Wakelock.enable();
    super.initState();
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (tex) => setState(() {
          text = tex;

          boxMesaj.put(keyIndex, tex);
        }),
        onListening: (isListen) {
          setState(() => isListening = isListen);

          if (!isListening) {
            Future.delayed(const Duration(seconds: 1), () {
              Utils.scanText(text!);
              log("Ses TO Yazı -------  : $text");
              keyIndex++;

              setState(() {});
            });
          }
        },
      );
  Future openlinkWhatsapp(String link) async {
    if (!await canLaunch(link)) {
      await launch(link);
    } else {
      debugPrint('Open Link Error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "titles".tr,
          style: TextStyle(
              color: Colors.orange.shade900, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        leading: TextButton(
            onPressed: () async {
              _sesList.clear();
              await boxMesaj.clear();
              setState(() {});
            },
            child: const Icon(
              Icons.delete_forever,
              size: 32,
              color: Colors.blueAccent,
            )),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                openlinkWhatsapp(
                    'https://api.whatsapp.com/send?phone=&text=${boxMesaj.values}');
              },
              child: const Icon(
                Icons.send_and_archive_outlined,
                size: 32,
                color: Colors.blueAccent,
              )),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Container(
          height: Get.size.height,
          width: Get.size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 15),
              SizedBox(
                height: Get.size.height / 5.0,
                width: Get.size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text ?? "Yazmak için Konuşunuz",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: Get.size.height,
                    width: Get.size.width,
                    child: Text(
                      boxMesaj.values.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
            animate: isListening,
            endRadius: 75,
            glowColor: Constants.gormeEngelli,
            child: FloatingActionButton(
                heroTag: 'Gnav',
                backgroundColor: Constants.duymaEngelli,
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  size: 36,
                  color: Constants.gormeEngelli,
                ),
                onPressed: () async {
                  toggleRecording();
                }),
          ),
          AvatarGlow(
            animate: isplay,
            endRadius: 75,
            glowColor: Constants.gormeEngelli,
            child: FloatingActionButton(
                heroTag: 'Gnav2',
                backgroundColor: Constants.duymaEngelli,
                child: Icon(
                  isplay
                      ? Icons.stop_circle_outlined
                      : Icons.play_arrow_outlined,
                  size: 36,
                  color: Constants.gormeEngelli,
                ),
                onPressed: () async {
                  _newVoiceText = boxMesaj.values.toString();
                  _speak();
                  
                }),
          ),
        ],
      ),
    );
  }
}
