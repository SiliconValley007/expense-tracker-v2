import 'package:flutter/material.dart';

Future showTransactionDeleteDialog({
  required BuildContext context,
  required bool isExpense,
  required VoidCallback onConfirmPressed,
}) =>
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isExpense ? 'Delete Expense' : 'Delete Income',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this transaction?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: onConfirmPressed,
            child: const Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
