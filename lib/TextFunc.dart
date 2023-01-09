import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFunc
{
  // prints Text with No Clipping Behavior
  static Text printText(String str, double size, bool bold)
  {
    if(!bold)
    {
      return Text
      (
        str,
        style: TextStyle
          (
          color: Colors.black,
          fontSize: size,
          fontWeight: FontWeight.normal,
        ),
      );
    }
    else
    {
      return Text
      (
        str,
        style: TextStyle
          (
          color: Colors.black,
          fontSize: size,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  static Text printNoWrapText(String str, double size, bool bold)
  {
    if(!bold)
    {
      return Text
        (
        str,
        softWrap: false,
        style: TextStyle
          (
          color: Colors.black,
          fontSize: size,
          fontWeight: FontWeight.normal,
          overflow: TextOverflow.visible,
        ),
      );
    }
    else
    {
      return Text
        (
        str,
        softWrap: false,
        style: TextStyle
          (
          color: Colors.black,
          fontSize: size,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.visible,
        ),
      );
    }
  }

  // prints Text with Ellipsis Clipping
  static Text printClippedText(String str, double size, bool bold)
  {
    if(!bold)
    {
      return Text
        (
        str,
        style: TextStyle
          (
          color: Colors.black,
          fontSize: size,
          fontWeight: FontWeight.normal,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    else
    {
      return Text
      (
        str,
        style: TextStyle
          (
          color: Colors.black,
          fontSize: size,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}