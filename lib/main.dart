import 'package:flutter/material.dart';
import 'DealButton.dart';
import 'ScrollList.dart';
import 'TextFunc.dart';

String _pkgBar = "Package Info";
String _originBar = "Origin";
String _destBar = "Destination";

double _barTextSize = 15;
double _pkgBarWidth = 108;
double _originBarWidth = 70;
double _destBarWidth = 92;

double _sendButtonWidth = 108;
double _sendButtonHeight = 20;

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  Widget appBarRow()
  {
      return Row
      (
        children:
        [
          Container
          (
            width: _pkgBarWidth,
            child: TextFunc.printText(_pkgBar, _barTextSize, true),
          ),
          Container
          (
            width: _originBarWidth,
            child: TextFunc.printText(_originBar, _barTextSize, true),
          ),
          Container
          (
              width: _destBarWidth,
              child: TextFunc.printText(_destBar, _barTextSize, true),
          ),
          Container
          (
            width: _sendButtonWidth,
            alignment: Alignment.centerRight,
            child: DealButton("Send Offers", _sendButtonWidth, _sendButtonHeight,
                Colors.black, Colors.green.shade100, Colors.white, Colors.green),
          ),

        ],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Transporter Delivery Search Screen',
      home: Scaffold
      (
        appBar: AppBar
        (
          // title: Text("Transporter Delivery Search Screen"),
            title: appBarRow(),
        ),
        body: Center
        (
          child: ScrollList(),
        ),
      ),
    );
  }
}
