import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Contoh2(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> data = [];
  Future<List<String>> getUserData() async {
    data = ['Bunny', 'Funny', 'Miles'];
    await Future.delayed(const Duration(seconds: 3), () {
      print('Downloaded ${data.length} data');
    });
    return getUserData();
  }

  void getData() {
    setState(() {
      getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Daftar Pengguna',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '$data',
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                getData();
                print(data);
              },
              child: Text('klick'),
            )
          ],
        ),
      ),
    );
  }
}

class Contoh2 extends StatefulWidget {
  const Contoh2({super.key});

  @override
  State<Contoh2> createState() => _Contoh2State();
}

class _Contoh2State extends State<Contoh2> {
  bool isReset = false;
  bool isPlay = false;
  bool isPaused = false;
  bool isSubscribed = false;
  String desc = "";
  int percent = 100;
  int getSteam = 0;
  double circular = 1;
  late StreamSubscription _sub;
  final Stream _myStream =
      Stream.periodic(const Duration(seconds: 1), (int count) {
    return count;
  });

  String isFull(inp) {
    if (inp == 100) {
      desc = "\nFull";
    } else if (inp == 0) {
      desc = "\nEmpty";
    } else {
      desc = "";
    }
    return desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("stream")),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          // final double avaWidth = constraints.maxWidth;
          final double avaHeight = constraints.maxHeight;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    percent = 100;
                    circular = percent / 100;
                    isPaused = true;
                    print(isPaused);
                  },
                  child: Text('Reset')),
              Expanded(
                  child: CircularPercentIndicator(
                header: Text(isFull(percent)),
                radius: avaHeight / 5,
                lineWidth: 10,
                percent: circular,
                center: Text("$percent %"),
              ))
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isPlay = !isPlay;
            print(isPaused);
          });
          if (isPlay) {
            if (isSubscribed) {
              isSubscribed = true;
              _sub = _myStream.listen((event) {
                getSteam = int.parse(event.toString());
              });
              setState(() {
                if (percent - getSteam <= 0) {
                  isSubscribed = false;
                  _sub.cancel();
                  percent = 0;
                  circular = 0;
                } else {
                  percent = percent - getSteam;
                  circular = percent / 100;
                }
              });
            } else {
              isPaused = true;
              _sub.pause();
            }
          }
        },
        child: isPlay ? Icon(Icons.play_arrow) : Icon(Icons.pause),
      ),
    );
  }
}
