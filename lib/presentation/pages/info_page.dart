import "package:flutter/material.dart";

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Информационная страница"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildStatCard(
            icon: Icons.receipt,
            title: 'Всего чеков',
            value: '751',
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          _buildStatCard(
            icon: Icons.receipt,
            title: 'Всего чеков2',
            value: '751',
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.star),
              Text('Рейтинг: 4.8'),
              ElevatedButton(onPressed: () {}, child: Text('Купить')),
            ],
          ),
          Stack(
            // Выравнивание элементов в стопке (по умолчанию - top-left)
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(height: 200, width: 200, color: Colors.blue), // Фон
              Positioned( // Виджет Positioned позволяет точно позиционировать элемент внутри Stack
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(4),
                  color: Colors.deepOrangeAccent,
                  child: Text('New', style: TextStyle(color: Colors.white)),
                ),
              ),
              Text('Текст поверх изображения'),
            ],
          )
        ],),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
