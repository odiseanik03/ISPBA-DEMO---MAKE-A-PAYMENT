import 'package:flutter/material.dart';

class MakePaymentPage extends StatefulWidget {
  const MakePaymentPage({super.key});

  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _beneficiary = TextEditingController();
  final _destination = TextEditingController();
  final _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Make a payment', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Good morning OLlSEA'),
              const Divider(height: 32),
              TextFormField(controller: _destination, decoration: const InputDecoration(labelText: 'Destination account'), validator: (v)=> (v==null||v.length<10)?'Invalid account':null),
              TextFormField(controller: _beneficiary, decoration: const InputDecoration(labelText: 'Beneficiary name'), validator: (v)=> (v==null||v.isEmpty)?'Required':null),
              TextFormField(controller: _amount, decoration: const InputDecoration(labelText: 'Amount (EUR)'), validator: (v){ final d=double.tryParse(v??''); return (d==null||d<=0)?'Invalid amount':null;}),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A00), foregroundColor: Colors.white),
                onPressed: () { if (_formKey.currentState!.validate()) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment submitted (mock)'))); } },
                child: const Text('Continue'),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
