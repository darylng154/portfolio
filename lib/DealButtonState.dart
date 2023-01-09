import 'package:flutter/material.dart';
import 'DealButton.dart';

String buttonText1 = "Button 1 Here";
String buttonText2 = "Button 2 Here";

double _textSize = 12;

class DealButtonState extends State<DealButton>
{
  // bool _isPressed = false;
  // text button widget instead of ButtonIcons

  @override
  Widget build(BuildContext context)
  {
    return SizedBox
    (
      width: widget.getWidth(),
      height: widget.getHeight(),

      child:
      ElevatedButton
      (
        style: ElevatedButton.styleFrom
        (
          // background color
          backgroundColor: widget.getBkgndColor(),
          // text color
          foregroundColor: widget.getTextColor(),
          shape: RoundedRectangleBorder
          (
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide
            (
              width: 1,
              color: Colors.black,
            ),
          ),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),

        onPressed:()
        {
          _toggleButton();
        },

        child: Text
        (
          widget.getText(),
          // allows Text to go outside of Button but is not centered
          // softWrap: false,
          // style: const TextStyle
          // (
          //   overflow: TextOverflow.visible
          // ),
          style: TextStyle
          (
            fontSize: _textSize,
          ),
        ),
      ),
    );
  }

  void _toggleButton()
  {
    setState(()
    {
      if(widget.getIsPressed())
      {
        widget.setTextColor(widget.getOffTextColor());
        widget.setBkgndColor(widget.getOffBkgndColor());
        widget.setIsPressed(false);
      }
      else
      {
        widget.setTextColor(widget.getOnTextColor());
        widget.setBkgndColor(widget.getOnBkgndColor());
        widget.setIsPressed(true);
      }
    });
  }
}