import 'package:flutter/material.dart';

class ManageEditUser extends StatelessWidget {
  final Map<String, dynamic> user;
  final GlobalKey<FormState> formKey;
  final Future<void> Function(Map<String, dynamic>) onEditUser;
  final VoidCallback onCancel;

  ManageEditUser({
    required this.user,
    required this.formKey,
    required this.onEditUser,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: user['name']);
    final TextEditingController usernameController =
        TextEditingController(text: user['username']);
    final TextEditingController roleController =
        TextEditingController(text: user['role']);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Container(
          width: 600.0, // Fixed width to match the add user form
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit User', // Title text
                style: TextStyle(
                  fontSize: 24.0, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center, // Center align the title
              ),
              SizedBox(height: 20), // Spacing between title and form
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFormField(
                      'Name:',
                      nameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12), // Spacing between fields
                    _buildFormField(
                      'Username:',
                      usernameController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12), // Spacing between fields
                    _buildFormField(
                      'Role:',
                      roleController,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a role';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              await onEditUser({
                                'id': user['id'],
                                'name': nameController.text,
                                'username': usernameController.text,
                                'role': roleController.text,
                              });
                            }
                          },
                          child: Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: Size(80, 36), // Small size
                            padding: EdgeInsets.symmetric(horizontal: 12.0), // Padding inside the button
                          ),
                        ),
                        SizedBox(width: 8), // Spacing between buttons
                        ElevatedButton(
                          onPressed: onCancel,
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white, // Set button color to red
                            minimumSize: Size(80, 36), // Small size
                            padding: EdgeInsets.symmetric(horizontal: 12.0), // Padding inside the button
                          ),
                        ),
                      ],
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

  // Helper Widget for Form Fields
  Widget _buildFormField(
    String labelText,
    TextEditingController controller,
    String? Function(String?)? validator, {
    bool obscureText = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100.0, // Fixed width for label
          child: Text(
            labelText,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 12), // Spacing between label and input field
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(), // Box border for the input field
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding inside the box
            ),
            obscureText: obscureText,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
