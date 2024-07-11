import 'package:flutter/material.dart';
import '../controller/firebase_service.dart';

void showDeleteConfirmationDialog(BuildContext context, String id, String title) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete the todo "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteTodoById(id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
