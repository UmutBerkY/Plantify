import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class PlantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> plantData;
  const PlantDetailScreen({super.key, required this.plantData});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late DateTime nextWaterTime;
  late String health;
  late String docId;

  @override
  void initState() {
    super.initState();
    nextWaterTime = (widget.plantData['nextWaterTime'] as Timestamp).toDate();
    final now = DateTime.now();
    health = now.isAfter(nextWaterTime) ? 'Kötü' : (widget.plantData['health'] ?? 'İyi');
    docId = widget.plantData['id'] ?? ''; // Firestore'dan gelen doc id
  }

  Duration get remainingTime => nextWaterTime.difference(DateTime.now());

  Future<void> waterPlant() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || docId.isEmpty) return;

    final plantRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('my_plants')
        .doc(docId);

    final newTime = DateTime.now().add(const Duration(days: 3));

    await plantRef.update({
      'nextWaterTime': Timestamp.fromDate(newTime),
      'health': 'Yenilendi',
    });

    setState(() {
      nextWaterTime = newTime;
      health = 'Yenilendi';
    });

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bitki sulandı!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.plantData['name'];
    final image = widget.plantData['image'];
    final description = widget.plantData['description'];
    final isLate = remainingTime.isNegative;

    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? 'Bitki Detayı'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/images/$image', height: 180),
            const SizedBox(height: 16),
            Text(name ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description ?? '', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text('Sağlık Durumu: $health'),
            const SizedBox(height: 8),
            Text(
              isLate
                  ? '❗ Sulama süresi geçti!'
                  : 'Sulama için kalan süre: ${remainingTime.inHours} saat',
              style: TextStyle(
                color: isLate ? Colors.red : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: waterPlant,
              icon: const Icon(Icons.water_drop),
              label: const Text('Suladım'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
