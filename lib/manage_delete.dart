import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteUserManager {
  Future<void> deleteUser(BuildContext context, int userId, VoidCallback onSuccess) async {
    print("Attempting to delete user with ID: $userId");

    final response = await Supabase.instance.client
        .from('user')
        .delete()
        .eq('id', userId); // Ensure userId is treated as an integer

    if (response.error == null) {
      print('User deleted successfully');
      onSuccess(); // Invoke callback to refresh the UI
    } else {
      print('Error deleting user: ${response.error?.message}');
    }
  }

  void showDeleteConfirmation(BuildContext context, int userId, VoidCallback onSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(context, userId, onSuccess); // Pass the callback function
              },
            ),
          ],
        );
      },
    );
  }
}
