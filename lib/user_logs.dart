import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';  // Import this package for formatting dates

class UserLogs extends StatefulWidget {
  @override
  _UserLogsState createState() => _UserLogsState();
}

class _UserLogsState extends State<UserLogs> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserLogs();
  }

  Future<void> _fetchUserLogs() async {
    try {
      // Fetch all logs and order by login_time in descending order
      final response = await _supabaseClient
          .from('user_logs')
          .select()
          .order('login_time', ascending: false);

      if (response != null && response is List) {
        setState(() {
          _logs = List<Map<String, dynamic>>.from(response);  // Convert response to list of maps
          _isLoading = false;
        });
      } else {
        print('No data found');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user logs: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Convert UTC time to local time and format it
String _formatDateTime(String dateTimeStr) {
  try {
    DateTime utcTime = DateTime.parse(dateTimeStr).toUtc();  // Parse as UTC time
    DateTime localTime = utcTime.toLocal();  // Convert to local time
    return DateFormat('MM/dd/yyyy h:mm a').format(localTime);  // Format in MM/DD/YYYY 12-hour format with AM/PM
  } catch (e) {
    return 'Invalid Date';  // Handle errors in case the date format is invalid
  }
}



  TableRow _buildTableRow(Map<String, dynamic> log) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(log['username'] ?? 'Unknown'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_formatDateTime(log['login_time'] ?? 'N/A')),  // Format login time
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_formatDateTime(log['logout_time'] ?? 'N/A')),  // Format logout time
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Activity Logs'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Table(
                    border: TableBorder.all(color: const Color.fromARGB(255, 218, 218, 218)),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Username',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Login Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Logout Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      ..._logs.map(_buildTableRow).toList(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
