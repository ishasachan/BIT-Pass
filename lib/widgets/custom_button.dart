import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        color: Colors.brown,
        onPressed: () { onPressed(); },
        child: Text(text, style: const TextStyle(color: Colors.white), ),
      ),
    );
  }
}
