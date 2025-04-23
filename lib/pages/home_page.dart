import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile_page.dart';
import 'package:frindz_app/pages/create_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _fabOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse && _fabOpacity != 0.4) {
        setState(() => _fabOpacity = 0.4);
      } else if (direction == ScrollDirection.forward && _fabOpacity != 1.0) {
        setState(() => _fabOpacity = 1.0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: const Hero(
              tag: 'profile-photo',
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                ),
              ),
            ),
          ),
        ),
        title: const Center(
          child: FaIcon(FontAwesomeIcons.handshakeAngle, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.solidBell, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(label: Text('Motivated'), selected: false),
              ChoiceChip(label: Text('Chill'), selected: false),
              ChoiceChip(label: Text('Down to hang out'), selected: false),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '👋 Des Frindz sont dispo autour de toi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Voir plus →'),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 175,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1508002366005-75a695ee2d17',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Mél, 24'),
                      const Text('Partante pour un verre 🍻'),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('👋 Say Hi'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '📰 Exprime-toi pour te faire de nouveaux amis 👇',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          _buildPostCard(),
          _buildPostCard(),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: _fabOpacity,
        child: FloatingActionButton(
          onPressed: () {
            print('Créer un post');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostPage()),
            );
          },
          backgroundColor: Colors.deepPurple,
          shape: const CircleBorder(), // ✅ bouton bien rond
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPostCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1554651802-57f1d69a4944',
                ),
              ),
              title: const Text('[Username]'),
              subtitle: const Text('2h'),
            ),
            const Text('Qui est dispo pour un fifa?  psn : Plikizito97'),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://images.unsplash.com/photo-1606490102015-697a49636e32',
                fit: BoxFit.cover,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.favorite, color: Colors.red),
                Icon(Icons.chat_outlined),
                Icon(Icons.handshake_sharp),
                Icon(Icons.bookmark_border),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
