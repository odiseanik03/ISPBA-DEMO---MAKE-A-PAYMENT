import 'package:flutter/material.dart';
import 'data/accounts_api.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AccountsApi().fetchAccounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load accounts: ${snapshot.error}'));
        }
        final accounts = snapshot.data ?? [];
        return Card(
          child: ListView(
            children: accounts
                .map(
                  (a) => ListTile(
                    title: Text(a.accountType),
                    subtitle: Text(a.maskedAccountNumber),
                    trailing: Text('${a.currency} ${a.availableBalance.toStringAsFixed(2)}'),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
