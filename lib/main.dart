import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart'; // Ensure correct import
import 'building_info.dart'; // Import the file where BuildingInfo is defined
import 'home_screen.dart'; // Import the file where HomeScreen is defined
import 'manage_users.dart'; // Import the file where ManageUserScreen is defined
import 'user_logs.dart'; // Import the file where UserLogsScreen is defined
import 'logout.dart'; // Import the file where LogoutScreen is defined

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iudqzyiastrupvhqsdkt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1ZHF6eWlhc3RydXB2aHFzZGt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM1OTU3MTgsImV4cCI6MjAzOTE3MTcxOH0.LnD6prXLd4EWRf4Xgh3bO524PsSsCpBbqMrnd6Kl_nY',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminPanel(),
      
    );
  }
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  String _selectedRoute = '/'; // Keep this non-nullable

  // Method to return the correct screen based on the route
  Widget _getScreenForRoute(String? route) {
    switch (route ?? '/') { // Provide a default value if route is null
      case '/buildinginfo':
        return BuildingInfo();
      case '/manageuser':
        return ManageUsers();
      case '/userlogs':
        return UserLogs();
      case '/logout':
        return Logout();
      default:
        return Home(); // Default to the Home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: Text('NOCNHS MAP Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
      ),
      sideBar: SideBar(
        selectedRoute: _selectedRoute, // Highlight the selected route
        onSelected: (item) {
          setState(() {
            _selectedRoute = item.route ?? '/'; // Provide a default value if route is null
          });
        },
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: '/',
          ),
          AdminMenuItem(
            title: 'Building Info',
            icon: Icons.business,
            route: '/buildinginfo',
          ),
          AdminMenuItem(
            title: 'Manage User',
            icon: Icons.people,
            route: '/manageuser',
          ),
          AdminMenuItem(
            title: 'User Logs',
            icon: Icons.history,
            route: '/userlogs',
          ),
          AdminMenuItem(
            title: 'Logout',
            icon: Icons.logout,
            route: '/logout',
          ),
        ],
      ),
      body: _getScreenForRoute(_selectedRoute), // Display the correct content based on the selected route
    );
  }
}
