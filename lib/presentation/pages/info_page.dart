import "package:flutter/material.dart";

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Информационная страница"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      )
    );
  }
}
