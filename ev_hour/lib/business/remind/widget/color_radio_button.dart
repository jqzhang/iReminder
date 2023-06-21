import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemindBorderColor {
  static const String Default = '0x42000000';
  static const String Red = '0xFFFF1744';
  static const String Blue = '0xFF2979FF';
  static const String Green = '0xFF43A047';
  // static const String Purple = '0xFF651FFF';
  static const String Orange = '0xFFF57C00';
}

Color getColor(String color) {
  return Color(int.parse(color.toString()));
}

List<Color> remindBorderColorList = [
  getColor(RemindBorderColor.Red),
  getColor(RemindBorderColor.Blue),
  getColor(RemindBorderColor.Green),
  // getColor(RemindBorderColor.Purple),
  getColor(RemindBorderColor.Orange),
];

class ColorRadioButton extends StatefulWidget {
  final List<Color> buttonColors;
  final void Function(int index, Color color)? onSelected;
  final int defaultSelectedIndex;
  bool? canSelect = true;

  ColorRadioButton({
    required this.buttonColors,
    this.onSelected,
    this.defaultSelectedIndex = -1,
    this.canSelect = true,
  });

  @override
  _ColorRadioButtonState createState() => _ColorRadioButtonState();
}

class _ColorRadioButtonState extends State<ColorRadioButton> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    int index = widget.defaultSelectedIndex;
    _selectedIndex = index >= widget.buttonColors.length ? 0 : index;
  }

  void _handleTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (widget.onSelected != null) {
      widget.onSelected!(index, widget.buttonColors[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        widget.buttonColors.length,
        (index) => _buildRadioButton(index),
      ),
    );
  }

  Widget _buildRadioButton(int index) {
    final isSelected = _selectedIndex == index;
    final color = widget.buttonColors[index];

    return GestureDetector(
      onTap: widget.canSelect!
          ? () {
              _handleTap(index);
            }
          : null,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: isSelected
            ? Icon(
                CupertinoIcons.check_mark,
                color: Colors.white,
                size: 24,
              )
            : null,
      ),
    );
  }
}
