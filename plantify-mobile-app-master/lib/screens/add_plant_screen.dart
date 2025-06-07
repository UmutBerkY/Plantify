import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlantScreen extends StatelessWidget {
  const AddPlantScreen({super.key});

  final List<Map<String, String>> plants = const [
    {
      'name': 'Zambak',
      'image': 'zambak.png',
      'description': 'Zambak, parlak ve büyük çiçekleriyle tanınır. Güneşi sever ve düzenli sulanmalıdır.'
    },
    {
      'name': 'Aloe Vera',
      'image': 'aloevera.png',
      'description': 'Aloe Vera tıbbi özellikleri ile bilinir. Az su ister ve direkt güneş ışığını sever.'
    },
    {
      'name': 'Menekşe',
      'image': 'menekse.png',
      'description': 'Menekşe, iç mekanlarda sıkça yetiştirilir. Işık alan ancak direkt güneş almayan yerlerde yetiştirilmelidir.'
    },
    {
      'name': 'Gül',
      'image': 'gul.png',
      'description': 'Gül, hoş kokulu çiçekleriyle bilinir. Güneşi sever ve düzenli sulama ister.'
    },
    {
      'name': 'Süsen',
      'image': 'susen.png',
      'description': 'Süsen, rengarenk çiçekleriyle dikkat çeker. Ilık iklimleri sever.'
    },
    {
      'name': 'Orkide',
      'image': 'orkide.png',
      'description': 'Orkide, narin yapısıyla iç mekan süs bitkisidir. Az su ve dolaylı ışık ister.'
    },
    {
      'name': 'Papatya',
      'image': 'papatya.png',
      'description': 'Papatya, doğal alanlarda sık görülür. Güneşli ortamları sever.'
    },
    {
      'name': 'Kaktüs',
      'image': 'kaktus.png',
      'description': 'Kaktüs, susuzluğa dayanıklıdır. Sıcak ve kuru ortamlar için idealdir.'
    },
    {
      'name': 'Lavanta',
      'image': 'lavanta.png',
      'description': 'Lavanta, hoş kokusu ile bilinir. Güneşli ortamları sever ve az su ister.'
    },
    {
      'name': 'Begonya',
      'image': 'begonya.png',
      'description': 'Begonya, renkli yapraklara sahiptir. Yarı gölge ortamları tercih eder.'
    },
    {
      'name': 'Fesleğen',
      'image': 'feslegen.png',
      'description': 'Fesleğen, hoş kokulu yapraklara sahiptir. Mutfağınızda yetiştirmek için idealdir.'
    },
    {
      'name': 'Sardunya',
      'image': 'sardunya.png',
      'description': 'Sardunya, dayanıklı ve uzun ömürlüdür. Direkt güneş ışığını sever.'
    },
    {
      'name': 'Yasemin',
      'image': 'yasemin.png',
      'description': 'Yasemin, yoğun kokulu çiçekleriyle tanınır. Sıcak iklimi sever.'
    },
    {
      'name': 'Şebboy',
      'image': 'sebboy.png',
      'description': 'Şebboy, bahar aylarında açar. Ilıman iklimlerde kolay yetişir.'
    },
    {
      'name': 'Kasımpatı',
      'image': 'kasimpati.png',
      'description': 'Kasımpatı, sonbaharda açan çiçekleriyle bilinir. Güneşli ve serin ortamları sever.'
    },
  ];

  Future<void> addPlantToMyPlants(Map<String, String> plant) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userPlantRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('my_plants')
        .doc(plant['name']);

    await userPlantRef.set({
      'name': plant['name'],
      'description': plant['description'],
      'image': plant['image'],
      'health': 'Good',
      'addedAt': Timestamp.now(),
      'nextWaterTime': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitki Ekle'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/${plant['image']}', height: 150),
                  const SizedBox(height: 8),
                  Text(
                    plant['name']!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(plant['description']!),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await addPlantToMyPlants(plant);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${plant['name']} eklendi!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Bitkiyi Ekle'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
