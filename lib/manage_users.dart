import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'manage_add.dart'; // Import the add user form file
import 'manage_delete.dart'; // Import the delete user manager
import 'manage_edit.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  Future<List<dynamic>>? _usersFuture;
  TextEditingController _searchController = TextEditingController(); // For search input
  bool _isAddingUser = false; // To track if we are in 'add user' mode
  bool _isEditingUser = false; // To track if we are in 'edit user' mode
  final DeleteUserManager _deleteUserManager = DeleteUserManager(); // Initialize DeleteUserManager
  Map<String, dynamic>? _userToEdit; // To hold the user data being edited

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_onSearchChanged); // Listen for changes in search input
  }

  void _fetchUsers([String searchQuery = '']) {
    setState(() {
      _usersFuture = Supabase.instance.client
          .from('user')
          .select()
          .like('name', '%$searchQuery%'); // Filter by search query
    });
  }

  void _onSearchChanged() {
    _fetchUsers(_searchController.text); // Update user list based on search input
  }

  void _toggleAddUser() {
    setState(() {
      _isAddingUser = !_isAddingUser; // Toggle between listing users and adding a user
      _isEditingUser = false; // Ensure we're not in edit mode when adding a user
    });
  }

  void _toggleEditUser(Map<String, dynamic> user) {
    setState(() {
      _userToEdit = user; // Set the user to be edited
      _isEditingUser = !_isEditingUser; // Toggle between listing users and editing a user
      _isAddingUser = false; // Ensure we're not in add mode when editing a user
    });
  }

  Future<void> _addUser(Map<String, String> userData) async {
    final response = await Supabase.instance.client
        .from('user')
        .insert(userData);

    if (response.error == null) {
      _fetchUsers(); // Refresh the user data
      setState(() {
        _isAddingUser = false; // Go back to user list view after adding a user
      });
    } else {
      print('Error adding user: ${response.error?.message}');
    }
  }

  Future<void> _editUser(Map<String, dynamic> userData) async {
    final response = await Supabase.instance.client
        .from('user')
        .update(userData)
        .eq('id', userData['id']);

    if (response.error == null) {
      _fetchUsers(); // Refresh the user data
      setState(() {
        _isEditingUser = false; // Go back to user list view after editing a user
      });
    } else {
      print('Error editing user: ${response.error?.message}');
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: _isAddingUser
          ? AddUserForm(
              formKey: GlobalKey<FormState>(),
              onAddUser: _addUser,
              onCancel: _toggleAddUser,
            )
          : _isEditingUser && _userToEdit != null
              ? ManageEditUser(
                  user: _userToEdit!,
                  formKey: GlobalKey<FormState>(),
                  onEditUser: _editUser,
                  onCancel: () {
                    setState(() {
                      _isEditingUser = false; // Go back to user list view
                    });
                  },
                )
              : _buildUserTable(),
    );
  }

  // User Table Widget with Search
  Widget _buildUserTable() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('NEW'),
                onPressed: _toggleAddUser,
              ),
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Account Name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // Fixed header
              Container(
                color: Colors.blueGrey.shade50,
                child: DataTable(
                  columnSpacing: 230.0,
                  headingRowHeight: 40.0,
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  dataTextStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  border: TableBorder.all(color: Colors.blueGrey.shade50),
                  columns: const [
                    DataColumn(label: Text('Account Name')),
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: [], // Empty rows to display the fixed header only
                ),
              ),
              // Scrollable data
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _usersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    }

                    final users = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 194.0,
                        dataRowHeight: 40.0,
                        headingRowHeight: 0, // Hide header row in the data table
                        headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        dataTextStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columns: const [
                          DataColumn(label: Text('Account Name')),
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: users.map<DataRow>((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user['name'] ?? 'No name')),
                              DataCell(Text(user['username'] ?? 'No username')),
                              DataCell(Text(user['role'] ?? 'No role')),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _toggleEditUser(user); // Open edit form
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteUserManager.showDeleteConfirmation(
                                        context,
                                        user['id'] as int,
                                        () {
                                          setState(() {
                                            _fetchUsers(); // Refresh the user list after deletion
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
