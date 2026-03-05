import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/mileage_entry_entity.dart';
import '../viewmodels/mileage_view_model.dart';
import '../viewmodels/accounts_view_model.dart';

class MileageScreen extends StatefulWidget {
  const MileageScreen({super.key});

  @override
  State<MileageScreen> createState() => _MileageScreenState();
}

class _MileageScreenState extends State<MileageScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final _dateFormat = DateFormat('dd MMM yyyy');

  String _formatAmount(double amount) {
    return _currencyFormat.format(amount).replaceAll('.00', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mileage Tracker',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<MileageViewModel>(
        builder: (context, mileageVM, child) {
          final entries = mileageVM.entries;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVehicleCard(context, mileageVM),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mileage History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showAddEntryBottomSheet(context),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Entry'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (entries.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No mileage entries yet.\nAdd your first fuel fill-up!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = entries[index];
                      return _buildMileageEntryCard(context, mileageVM, entry);
                    }, childCount: entries.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, MileageViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Royal Enfield "Stealth Black" Aesthetic
    final cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFF2C2C2C);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Optional: Add a subtle texture or gradient overlay here
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'CLASSIC 350',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Stealth Black',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Royal Enfield (2020)',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Placeholder (Could use a bike icon if image not available)
                    Icon(
                      Icons.two_wheeler,
                      size: 48,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Analytics Grid
                Row(
                  children: [
                    _buildAnalyticItem(
                      'Avg Mileage',
                      vm.averageMileage.toStringAsFixed(1),
                      'km/l',
                    ),
                    _buildDivider(),
                    _buildAnalyticItem(
                      'Total Dist.',
                      vm.totalDistanceTravelled.toStringAsFixed(0),
                      'km',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildAnalyticItem(
                      'Total Cost',
                      _formatAmount(vm.totalPetrolCost),
                      '',
                    ),
                    _buildDivider(),
                    _buildAnalyticItem(
                      'Cost/KM',
                      _formatAmount(vm.costPerKm),
                      '',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildAnalyticItem(String label, String value, String unit) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMileageEntryCard(
    BuildContext context,
    MileageViewModel vm,
    MileageEntryEntity entry,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        vm.deleteEntry(entry.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_gas_station,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dateFormat.format(entry.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (entry.odometerReading > 0)
                          Text(
                            'Odo: ${entry.odometerReading.toStringAsFixed(0)} km',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatAmount(entry.totalCost),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '${entry.petrolLitres.toStringAsFixed(1)} L @ ${_formatAmount(entry.pricePerLitre)}/L',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if ((entry.distanceTravelled ?? 0) > 0 ||
                (entry.mileage ?? 0) > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStat(
                      'Distance',
                      '${entry.distanceTravelled?.toStringAsFixed(0)} km',
                    ),
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    _buildMiniStat(
                      'Mileage',
                      '${entry.mileage?.toStringAsFixed(1)} km/l',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showAddEntryBottomSheet(
    BuildContext context, {
    MileageEntryEntity? entryToEdit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MileageEntryForm(
        entryToEdit: entryToEdit,
        onSubmit: (entry) {
          final vm = context.read<MileageViewModel>();
          if (entryToEdit == null) {
            vm.addEntry(entry);
          } else {
            vm.updateEntry(entry);
          }
        },
      ),
    );
  }
}

class _MileageEntryForm extends StatefulWidget {
  final MileageEntryEntity? entryToEdit;
  final Function(MileageEntryEntity) onSubmit;

  const _MileageEntryForm({this.entryToEdit, required this.onSubmit});

  @override
  State<_MileageEntryForm> createState() => _MileageEntryFormState();
}

class _MileageEntryFormState extends State<_MileageEntryForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TextEditingController _odometerController;
  late TextEditingController _petrolLitresController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;
  String? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.entryToEdit?.date ?? DateTime.now();
    _odometerController = TextEditingController(
      text: widget.entryToEdit?.odometerReading.toString() ?? '',
    );
    _petrolLitresController = TextEditingController(
      text: widget.entryToEdit?.petrolLitres.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.entryToEdit?.pricePerLitre.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.entryToEdit?.notes ?? '',
    );
    _selectedAccountId = widget.entryToEdit?.paymentMethodId;
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _petrolLitresController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double _calculateTotalCost() {
    final litres = double.tryParse(_petrolLitresController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    return litres * price;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    //final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomInset > 0
            ? bottomInset + 16
            : MediaQuery.of(context).padding.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.entryToEdit == null
                    ? 'Add Fuel Fill-up'
                    : 'Edit Fuel Fill-up',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Odometer & Date
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _odometerController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Odometer (km)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.speed),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Required';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                DateFormat('dd MMM').format(_selectedDate),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Litres & Price
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _petrolLitresController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Fuel (Litres)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Price/L (₹)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Auto Calculated Cost
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Expense',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '₹${_calculateTotalCost().toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Account Selection
                    Consumer<AccountsViewModel>(
                      builder: (context, accountsVM, child) {
                        final accounts = accountsVM.accounts;
                        if (accounts.isEmpty) {
                          return const Text("No accounts available");
                        }
                        return DropdownButtonFormField<String>(
                          initialValue: _selectedAccountId ?? accounts.first.id,
                          decoration: InputDecoration(
                            labelText: 'Payment Method',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.account_balance_wallet,
                            ),
                          ),
                          items: accounts.map((account) {
                            return DropdownMenuItem(
                              value: account.id,
                              child: Text(account.name),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedAccountId = val),
                          validator: (val) => val == null ? 'Required' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        final accountId =
                            _selectedAccountId ??
                            context.read<AccountsViewModel>().accounts.first.id;
                        final totalCost = _calculateTotalCost();

                        final entry = MileageEntryEntity(
                          id:
                              widget.entryToEdit?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          date: _selectedDate,
                          odometerReading: double.parse(
                            _odometerController.text,
                          ),
                          petrolLitres: double.parse(
                            _petrolLitresController.text,
                          ),
                          pricePerLitre: double.parse(_priceController.text),
                          totalCost: totalCost,
                          paymentMethodId: accountId,
                          notes: _notesController.text,
                          linkedExpenseId: widget.entryToEdit?.linkedExpenseId,
                        );

                        widget.onSubmit(entry);
                        Navigator.pop(context);
                      },
                      child: Text(
                        widget.entryToEdit == null
                            ? 'Add Fuel Entry'
                            : 'Save Changes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
