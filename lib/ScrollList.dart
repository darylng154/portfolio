import 'package:flutter/material.dart';
import 'ButtonContainer.dart';

String _origin = "Denver, Co";
String _dest1 = "Fort Collins, Co";
String _dest2 = "Colorado Springs, Colorado";
String _dest3 = "Longmont, Co";
String _dest4 = "Cheyenne, Wy";
String _cargo = "Southwest Cargo";

const int _numItems = 7;

DateTime _today = DateTime.now();
DateTime _dec2 = DateTime(2022, 12, 2);
DateTime _dec3 = DateTime(2022, 12, 3);

double _itemPadding = 5;

class ScrollList extends StatefulWidget
{
  const ScrollList({super.key});

  @override
  State<ScrollList> createState() => _PkgListState();
}

class _PkgListState extends State<ScrollList>
{
  // final int _numItems = 7;

  final List<ButtonContainer> _buttonArray =
  [
    ButtonContainer
    (
        0, 28.25, 100, "Small", _today, _origin, _dest1, _cargo
    ),
    ButtonContainer
    (
        1, 50.10, 100, "Medium", _dec3, _origin, _dest2, _cargo
    ),
    ButtonContainer
    (
        2, 18.50, 100, "Small", _today, _origin, _dest3, _cargo
    ),
    ButtonContainer
    (
        3, 77.50, 300, "Large", _dec2, _origin, _dest4, _cargo
    ),

    ButtonContainer
      (
        3, 54.99, 150, "Medium", _dec3, _origin, _dest2, _cargo
    ),
    ButtonContainer
      (
        3, 99.99, 380, "Large", _dec2, _origin, _dest4, _cargo
    ),
    ButtonContainer
      (
        3, 20.32, 100, "Small", _today, _origin, _dest1, _cargo
    )
  ];

  @override
  Widget build(BuildContext context)
  {
    return ListView.builder
    (
      padding: EdgeInsets.only(top: _itemPadding, bottom: _itemPadding),

      itemBuilder: (context, i)
      {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;

        // if (index >= _anyArray.length)
        if (index >= _numItems)
        {
          return ListTile
          (
            onTap: ()
            {
              // change to ship form screen
            },
            title: ButtonContainer
            (
              index, 150.50, 300, "Large", _dec3, _origin, _dest2, _cargo
            ),
          );
        }

        return ListTile
        (
          onTap: ()
          {
            // change to ship form screen
          },

          title: Container
          (
            padding: EdgeInsets.only(top: _itemPadding, bottom: _itemPadding),
            child:
            _buttonArray[index],
          ),
        );
      },
    );
  }
}