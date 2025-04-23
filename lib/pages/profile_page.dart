import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> interests = [
    'Jogging',
    'Randonnée',
    'Concert',
    'Football',
    'Cinéma',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxScrolled) => [
                SliverAppBar(
                  expandedHeight: 260,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.deepPurple,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFB388EB), Color(0xFF40E0D0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                child: Hero(
                                  tag: 'profile-photo',
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        const Text(
                          'Emma Johnson, 27',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '@emma.j  •  San Francisco, CA, USA',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        _buildMood("👀 Quelqu’un pour sortir"),
                        const SizedBox(height: 16),
                        _buildStats(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.deepPurple.shade100,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Text(
                              'Passionnée de musique, d’aventure et de rencontres inattendues. J’aime rire et partager de bons moments 🎶🌄',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInterests(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.deepPurple,
                      labelColor: Colors.deepPurple,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Publications'),
                        Tab(text: 'Médias'),
                      ],
                    ),
                  ),
                ),
              ],
          body: TabBarView(
            controller: _tabController,
            children: [_buildPosts(), _buildMedia()],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statItem('Activité', '23'),
        _statItem('Frindz', '58'),
        _statItem('Likes', '129'),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF40E0D0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF40E0D0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMood(String mood) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(mood, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildInterests() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Wrap(
        spacing: 8,
        children:
            interests
                .map(
                  (interest) => Chip(
                    label: Text(interest),
                    backgroundColor: Colors.deepPurple.shade100,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildPosts() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _postCard(
          username: 'emma.j',
          time: '2h',
          text: 'Qui est dispo pour un fifa ce soir ? 🎮',
          imageUrl:
              'https://images.unsplash.com/photo-1606490102015-697a49636e32',
        ),
        _postCard(
          username: 'emma.j',
          time: '1j',
          text: 'Balade au parc avec du bon son 🎧',
          imageUrl:
              'https://images.unsplash.com/photo-1508002366005-75a695ee2d17',
        ),
      ],
    );
  }

  Widget _postCard({
    required String username,
    required String time,
    required String text,
    required String imageUrl,
  }) {
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
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                ),
              ),
              title: Text(username),
              subtitle: Text(time),
            ),
            Text(text),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.favorite_border),
                Icon(Icons.chat_bubble_outline),
                Icon(Icons.handshake),
                Icon(Icons.bookmark_border),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia() {
    List<String> mediaUrls = [
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      'https://images.unsplash.com/photo-1508002366005-75a695ee2d17',
      'https://images.unsplash.com/photo-1554651802-57f1d69a4944',
      'https://images.unsplash.com/photo-1606490102015-697a49636e32',
    ];

    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(8),
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children:
          mediaUrls.map((url) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
