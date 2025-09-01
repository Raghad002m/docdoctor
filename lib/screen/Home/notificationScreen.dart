import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'group': 'Today',
      'items': [
        {
          'title': 'Appointment Confirmed',
          'description': 'Your appointment with Dr. Hala is confirmed.',
          'time': '10:30 AM',
          'icon': Icons.calendar_today,
          'isNew': true,
        },
        {
          'title': 'Video Call Scheduled',
          'description': 'Call with Dr. Youssef at 3:00 PM.',
          'time': '9:15 AM',
          'icon': Icons.video_call,
          'isNew': false,
        },
      ],
    },
    {
      'group': 'Yesterday',
      'items': [
        {
          'title': 'Prescription Ready',
          'description': 'Your prescription from Dr. Mona is available.',
          'time': '4:45 PM',
          'icon': Icons.medication,
          'isNew': false,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          title:
          Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, groupIndex) {
          final group = notifications[groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(group['group'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
              ),
              ...List.generate(group['items'].length, (itemIndex) {
                final item = group['items'][itemIndex];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['isNew'] ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Icon(item['icon'], color: Colors.blue, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(item['description'], style: TextStyle(color: Colors.grey.shade700)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item['time'], style: TextStyle(fontSize: 12, color: Colors.grey)),
                          if (item['isNew'])
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                              child: Text('New', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}