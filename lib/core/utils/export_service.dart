import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/expense_entity.dart';

class ExportService {
  static Future<bool> exportToCsv(List<ExpenseEntity> expenses) async {
    List<List<dynamic>> rows = [];

    rows.add([
      "ID",
      "Date",
      "Category ID",
      "Description",
      "Amount",
      "Account",
      "Is From Savings",
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

    try {
      final csvData = const ListToCsvConverter().convert(rows);

      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/mybudgetpro_export_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(filePath);

      await file.writeAsString(csvData);

      // Trigger the share sheet
      final result = await Share.shareXFiles([
        XFile(filePath),
      ], text: 'Expenses CSV Export from MyBudgetPro');

      return result.status == ShareResultStatus.success ||
          result.status == ShareResultStatus.dismissed;
    } catch (e) {
      return false; // Error occurred
    }
  }
}
