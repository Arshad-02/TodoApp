import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String title, description;
  const Description(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Info')),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(children: [
            Container(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              child: Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
