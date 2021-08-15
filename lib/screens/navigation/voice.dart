import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/custom_text.dart';
import 'package:sws_app/models/direction.dart';

class Voice extends StatefulWidget {
  final Direction direction;
  final Function updateDirection;
  Voice({@required this.direction, @required this.updateDirection, Key key})
      : super(key: key);

  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  String text = 'Voice';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    widget.updateDirection('Stop');
  }

  @override
  void dispose() {
    widget.updateDirection('Stop');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Container(
              height: size.height * 0.8,
              decoration: BoxDecoration(
                color: isListening ? Colors.amber : Colors.white,
              ),
              child: Container(
                width: size.width,
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.6,
                      width: size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                  fontSize: 32.0, color: cSecondaryColor),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Direction',
                              style: TextStyle(fontSize: 24.0),
                            ),
                            Container(
                              child: ColorFiltered(
                                child: Image.asset(widget.direction.asset),
                                colorFilter: ColorFilter.mode(
                                    widget.direction.color, BlendMode.modulate),
                              ),
                            ),
                            Text(
                              widget.direction != null
                                  ? widget.direction.label
                                  : '',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  color: widget.direction.color),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AvatarGlow(
                      animate: isListening,
                      glowColor: Colors.indigo,
                      endRadius: 75.0,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      child: FloatingActionButton(
                        onPressed: toggleRecording,
                        child: Icon(isListening ? Icons.mic : Icons.mic_none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future toggleRecording() {
    widget.updateDirection('Stop');
    return SpeechApi.toggleRecording(
      onResult: (text) {
        setState(() => this.text = text);
        updateDirection(text);
      },
      onListening: (isListening) {
        setState(() => this.isListening = isListening);
      },
    );
  }

  void updateDirection(String text) {
    switch (text) {
      case 'up':
      case 'Up':
      case 'front':
      case 'Front':
      case 'forward':
      case 'forwards':
      case 'Forward':
      case 'Forwards':
        widget.updateDirection('Forward');
        break;
      case 'down':
      case 'Down':
      case 'reverse':
      case 'Reverse':
      case 'backward':
      case 'backwards':
      case 'Backward':
      case 'Backwards':
        widget.updateDirection('Backward');
        break;
      case 'Breaks':
      case 'breaks':
      case 'Break':
      case 'break':
      case 'stop':
      case 'stops':
      case 'Stop':
      case 'Stops':
        widget.updateDirection('Stop');
        break;
      case 'right':
      case 'rights':
      case 'Right':
      case 'Rights':
        widget.updateDirection('Right');
        break;
      case 'left':
      case 'lefts':
      case 'Left':
      case 'Lefts':
        widget.updateDirection('Left');
        break;
      default:
        widget.updateDirection('Stop');
        break;
    }
  }
}

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({
    @required Function(String text) onResult,
    @required ValueChanged<bool> onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => print('Error: $e'),
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return isAvailable;
  }
}
