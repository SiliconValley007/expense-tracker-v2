import 'package:flutter/material.dart';

Future showSignOutDialog({
  required BuildContext context,
  required VoidCallback onConfirmPressed,
}) =>
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Sign out',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out of this account?',
          style: TextStyle(
            fontWeight: FontWeight.w400,
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
              'Sign out',
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
