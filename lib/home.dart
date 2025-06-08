import 'package:flutter/material.dart';
import 'package:nomad_wallet/currency.dart';
import 'package:nomad_wallet/nearby_places_screen.dart';
import 'package:nomad_wallet/time_converter_screen.dart'; // Buat file baru untuk layar konversi waktu

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _currentLocation = "Bali, Indonesia";
  final String _currentTime = "12:30 PM";

  // Daftar fitur utama
  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.currency_exchange,
      'title': 'Currency Converter',
      'color': Colors.blue,
      'screen': const CurrencyConverterScreen(),
    },
    {
      'icon': Icons.access_time,
      'title': 'Time Converter', 
      'color': Colors.green,
      'screen': const TimeConverterScreen(),
    },
    {
      'icon': Icons.location_pin,
      'title': 'Nearby Places',
      'color': Colors.orange,
      'screen': const NearbyPlacesScreen(),
    },
    {
      'icon': Icons.receipt,
      'title': 'Transaction History',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('TourFriend'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan lokasi
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _currentLocation,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _currentTime,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search features...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, 
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),

            const SizedBox(height: 24),

            // Grid Fitur
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                return _FeatureCard(
                  icon: feature['icon'],
                  title: feature['title'],
                  color: feature['color'],
                  onTap: () {
                    if (feature['screen'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => feature['screen'],
                        ),
                      );
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Recent Transactions
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // ... (Tambahkan list transaksi di sini)
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.2), color.withOpacity(0.5)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}