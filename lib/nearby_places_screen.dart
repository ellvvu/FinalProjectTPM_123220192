import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPlacesScreen extends StatelessWidget {
  const NearbyPlacesScreen({super.key});

  Future<void> _openGoogleMaps(BuildContext context) async {
    const url = 'https://www.google.com/maps/search/tourist+attractions+near+me';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Tourist Attractions')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Find Nearby Tourist Attractions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in Google Maps'),
              onPressed: () => _openGoogleMaps(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}