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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OceanX Explorer')),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlue[100]!, Colors.blue[200]!],
              ),
            ),
            child: AnimatedBuilder(
              animation: _swimController,
              builder: (context, _) {
                updateCreatures();
                return Stack(
                  children: creatures
                      .map((creature) => Positioned(
                            left: creature.x - 15,
                            top: creature.y - 15,
                            child: Transform.rotate(
                              angle: atan2(creature.dy, creature.dx),
                              child: CustomPaint(
                                painter: SeaLifePainter(color: creature.color),
                                size: Size(30, 20),
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: addCreature,
                      child: Text('Add Marine Life'),
                      style: ElevatedButton.styleFrom(
                          // primary: Colors.blueGrey,
                          ),
                    ),
                    Text('Creatures: ${creatures.length}'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Color Scheme:'),
                    DropdownButton<Color>(
                      value: creatureColor,
                      items: [
                        Colors.teal,
                        Colors.deepOrange,
                        Colors.indigo,
                        Colors.lightGreen,
                        Colors.purple,
                      ]
                          .map((color) => DropdownMenuItem(
                                value: color,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  color: color,
                                ),
                              ))
                          .toList(),
                      onChanged: (color) =>
                          setState(() => creatureColor = color!),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Swim Velocity:'),
                    Slider(
                      value: swimSpeed,
                      min: 0.5,
                      max: 3.0,
                      divisions: 5,
                      onChanged: (value) => setState(() {
                        swimSpeed = value;
                        for (var creature in creatures) {
                          creature.dx = (creature.dx.sign) * value;
                          creature.dy = (creature.dy.sign) * value;
                        }
                      }),
                    ),
                  ],
                ),
                if (creatures.length >= 2)
                  SwitchListTile(
                    title: Text('Marine Interactions'),
                    value: enableCollisions,
                    onChanged: (value) =>
                        setState(() => enableCollisions = value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarineCreature {
  Color color;
  double speed;
  double x, y;
  double dx, dy;

  MarineCreature({
    required this.color,
    required this.speed,
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
  });
}
