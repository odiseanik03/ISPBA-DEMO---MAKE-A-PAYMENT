import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: const [
          ListTile(title: Text('Current account'), subtitle: Text('**** **** **** 3000'), trailing: Text('€5,000.00')),
        ],
      ),
    );
  }
}
