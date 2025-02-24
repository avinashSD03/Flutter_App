import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final slabController = TextEditingController(text: "1");
  int? groupVal = 1;
  var result = "";
  var slabResult = "";
  final numFormat =
      NumberFormat.currency(locale: "en_IN", symbol: "₹", decimalDigits: 5);

  void calculateAmount() {
    double? amt = double.tryParse(amountController.text);
    double? slab = double.tryParse(slabController.text);
    int? group = groupVal;
    if (amt == null || group == null) {
      return;
    }

    double ans = 0;

    if (group == 1) {
      if (amt <= 1250) {
        ans = amt * 0.0067;
      } else if (amt > 1250 && amt <= 1250 + 750) {
        ans = (amt - 1250) * 0.0055 + 1250 * 0.0067;
      } else if (amt > 1250 + 750 && amt <= 1250 + 750 + 130) {
        ans = (amt - 1250 - 750) * 0.0033 + 750 * 0.0055 + 1250 * 0.0067;
      } else {
        ans =
            (amt - 2130) * 0.0023 + 130 * 0.0033 + 750 * 0.0055 + 1250 * 0.0067;
      }
    } else if(group==2){
      if (amt <= 2400) {
        ans = amt * 0.0035;
      } else if (amt > 2400 && amt <= 2400 + 1450) {
        ans = (amt - 2400) * 0.0029 + 2400 * 0.0035;
      } else {
        ans = (amt - 3850) * 0.0023 + 1450 * 0.0029 + 2400 * 0.0035;
      }
    }else if(group==3){
        ans = amt * 0.0023;
    }else if(group==4){
        ans = amt * 0.0018;
    }else if(group==5){
        ans = amt * 0.0015;
    }else if(group==6){
        ans = amt * 0.0010;
    }else if(group==7){
        ans = amt * 0.0008;
    }else if(group==8){
        ans = amt * 0.0006;
    }

    setState(() {
      result = numFormat.format(ans);
      slabResult = numFormat.format(ans * slab!);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Calc"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount', style: Theme.of(context).textTheme.bodyLarge),
              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Enter Valid Input';
                  }
                  return null;
                },
                onChanged: (String value) {
                  calculateAmount();
                },
              ),
              const SizedBox(height: 20.0),
              Text('Slab', style: Theme.of(context).textTheme.bodyLarge),
              TextFormField(
                controller: slabController,

                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Enter Slab',
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Enter Valid Input';
                  }
                  return null;
                },
                onChanged: (String value) {
                  calculateAmount();
                },
              ),
              const SizedBox(height: 20.0),
              Text('Group', style: Theme.of(context).textTheme.bodyLarge),

              Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(
                  8,
                  (int index) {
                    return ChoiceChip(
                      label: Text('Group ${index + 1}'),
                      selected: groupVal == index+1,
                      onSelected: (bool selected) {
                        setState(() {
                          groupVal = selected ? index + 1 : null;
                        });
                        calculateAmount();
                      },
                    );
                  },
                ).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: calculateAmount,
                  child: const Text('Submit'),
                ),
              ),
              const Text("DR per Slab: ",
                  style: TextStyle(fontSize: 18, letterSpacing: 0.8)),
              Text(
                result,
                style: const TextStyle(fontSize: 20, letterSpacing: 1.2),
              ),
              const SizedBox(height: 10.0),
              const Text("DR payable: ",
                  style: TextStyle(fontSize: 18, letterSpacing: 0.8)),
              Text(
                slabResult,
                style: const TextStyle(fontSize: 20, letterSpacing: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
