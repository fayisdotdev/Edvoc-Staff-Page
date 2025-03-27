import 'package:flutter/material.dart';
import 'package:edvoc/services/api_service.dart';
import 'staff_model.dart';

class StaffDataPage extends StatefulWidget {
  const StaffDataPage({super.key});

  @override
  _StaffDataPageState createState() => _StaffDataPageState();
}

class _StaffDataPageState extends State<StaffDataPage> {
  final ApiService apiService = ApiService();
  List<Staff> staffList = [];
  String? nextPageUrl;
  String? previousPageUrl;
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    fetchStaff();
  }

  Future<void> fetchStaff({String? url}) async {
    try {
      final data = await apiService.fetchStaffData(url);
      setState(() {
        staffList =
            (data['results'] as List).map((e) => Staff.fromJson(e)).toList();
        nextPageUrl = data['next'];
        previousPageUrl = data['previous'];
        totalCount = data['count'] ?? 0;
      });
    } catch (e) {
      print("Error fetching staff data: $e");
    }
  }

  String _getIdRange() {
    if (staffList.isEmpty) return '';
    int firstId = staffList.first.id;
    int lastId = staffList.last.id;
    return '$firstId - $lastId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Data'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _getIdRange(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final staff = staffList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://edvocacademy.in${staff.profilePicture}',
                      ),
                      onBackgroundImageError: (_, __) {},
                    ),
                    title: Text(staff.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Role: ${staff.userType}'),
                        Text('Email: ${staff.email}'),
                        Text('Status: ${staff.status}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed:
                    previousPageUrl != null
                        ? () => fetchStaff(url: previousPageUrl)
                        : null,
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed:
                    nextPageUrl != null
                        ? () => fetchStaff(url: nextPageUrl)
                        : null,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
