import 'package:flutter/material.dart';

class ColorConstants {
  static List<String> bgColorList = [
    "{\"backgroundImage\":\"linear-gradient(45deg, rgb(255, 115, 0) 0%, rgb(255, 0, 234) 100%)\"}",
    "{\"backgroundImage\":\"linear-gradient(135deg, rgb(143, 199, 173), rgb(72, 229, 169))\"}",
    "{\"backgroundImage\":\"linear-gradient(135deg, rgb(116, 167, 126), rgb(24, 175, 78))\"}",
    "{\"backgroundImage\":\"linear-gradient(45deg, rgb(255, 127, 17) 0%, rgb(255, 127, 17) 100%)\"}",
    "{\"backgroundImage\":\"linear-gradient(45deg, rgb(233, 255, 66) 0%, rgb(0, 255, 225) 100%)\"}",
  ];

  static List<LinearGradient> gradientsColor = const [
    // Index 0 - Design placeholder
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
    ),
    // Index 1 - White color
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
    ),
    // Index 2 - Orange to Pink
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [Color(0xFFff00ea), Color(0xFFff7300)],
    ),
    // Index 3 - Green gradient
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(-135),
      colors: [
        Color.fromRGBO(72, 229, 169, 1),
        Color.fromRGBO(143, 199, 173, 1),
      ],
    ),
    // Index 4 - Dark green gradient
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(116, 167, 126, 1),
        Color.fromRGBO(24, 175, 78, 1),
      ],
    ),
    // Index 5 - Orange solid
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFff7f11), Color(0xFFff7f11)],
    ),
    // Index 6 - Cyan to Yellow
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [Color(0xFF00ffe1), Color(0xFFe9ff42)],
    ),
  ];
}
