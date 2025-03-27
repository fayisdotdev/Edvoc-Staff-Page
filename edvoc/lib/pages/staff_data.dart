import 'package:flutter/material.dart';
import 'package:edvoc/services/api_service.dart';
import 'package:edvoc/theme/app_theme.dart';
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
  final int pageSize = 10; // Change this value to set items per page
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchStaff();
  }

  Future<void> fetchStaff({String? url}) async {
    setState(() => isLoading = true);
    try {
      final String apiUrl =
          url ?? "https://edvocacademy.in/common/all-staff?page_size=$pageSize";

      // Extract page number from URL if it exists
      if (url != null) {
        final uri = Uri.parse(url);
        currentPage = int.tryParse(uri.queryParameters['page'] ?? '1') ?? 1;
      } else {
        currentPage = 1;
      }

      final data = await apiService.fetchStaffData(apiUrl);

      setState(() {
        staffList =
            (data['results'] as List).map((e) => Staff.fromJson(e)).toList();
        nextPageUrl = data['next'];
        previousPageUrl = data['previous'];
        totalCount = data['count'] ?? 0;
      });
    } catch (e) {
      print("Error fetching staff data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Data')),
      body: Container(
        color: AppTheme.background,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'Total Staff: $totalCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isLoading)
                const LinearProgressIndicator()
              else
                const SizedBox(height: 4),
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: AppTheme.surface,
                        dividerColor: Colors.grey[300],
                      ),
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 12,
                        headingRowHeight: 50,
                        dataRowHeight: 65,
                        headingRowColor: MaterialStateProperty.all(
                          theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Profile',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Role',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Mobile',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows:
                            staffList
                                .map(
                                  (staff) => DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                      Color?
                                    >((Set<MaterialState> states) {
                                      return staffList.indexOf(staff) % 2 == 0
                                          ? Colors.grey[50]
                                          : Colors.white;
                                    }),
                                    cells: [
                                      DataCell(Text(staff.id.toString())),
                                      DataCell(
                                        CircleAvatar(
                                          backgroundColor: Colors.grey[100],
                                          radius: 20,
                                          child:
                                              staff.profilePicture.isNotEmpty &&
                                                      staff.profilePicture !=
                                                          "null"
                                                  ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                    child: Image.network(
                                                      'https://edvocacademy.in${staff.profilePicture}',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Icon(
                                                          Icons.person,
                                                          size: 25,
                                                          color:
                                                              theme
                                                                  .colorScheme
                                                                  .primary,
                                                        );
                                                      },
                                                    ),
                                                  )
                                                  : Icon(
                                                    Icons.person,
                                                    size: 25,
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .primary,
                                                  ),
                                        ),
                                      ),
                                      DataCell(Text(staff.name)),
                                      DataCell(Text(staff.userType)),
                                      DataCell(Text(staff.email)),
                                      DataCell(Text(staff.mobileNumber)),
                                      DataCell(Text(staff.status)),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          previousPageUrl != null
                              ? () => fetchStaff(url: previousPageUrl)
                              : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    Text(
                      'Page $currentPage of ${((totalCount - 1) ~/ pageSize) + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed:
                          nextPageUrl != null
                              ? () => fetchStaff(url: nextPageUrl)
                              : null,
                      label: const Text("Next"),
                      icon: const Icon(Icons.arrow_forward),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
