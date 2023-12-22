import 'package:flutter/material.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class FlatInputRoundedOutlinedFieldLight extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextEditingController myController;
  final double widgetWidth;
  final bool readOnly;
  // var myController = TextEditingController();
  const FlatInputRoundedOutlinedFieldLight({
    Key? key,
    required this.hintText,
    this.icon = Icons.search_outlined,
    required this.onChanged,
    required this.onSubmitted,
    required this.myController,
    required this.widgetWidth,
    required this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: widgetWidth,
      height: 30,
      child: SizedBox(
        width: size.width * 0.8,
        height: 25,
        // border: Border(bottom: BorderSide(color: Colors.black)),
        child: TextField(
          textAlign: TextAlign.center,
          controller: myController,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 17, color: ThemeApp.secondary),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ThemeApp.secondary, width: 0.0)),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 15, color: ThemeApp.secondary),
            // border: OutlineInputBorder(
            //   // gapPadding: 50,
            //   borderRadius: BorderRadius.circular(10),
            //   borderSide: BorderSide(
            //       width: 10, style: BorderStyle.solid, color: Colors.white),
            // ),
            labelStyle: const TextStyle(color: Colors.green),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.secondary, width: 0.0),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(0),
            fillColor: Colors.white,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}
