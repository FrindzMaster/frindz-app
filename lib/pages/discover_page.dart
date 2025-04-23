import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late List<SwipeItem> _swipeItems;
  late MatchEngine _matchEngine;

  List<Map<String, dynamic>> users = [
    {
      "name": "Emma",
      "age": 24,
      "intention": "Dispo pour une balade 🌿",
      "distance": "à 500m",
      "image": "https://images.unsplash.com/photo-1607746882042-944635dfe10e",
    },
    {
      "name": "Léo",
      "age": 28,
      "intention": "Envie de boire un verre 🍻",
      "distance": "à 1km",
      "image": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
    },
    {
      "name": "Jade",
      "age": 22,
      "intention": "Partante pour une partie de padel 🎾",
      "distance": "à 2km",
      "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
    },
  ];

  @override
  void initState() {
    super.initState();

    _swipeItems =
        users.map((user) {
          return SwipeItem(
            content: user,
            likeAction: () {
              print("🔥 Matché avec ${user['name']}");
            },
            nopeAction: () {
              print("❌ Passé ${user['name']}");
            },
          );
        }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.yellow, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Rencontre Spontanée',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildCard(user);
                },
                onStackFinished: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Plus personne à découvrir.")),
                  );
                },
                itemChanged: (SwipeItem item, int index) {
                  debugPrint("Item à l'écran : ${item.content['name']}");
                },
                upSwipeAllowed: false,
                fillSpace: true,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _matchEngine.currentItem?.nope();
                    },
                    icon: const Icon(Icons.close, color: Colors.black),
                    label: const Text(
                      "Passer",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _matchEngine.currentItem?.like();
                    },
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    label: const Text(
                      "Je suis chaud(e)",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB388EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(user['image'], fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user["name"]}, ${user["age"]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user["intention"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(Icons.wb_sunny, color: Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user["distance"],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
