import 'package:flutter/material.dart';
import 'package:testing/Classes/bodytext.dart';
import 'package:testing/globalVars.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 0: Small, 1: Medium, 2: Big
  int selectedIndex = 1;

  final List<double> textSizes = [0.8, 1, 1.2];
  final List<String> labels = ['Small', 'Medium', 'Big'];

  @override
  Widget build(BuildContext context) {
    // Temporary, eventually gonna store em in database
    bool lights = true;

    return MaterialApp(
      home: Scaffold(
        appBar: bar,
        body: ListView(
          children: [

            Divider(),
            SwitchListTile(
              subtitle: const Text("Testing Switch"),
              title: const Text('Placeholder 1'),
              value: lights,
              onChanged: (bool value) {
                setState(() {
                  lights = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            Divider(),
            SwitchListTile(
              subtitle: const Text("Testing Switch"),
              title: const Text('Placeholder 2'),
              value: lights,
              onChanged: (bool value) {
                setState(() {
                  lights = value;
                });
              },
              secondary: const Icon(Icons.add_card_outlined),
            ),
            Divider(),
            SwitchListTile(
              subtitle: const Text("Testing Switch"),
              title: const Text('Placeholder 3'),
              value: lights,
              onChanged: (bool value) {
                setState(() {
                  lights = value;
                });
              },
              secondary: const Icon(Icons.settings_system_daydream_outlined),
            ),
            Divider(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Text Sizes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(labels.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(labels[index]),
                            selected: selectedIndex == index,
                            onSelected: (selected) {
                              setTextSize(textSizes[selectedIndex]);
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: Text(
                    'Aa 123',
                    style: TextStyle(fontSize: textSizes[selectedIndex] * 22),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            Divider(),

          ],
        ),
      ),
    );
  }
}
