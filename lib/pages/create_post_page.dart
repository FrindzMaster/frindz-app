import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedOption = 'Public';
    List<String> replyOptions = [
      'Public',
      'Comptes vérifiés',
      'Comptes suivis',
      'Comptes mentionnés',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Post', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              // action de publication
            },
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                  ),
                  radius: 22,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Exprime-toi... 👋',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StatefulBuilder(
              builder:
                  (context, setState) => Row(
                    children: [
                      const Icon(Icons.public, size: 20),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: selectedOption,
                        underline: const SizedBox(),
                        items:
                            replyOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedOption = value);
                          }
                        },
                      ),
                    ],
                  ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(FontAwesomeIcons.image, size: 28),
                Icon(FontAwesomeIcons.faceGrinSquintTears, size: 28),
                Icon(FontAwesomeIcons.chartColumn, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
