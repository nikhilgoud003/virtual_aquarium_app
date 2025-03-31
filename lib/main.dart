import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(AquaWorldApp());

class AquaWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Aqua World',
      home: DeepSeaPage(),
    );
  }
}

class DeepSeaPage extends StatefulWidget {
  @override
  _DeepSeaPageState createState() => _DeepSeaPageState();
}

class _DeepSeaPageState extends State<DeepSeaPage>
    with TickerProviderStateMixin {
  List<MarineCreature> creatures = [];
  Color creatureColor = Colors.teal;
  double swimSpeed = 1.2;
  bool enableCollisions = true;
  late AnimationController _swimController;

  @override
  void initState() {
    super.initState();
    _swimController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  void addCreature() {
    if (creatures.length >= 12) return;

    final random = Random();
    setState(() {
      creatures.add(MarineCreature(
        color: creatureColor,
        speed: swimSpeed,
        x: random.nextDouble() * 300,
        y: random.nextDouble() * 300,
        dx: (random.nextDouble() * 2 - 1) * swimSpeed,
        dy: (random.nextDouble() * 2 - 1) * swimSpeed,
      ));
    });
  }

  void updateCreatures() {
    for (var creature in creatures) {
      creature.x += creature.dx;
      creature.y += creature.dy;

      if (creature.x <= 0 || creature.x >= 300) creature.dx *= -1;
      if (creature.y <= 0 || creature.y >= 300) creature.dy *= -1;
    }

    if (enableCollisions && creatures.length > 1) {
      for (int i = 0; i < creatures.length; i++) {
        for (int j = i + 1; j < creatures.length; j++) {
          final c1 = creatures[i];
          final c2 = creatures[j];
          final distance = sqrt(pow(c1.x - c2.x, 2) + pow(c1.y - c2.y, 2));

          if (distance < 30) {
            c1.dx *= -1;
            c1.dy *= -1;
            c2.dx *= -1;
            c2.dy *= -1;

            c1.color = Color.fromRGBO(
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
              1,
            );
            c2.color = Color.fromRGBO(
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
              1,
            );
          }
        }
      }
    }
  }
