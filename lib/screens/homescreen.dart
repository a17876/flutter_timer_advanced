import 'package:flutter/material.dart';
import "dart:async";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentuFiveMinutes = 1500;
  int totalSeconds = twentuFiveMinutes;
  late Timer timer; // 버튼을 누를 때만 타이머가 생성되게 late를 써줌
  int totalRound = 0;
  bool isRunning = false;
  List targetMinutes = [5, 10, 15, 20, 25, 30];
  late int target;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalRound += 1;
        isRunning = false;
        totalSeconds = twentuFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );

    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void onClickTargetMinute(target) {
    setState(() {
      totalSeconds = target * 60;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("POMOTIMER"),
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
        ),
        body: Column(
          children: [
            Flexible(
              // 시간
              flex: 2,
              child: Container(
                color: Theme.of(context).colorScheme.background,
                alignment: Alignment.center,
                child: Text(
                  format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              // listview
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.white,
                        Colors.transparent
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            target = targetMinutes[index];
                            onClickTargetMinute(target);
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                            ),
                            child: Text(
                              '${targetMinutes[index]}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: 40,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: targetMinutes.length),
                ),
              ),
            ),
            Flexible(
              // play and pause icon
              flex: 1,
              child: Center(
                child: IconButton(
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon: isRunning
                      ? const Icon(Icons.pause)
                      : const Icon(
                          Icons.play_arrow,
                        ),
                  iconSize: 70,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
            Flexible(
              // Round 0 /4 / goal  0/12
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$totalRound",
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          const Text(
                            "ROUND",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
