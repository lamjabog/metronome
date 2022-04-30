import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: UI()));
}

class UI extends StatefulWidget {
  @override
  State<UI> createState() => _UIState();
}

class _UIState extends State<UI> {
  final met = Metronome();
  var tController = TextEditingController();
  double bpm = 60.0;

  List<DropdownMenuItem<double>> _createDropdownitems() {
    List<DropdownMenuItem<double>> menu = [];
    for (double i = 60; i <= 300; i++) {
      menu.add(DropdownMenuItem(
        child: Text("$i"),
        value: i,
      ));
    }
    return menu;
  }

  Widget _controlsBuilder(BuildContext context, Metronome game) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () => game.startMetronome(),
              child: const Text("start"),
            ),
            TextButton(
              onPressed: () => game.stopMetronome(),
              child: const Text("stop"),
            ),
            Card(
              child: DropdownButton(
                value: bpm,
                items: _createDropdownitems(),
                onChanged: (double? value) {
                  game.updateBPM(value!);
                  setState(() {
                    bpm = value;
                  });
                },
                // keyboardType: TextInputType.number,
              ),
            ),
            TextButton(
              onPressed: () {
                game.updateBPM(double.parse(tController.text));
              },
              child: const Text("change bpm"),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: met,
      overlayBuilderMap: {
        'controls': _controlsBuilder,
      },
      initialActiveOverlays: ['controls'],
    );
  }
}

class Metronome extends FlameGame {
  // final countdown = Timer(60.0 / 90.0);
  late Timer interval;
  int count = 0;

  Metronome() {
    interval = Timer(
      60.0 / 60.0,
      onTick: () {
        if (count % 3 == 0) {
          FlameAudio.audioCache.play('toom.wav');
        } else {
          FlameAudio.audioCache.play('click.wav');
        }
        count += 1;
      },
      repeat: true,
      autoStart: false,
    );
  }

  void stopMetronome() {
    interval.stop();
    count = 0;
  }

  void startMetronome() {
    interval.start();
  }

  void updateBPM(double newBPM) {
    interval = Timer(
      60.0 / newBPM,
      onTick: () {
        if (count % 3 == 0) {
          FlameAudio.audioCache.play('toom.wav');
        } else {
          FlameAudio.audioCache.play('click.wav');
        }
        count += 1;
      },
      repeat: true,
      autoStart: false,
    );
  }

  @override
  Color backgroundColor() => const Color(0xFFFF9000);

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll(['click.wav', 'toom.wav']);
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
  }
}
