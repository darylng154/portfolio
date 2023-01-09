import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DealButton.dart';
import 'TextFunc.dart';

String _strDollar = "\$";
String _strMiles = " mi @ ";
String _strMiles2 = "/mi";
String _strType = " Package";

double _pkgInfoWidth = 94;
double _pkgInfoBotPadding = 2;
double _dealButtonWidth = 108;
double _dealButtonHeight = 40;
double _offerButtonHeight = 25;
double _buttonLeftPadding = 8;
double _btwButtonsPadding = 10;

double _priceSize = 25;
double _textSize = 11;

double _originColWidth = 82;
double _originColLeftPadding = 14;

double _destColWidth = 87;

double _itemHeight = 90;

class ButtonContainer extends StatelessWidget
{
  int _index;
  double _offer;
  int _miles;
  String _type;

  DateTime _pickUpDate;

  String _origin;
  String _dest;
  String _cargo;

  DealButton _dealButton;
  DealButton _offerButton;
  IconButton _mapsButton;

  ButtonContainer(this._index, this._offer, this._miles, this._type, this._pickUpDate, this._origin, this._dest, this._cargo, {super.key})
  :_dealButton = DealButton("Deal @ \n\$${_offer.toStringAsFixed(2)}", _dealButtonWidth, _dealButtonHeight,
      Colors.black, Colors.green.shade100, Colors.white, Colors.green),

  _offerButton = DealButton("\$ Make Offer", _dealButtonWidth, _offerButtonHeight,
  Colors.black, Colors.green.shade100, Colors.white, Colors.green),

  // preferred Button for Maps
  _mapsButton = IconButton
  (
    alignment: Alignment.bottomRight,
    icon: Image.asset('assets/images/googleMaps.png'),
    onPressed: ()
    {
      // route using google maps
    },
  )
  ;

  int getIndex(){return _index;}
  void setIndex(int index) => _index = index;

  double getOffer(){return _offer;}
  void setOffer(double offer) => _offer = offer;
  String getOfferText(){return _offer.toStringAsFixed(2);}

  int getMiles(){return _miles;}
  void setMiles(int miles) => _miles = miles;
  double getCostPerMiles(){return _offer/_miles.toDouble();}

  String getType(){return _type;}
  void setType(String type) => _type = type;

  DealButton getDealButton(){return _dealButton;}
  DealButton getOfferButton(){return _offerButton;}
  IconButton getMapsButton(){return _mapsButton;}

  Widget pkgCol()
  {
    return Container
    (
      width: _pkgInfoWidth,
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Container
          (
            padding: EdgeInsets.only(bottom: _pkgInfoBotPadding),
            child: TextFunc.printText("$_strDollar${getOfferText()}", _priceSize, true),
          ),

          Container
          (
            padding: EdgeInsets.only(bottom: _pkgInfoBotPadding),
            child: TextFunc.printText("${getMiles()}"
              "$_strMiles"
              "$_strDollar${getCostPerMiles().toStringAsFixed(2)}"
              "$_strMiles2"
              , _textSize, false),
          ),

          Container
          (
            padding: const EdgeInsets.only(bottom: 0),
            child: TextFunc.printText("${getType()}"
              "$_strType"
              , _textSize, false),
          ),

          // check index
          // Container
          // (
          //   child: printText(_index.toString(), 15, true),
          // ),
        ],
      )
    );
  }

  Widget originCol()
  {
    return Container
    (
      width: _originColWidth,
      padding: EdgeInsets.only(left: _originColLeftPadding),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          TextFunc.printClippedText(_origin, _textSize, false),

          Expanded
          (
            // padding: const EdgeInsets.only(bottom: 0),
            // child: TextFunc.printClippedText("Pickup Date", _textSize, false),
            // child: TextFunc.printClippedText("", _textSize, false),
            child: TextFunc.printClippedText("${_isReady(_pickUpDate)}", _textSize, false),
          ),

          Container
          (
            alignment: Alignment.bottomLeft,
            child: TextFunc.printNoWrapText(_cargo, _textSize, false),
          ),
        ],
      )
    );
  }

  Widget destCol()
  {
    return Container
    (
      height: _itemHeight,
      width: _destColWidth,
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          Expanded
          (
            child: TextFunc.printClippedText(_dest, _textSize, false),
          ),

          Container
          (
            alignment: Alignment.bottomRight,
            // padding: const EdgeInsets.all(0),
            child: _mapsButton,
          ),
        ]
      )
    );
  }

  Widget buttonsCol()
  {
    return Container
    (
      padding: EdgeInsets.only(left: _buttonLeftPadding),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children:
        [
          Container
          (
            padding: EdgeInsets.only(bottom: _btwButtonsPadding),
            child: _dealButton,
          ),

          Container
          (
            child: _offerButton,
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      height: _itemHeight,
      child: Row
      (
        children:
        [
          pkgCol(),
          Expanded(child: originCol()),
          Expanded(child: destCol()),
          buttonsCol(),
        ],
      )
    );
  }

  bool _isToday(DateTime date)
  {
    if(date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  String _isReady(DateTime date)
  {
    // if(date == DateTime.now())
    // if(date.isAtSameMomentAs(DateTime.now()))
    if(_isToday(date))
    {
      return "Ready Now";
    }
    else
    {
      // return date.toString();
      return DateFormat.yMMMd('en_US').format(date);
    }
  }
}