import 'package:flutter/material.dart';
import 'data/payments_api.dart';

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
  final _description = TextEditingController();
  DateTime? _executionDate;
  bool _invoiceMode = false;

  bool get _isValid =>
      _beneficiary.text.trim().isNotEmpty &&
      _destination.text.trim().length >= 10 &&
      (double.tryParse(_amount.text) ?? 0) > 0 &&
      _executionDate != null;


  @override
  void initState() {
    super.initState();
    _executionDate = DateTime.now();
  }

  @override
  void dispose() {
    _beneficiary.dispose();
    _destination.dispose();
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 800;
        return SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Payments > New payment', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(children: const [
              Text('Make a payment', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.help_outline, size: 18, color: Colors.black54),
              Spacer(),
              Chip(label: Text('Step 1/3')),
            ]),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  onChanged: () => setState(() {}),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Good morning OLISEA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Fill in the fields below to send a secure payment.', style: TextStyle(color: Colors.black54)),
                        ]),
                      ),
                      CircleAvatar(
                        backgroundColor: const Color(0xFFFF7A00),
                        child: IconButton(onPressed: () {}, icon: const Icon(Icons.close, color: Colors.white)),
                      )
                    ]),
                    const Divider(height: 28),
                    const Text('From', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: 'Current account • ****3000',
                      items: const [
                        DropdownMenuItem(value: 'Current account • ****3000', child: Text('Current account • ****3000'))
                      ],
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 16),
                    const Text('To', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _destination,
                      decoration: const InputDecoration(labelText: 'Destination account number'),
                      validator: (v) => (v == null || v.length < 10) ? 'Invalid account format' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _beneficiary,
                      decoration: const InputDecoration(labelText: 'Beneficiary name'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const Divider(height: 28),
                    const Text('Payment', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    mobile
                        ? Column(children: [_amountField(), const SizedBox(height: 8), _currencyField()])
                        : Row(children: [Expanded(child: _amountField()), const SizedBox(width: 8), _currencyField()]),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Invoice/Fiscal option'),
                      value: _invoiceMode,
                      onChanged: (v) => setState(() => _invoiceMode = v),
                    ),
                    TextFormField(controller: _description, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialDate: DateTime.now(),
                        );
                        if (selected != null) setState(() => _executionDate = selected);
                      },
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(_executionDate == null ? 'Select execution date' : _executionDate.toString().split(' ').first),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValid ? const Color(0xFFFF7A00) : Colors.grey,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: !_isValid
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final payload = {
                                    'sourceAccountId': 1,
                                    'destinationAccountNumber': _destination.text.trim(),
                                    'beneficiaryName': _beneficiary.text.trim(),
                                    'amount': double.parse(_amount.text),
                                    'currency': 'EUR',
                                    'description': _description.text.trim(),
                                    'executionDate': _executionDate!.toIso8601String().split('T').first,
                                  };
                                  try {
                                    final result = await PaymentsApi().createPayment(payload);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Payment created: ${result['transactionReference']}')),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to submit payment: $e')),
                                    );
                                  }
                                }
                              },
                        child: const Text('Continue'),
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ]),
        );
      },
    );
  }

  Widget _amountField() => TextFormField(
        controller: _amount,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Amount'),
        validator: (v) {
          final d = double.tryParse(v ?? '');
          return (d == null || d <= 0) ? 'Invalid amount' : null;
        },
      );

  Widget _currencyField() => SizedBox(
        width: 120,
        child: DropdownButtonFormField<String>(
          value: 'EUR',
          items: const [
            DropdownMenuItem(value: 'EUR', child: Text('EUR')),
            DropdownMenuItem(value: 'USD', child: Text('USD')),
          ],
          onChanged: (_) {},
        ),
      );
}
