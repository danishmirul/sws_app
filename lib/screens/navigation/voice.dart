import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/models/direction.dart';

class VoiceWidget extends StatefulWidget {
  VoiceWidget(
      {@required this.direction, @required this.updateDirection, Key key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;

  @override
  _VoiceWidgetState createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
    return Container(
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
                    _text,
                    style: TextStyle(fontSize: 32.0, color: cSecondaryColor),
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
                    widget.direction != null ? widget.direction.label : '',
                    style: TextStyle(
                        fontSize: 24.0, color: widget.direction.color),
                  ),
                ],
              ),
            ),
          ),
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      widget.updateDirection('Stop');
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      updateDirection();
    }
  }

  void updateDirection() {
    print('Confidence: $_confidence');
    switch (_text) {
      case 'forward':
      case 'forwards':
      case 'Forward':
      case 'Forwards':
        widget.updateDirection('Forward');
        break;
      case 'backward':
      case 'backwards':
      case 'Backward':
      case 'Backwards':
        widget.updateDirection('Backward');
        break;
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

class Voice extends StatelessWidget {
  const Voice(
      {@required this.direction, @required this.updateDirection, Key key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;

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
                color: cAccentColor,
              ),
              child: VoiceWidget(
                direction: direction,
                updateDirection: updateDirection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
