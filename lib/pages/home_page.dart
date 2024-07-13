import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'db_helper.dart'; // Import the database helper

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> transactions = [];
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    DBHelper dbHelper = DBHelper();
    transactions = await dbHelper.getTransactions();
    calculateTotals();
    setState(() {});
  }

  void calculateTotals() {
    totalIncome = 0;
    totalExpense = 0;
    for (var transaction in transactions) {
      if (transaction['isExpense'] == 1) {
        totalExpense += transaction['amount'];
      } else {
        totalIncome += transaction['amount'];
      }
    }
  }

  Future<void> deleteTransaction(int id) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.deleteTransaction(id);
    fetchTransactions();
  }

  String formatAmount(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Icon(Icons.download, color: Colors.green),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rp. ${formatAmount(totalIncome)}',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(Icons.upload, color: Colors.red),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expense",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rp. ${formatAmount(totalExpense)}',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),

            // Text "Transaction"
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Transaction',
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // List transactions
            ...transactions.map((transaction) {
              bool isExpense = transaction['isExpense'] == 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    title: Text('Rp. ${formatAmount(transaction['amount'])}'),
                    subtitle: Text(transaction['name']),
                    leading: Container(
                      child: Icon(isExpense ? Icons.upload : Icons.download,
                          color: isExpense ? Colors.red : Colors.green),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteTransaction(transaction['id']);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
