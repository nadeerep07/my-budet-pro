import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/expense_entity.dart';

class ExportService {
  static Future<void> exportToCsv(List<ExpenseEntity> expenses) async {
    List<List<dynamic>> rows = [];

    rows.add([
      "ID",
      "Date",
      "Category ID",
      "Description",
      "Amount",
      "Account",
      "Is From Savings"
    ]);

    for (var exp in expenses) {
      rows.add([
        exp.id,
        exp.date.toIso8601String(),
        exp.categoryId,
        exp.description,
        exp.amount,
        exp.accountId,
        exp.isFromSavings,
      ]);
    }

    final csvData = ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/mybudgetpro_export_${DateTime.now().millisecondsSinceEpoch}.csv',
    );

    await file.writeAsString(csvData);
  }
}