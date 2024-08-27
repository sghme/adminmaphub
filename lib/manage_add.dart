import 'package:flutter/material.dart';

// Add User Form Widget
class AddUserForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function(Map<String, String>) onAddUser;
  final VoidCallback onCancel;

  const AddUserForm({
    Key? key,
    required this.formKey,
    required this.onAddUser,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _name, _username, _role, _password;

    return Center(
      child: Container(
        width: 600.0, // Fixed width to make the form not too wide
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New User', // Title text
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
                  _buildFormField('Name:', (value) {
                    _name = value;
                  }, (value) {
                    return value!.isEmpty ? 'Please enter a name' : null;
                  }),
                  SizedBox(height: 12), // Spacing between fields
                  _buildFormField('Username:', (value) {
                    _username = value;
                  }, (value) {
                    return value!.isEmpty ? 'Please enter a username' : null;
                  }),
                  SizedBox(height: 12), // Spacing between fields
                  _buildFormField('Role:', (value) {
                    _role = value;
                  }, (value) {
                    return value!.isEmpty ? 'Please enter a role' : null;
                  }),
                  SizedBox(height: 12), // Spacing between fields
                  _buildFormField('Password:', (value) {
                    _password = value;
                  }, (value) {
                    return value!.isEmpty ? 'Please enter a password' : null;
                  }, obscureText: true),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            onAddUser({
                              'name': _name!,
                              'username': _username!,
                              'role': _role!,
                              'password': _password!, // Store password securely in real apps
                            });
                          }
                        },
                        child: Text('Add User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, 
                          foregroundColor: Colors.white,
                          minimumSize: Size(80, 36), // Small size
                          padding: EdgeInsets.symmetric(horizontal: 12.0), // Padding inside the button
                        ),
                      ),
                      SizedBox(width: 8), // Spacing between buttons
                      ElevatedButton(
                        onPressed: onCancel, // Go back to user list
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, 
                          foregroundColor: Colors.white,// Set button color to red
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
    );
  }

  // Helper Widget for Form Fields
  Widget _buildFormField(
    String labelText,
    void Function(String?)? onSaved,
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
            decoration: InputDecoration(
              border: OutlineInputBorder(), // Box border for the input field
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding inside the box
            ),
            obscureText: obscureText,
            onSaved: onSaved,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
