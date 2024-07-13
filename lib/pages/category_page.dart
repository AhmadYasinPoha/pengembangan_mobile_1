import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'db_helper.dart'; // Import the database helper

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void openDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  Text(
                    (isExpense) ? 'Add Expense' : "Add Income",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: (isExpense) ? Colors.red : Colors.green),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Name'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Amount'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () async {
                        // Save transaction to database
                        String name = nameController.text;
                        double amount = double.parse(amountController.text);
                        Map<String, dynamic> transaction = {
                          'name': name,
                          'amount': amount,
                          'isExpense': isExpense ? 1 : 0
                        };
                        DBHelper dbHelper = DBHelper();
                        await dbHelper.addTransaction(transaction);
                        Navigator.of(context).pop();
                      },
                      child: Text('Save'))
                ],
              )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: isExpense,
                onChanged: (bool value) {
                  setState(() {
                    isExpense = value;
                  });
                },
                inactiveTrackColor: Colors.green[200],
                inactiveThumbColor: Colors.green,
                activeColor: Colors.red,
              ),
              IconButton(
                  onPressed: () {
                    openDialog();
                  },
                  icon: Icon(Icons.add))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 10,
            child: ListTile(
              leading: (isExpense)
                  ? Icon(Icons.upload, color: Colors.red)
                  : Icon(Icons.download, color: Colors.green),
              title: Text('Shopping'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 10,
            child: ListTile(
              leading: (isExpense)
                  ? Icon(Icons.upload, color: Colors.red)
                  : Icon(Icons.download, color: Colors.green),
              title: Text('Paket Data'),
            ),
          ),
        )
      ],
    ));
  }
}
