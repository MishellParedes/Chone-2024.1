import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ThemeApp {
  // static const Color primary = Color(0XFF1C4E77);
  static const Color primary = Color(0xFF1469B1);
  static const Color primaryLight = Color.fromARGB(34, 0, 136, 255);
  static const Color secondary = Color(0xFFE66228);
  static const Color secondaryLight = Color.fromARGB(49, 255, 77, 0);
  static const Color tertiary = Color(0xFFf2f7ff);
  static const Color quaternary = Color(0xFF2D4777);
  static const Color quinary = Color(0xFF1C4549);
  static const Color sixtieth = Color(0xFF454545);

  static const Color dialogsTxt = Color(0xFF454545);
  static const Color loading = Color(0xFF192237);
  static const Color icons = Color(0xFF7E84A3);
  static const Color btnTxt = Color(0xFF5A607F);
  static const Color borderInputs = Color(0xFFD7DBEC);
  static const Color borderSettings = Color(0XFFA0A0A0);

  static const Color shadowCardsGrey = Color.fromRGBO(0, 0, 0, 0.55);
  static const Color shadowBigContainer = Color.fromRGBO(21, 34, 50, 0.08);

  static const Color backgroundColor = Color(0xFFF3F4FA);
  static const Color foregroundColor = Color(0xFF000000);
  static const Color mainHeaderAccentColor = Color(0xFFE66228);

  static const Color accentSidebarColor = Color(0xFFE66228);
  static const Color accentSidebarColor2 = Color.fromARGB(255, 255, 188, 159);
  static const Color iconBackgroundInStatus = Color(0xFF1C4E77);
  static const Color tableBoxBackgroundColor = Color.fromARGB(125, 255, 255, 0);

  static const Color octanary = Color(0xFFFBFBFC);
  static const Color shadowCards = Color.fromRGBO(0, 0, 0, 0.06);
  static const Color white = Color(0xFFFFFFFF);

  static const TextStyle secondary20_800 = TextStyle(
    fontSize: 20,
    color: secondary,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle primary18_800 = TextStyle(
    fontSize: 18,
    color: primary,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle sixtieth20_800 = TextStyle(
    fontSize: 20,
    color: sixtieth,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle sixtieth16_600 = TextStyle(
    fontSize: 16,
    color: sixtieth,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle white18 = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  static const TextStyle white18_600 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: white,
  );

  static const TextStyle white20_800 = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle white18_900 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle white30 = TextStyle(
    color: Colors.white,
    fontSize: 30,
  );

  static const TextStyle white33_900 = TextStyle(
    color: Colors.white,
    fontSize: 33,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle secondary23_900 = TextStyle(
    color: secondary,
    fontSize: 23,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle secondary20_700 = TextStyle(
    color: secondary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle black18_600 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle secondary18_600 = TextStyle(
    color: secondary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle primary18Bold = TextStyle(
    color: primary,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const TextStyle primary20 = TextStyle(
    color: primary,
    fontSize: 20,
  );

  static const TextStyle primary20Bold = TextStyle(
    color: primary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 65, 117, 195),
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      prefixIconColor: const Color.fromARGB(255, 57, 90, 155),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 144, 149, 161),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      floatingLabelStyle: const TextStyle(
        color: Color.fromARGB(255, 144, 149, 161),
      ),
    );
  }

  static InputDecoration inputDecorationReadOnly(String labelText) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Colors.grey.shade200,
      filled: true,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      prefixIconColor: Colors.grey.shade200,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      floatingLabelStyle: const TextStyle(color: Colors.grey),
    );
  }

  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 197, 214, 227)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: primary),
    borderRadius: BorderRadius.circular(8),
  );

  static final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: primary,
      border: Border.all(color: primary),
    ),
  );
}
