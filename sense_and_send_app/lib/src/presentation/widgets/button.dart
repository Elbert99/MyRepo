import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.icon, required this.text, required this.onPress}) : super(key: key);
  final IconData icon;
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      label: Text(text,style: const TextStyle(color: Colors.white, ),),
      icon:  Icon(icon),
      textColor: Colors.white,
      onPressed: onPress,
    );
  }


}
