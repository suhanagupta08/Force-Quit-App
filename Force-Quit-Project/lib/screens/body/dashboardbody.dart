import 'dart:async';
import 'package:flutter/material.dart';

class NewStopWatch extends StatefulWidget {
  @override
  _NewStopWatchState createState() => _NewStopWatchState();
}

class _NewStopWatchState extends State<NewStopWatch> {
  Stopwatch watch = Stopwatch();
  Timer timer;
  bool startStop = true;

  IconData btnPlayStatus = Icons.play_arrow;

  String elapsedTime = '';

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/clock.png"), fit: BoxFit.cover)),
      child: Column(
        children: <Widget>[
          Text(elapsedTime, style: TextStyle(fontSize: 60.0, height: 2.0)),
          SizedBox(height: 2.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 50,
                child: FloatingActionButton(
                    shape: ContinuousRectangleBorder(),
                    heroTag: "btn1",
                    backgroundColor: Colors.green,
                    onPressed: () => startOrStop(),
                    child: Icon(btnPlayStatus)),
              ),
              SizedBox(height: 20.0, width: 30.0),
              Container(
                width: 100,
                height: 50,
                child: FloatingActionButton(
                    shape: ContinuousRectangleBorder(),
                    heroTag: "btn2",
                    backgroundColor: Colors.blueGrey,
                    onPressed: () => resetWatch(), //resetWatch,
                    child: Text('Reset')),
              ),
            ],
          )
        ],
      ),
    );
  }

  resetWatch() {
    setState(() {
      watch.reset();
      setTime();
    });
  }

  startOrStop() {
    if (startStop) {
      setState(() {
        btnPlayStatus = Icons.pause;
      });
      startWatch();
    } else {
      setState(() {
        btnPlayStatus = Icons.play_arrow;
      });
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();
    int days = (hours / 24).truncate();

    String daysStr = (days % 24).toString().padLeft(2, '0');
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$daysStr:$hoursStr:$minutesStr:$secondsStr";
  }
}
