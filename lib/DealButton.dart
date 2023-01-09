import 'package:flutter/material.dart';
import 'DealButtonState.dart';

class DealButton extends StatefulWidget
{
  bool _isPressed;
  String _text;
  // String _offText;
  // String _onText;

  double _width;
  double _height;

  Color _textColor;
  Color _bkgndColor;

  Color _offTextColor;
  Color _offBkgndColor;

  Color _onTextColor;
  Color _onBkgndColor;

  // DealButton(this._text, this._offText, this._onText, this._textColor, this._bkgndColor, {super.key});
  DealButton(this._text, this._width, this._height, this._textColor, this._bkgndColor, this._onTextColor, this._onBkgndColor, {super.key})
  :_isPressed = false, _offTextColor = _textColor, _offBkgndColor = _bkgndColor;


  @override
  State<StatefulWidget> createState() => DealButtonState();

  bool getIsPressed() {return _isPressed;}
  void setIsPressed(bool isPressed) => _isPressed = isPressed;

  String getText() {return _text;}
  void setText(String text) => _text = text;
  double getTextSize() {return (_text.length).toDouble();}

  // String getOffText() {return _offText;}
  // String setOffText(String text) => _offText = text;
  //
  // String getOnText() {return _onText;}
  // String setOnText(String text) => _onText = text;

  double getWidth() {return _width;}
  void setWidth(double width) => _width = width;

  double getHeight() {return _height;}
  void setHeight(double height) => _height = height;

  Color getTextColor() {return _textColor;}
  void setTextColor(Color color) => _textColor = color;

  Color getBkgndColor() {return _bkgndColor;}
  void setBkgndColor(Color color) => _bkgndColor = color;

  Color getOnTextColor() {return _onTextColor;}
  void setOnTextColor(Color color) => _onTextColor = color;

  Color getOnBkgndColor() {return _onBkgndColor;}
  void setOnBkgndColor(Color color) => _onBkgndColor = color;

  Color getOffTextColor() {return _offTextColor;}
  void setOffTextColor(Color color) => _offTextColor = color;

  Color getOffBkgndColor() {return _offBkgndColor;}
  void setOffBkgndColor(Color color) => _offBkgndColor = color;
}