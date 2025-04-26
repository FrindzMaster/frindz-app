import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../env.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String mapboxKey = mapboxApiKey;

  final List<Map<String, dynamic>> events = [
    {
      'name': 'Open Air Electro',
      'image':
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=800&q=80',
      'category': 'Concert',
      'location': 'Parc de Vincennes',
      'lat': 48.841,
      'lng': 2.435,
      'date': '12 Avril',
      'time': '18h00',
      'host': 'ElectroZone',
      'participants': 134,
      'price': 'Gratuit',
    },
    {
      'name': 'Foot entre potes',
      'image':
          'https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf?auto=format&fit=crop&w=800&q=80',
      'category': 'Stade',
      'location': 'Stade de Montmartre',
      'lat': 48.890,
      'lng': 2.340,
      'date': '13 Avril',
      'time': '15h30',
      'host': 'Team Montmartre',
      'participants': 22,
      'price': '5€',
    },
    {
      'name': 'Pizza & Chill',
      'image':
          'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=800&q=80',
      'category': 'Restaurant',
      'location': 'Mama Roma République',
      'lat': 48.870,
      'lng': 2.364,
      'date': '14 Avril',
      'time': '20h00',
      'host': 'Mama Roma',
      'participants': 12,
      'price': 'À partir de 10€',
    },
  ];

  final mapController = MapController();
  LatLng? userLocation;

  final List<Map<String, dynamic>> categoriesWithIcons = [
    {"label": "Tous", "icon": Icons.dashboard},
    {"label": "Bar", "icon": Icons.local_bar},
    {"label": "Stade", "icon": Icons.sports_soccer},
    {"label": "Restaurant", "icon": Icons.local_pizza},
    {"label": "Concert", "icon": Icons.music_note},
    {"label": "Rando", "icon": Icons.hiking},
    {"label": "Rencontre", "icon": Icons.chat_bubble},
  ];

  String selectedCategory = "Tous";

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Concert':
        return Icons.music_note;
      case 'Restaurant':
        return Icons.restaurant_menu;
      case 'Stade':
        return Icons.sports_soccer;
      case 'Bar':
        return Icons.local_bar;
      case 'Rencontre':
        return Icons.people_outline;
      case 'Rando':
        return Icons.landscape;
      default:
        return Icons.location_on;
    }
  }

  // ← Voici la méthode réécrite pour afficher l'image avec contour dégradé
  Widget buildCustomMarker(String imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFFE6E6FA), // Lavande
            Color(0xFF87CEFA), // Bleu ciel
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(3), // épaisseur du contour
      child: ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover)),
    );
  }

  Future<void> _centerOnUser() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

    mapController.move(LatLng(position.latitude, position.longitude), 14.5);
  }

  @override
  void initState() {
    super.initState();
    _centerOnUser();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents =
        selectedCategory == "Tous"
            ? events
            : events.where((e) => e['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(48.8566, 2.3522),
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=$mapboxKey',
                userAgentPackageName: 'com.example.frindz_app',
              ),
              MarkerLayer(
                markers: [
                  if (userLocation != null)
                    Marker(
                      width: 25,
                      height: 25,
                      point: userLocation!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  // ← et ici on passe imageUrl au lieu de l'icone
                  ...filteredEvents.map((event) {
                    return Marker(
                      width: 50,
                      height: 50,
                      point: LatLng(event['lat'], event['lng']),
                      child: buildCustomMarker(event['image'] as String),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),

          // Bouton de recentrage
          Positioned(
            top: 250,
            right: 16,
            child: GestureDetector(
              onTap: _centerOnUser,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: Icon(Icons.my_location, color: Colors.black87),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Start your search",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category scroll bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: List.generate(categoriesWithIcons.length, (
                          index,
                        ) {
                          final item = categoriesWithIcons[index];
                          final isSelected = selectedCategory == item['label'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = item['label'];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    isSelected
                                        ? const Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        )
                                        : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item['icon'],
                                    size: 24,
                                    color:
                                        isSelected ? Colors.black : Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['label'],
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.black
                                              : Colors.grey,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Events
          DraggableScrollableSheet(
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: filteredEvents.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 4),
                            child: Center(
                              child: Icon(Icons.keyboard_arrow_up, size: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Center(
                              child: Text(
                                "${filteredEvents.length} événements disponibles à Paris",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (index == 1) {
                      return Container(height: 20, color: Colors.white);
                    }

                    final event = filteredEvents[index - 2];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                event['image'],
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event['location'],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("${event['date']} à ${event['time']}"),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${event['participants']} participants",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${event['price']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
