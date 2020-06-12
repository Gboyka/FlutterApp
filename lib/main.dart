import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Interest Calculator',
    home: HomeScreen(),
    theme: ThemeData(
      primaryColor: Colors.deepOrange, // app bar and notification bar
      accentColor: Colors.redAccent, // over scroll
      brightness: Brightness.light,
    ),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IFormState();
  }
}

class _IFormState extends State<HomeScreen> {
  var _currencies = ['Rupees', 'Dollar', 'Pounds'];
  var _currentCurrency = 'Rupees';

  var _formKey = GlobalKey<FormState>(); //different FormState not _FormState
  // This _formKEy will be used to identify
  //our form widget uniquely globally

  void initState() {
    super.initState();
    _currentCurrency = _currencies[0]; //since we can only instantiate static
  } // members, therefore we use initState
  // function,to initialize default drop
  // down menu item.

  //input controllers
  TextEditingController principal = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController term = TextEditingController();

  var displayResult = "Result Will be shown here";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title; //nearest theme

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Interest Calculator'),
        ),
        body: Form(
          //instead of using Container use
          key: _formKey, //form to apply validation layer
          child: Padding(
              padding: EdgeInsets.all(3.0),
              child: ListView(
                //To make screen Scrollable for small screen size
                // List view in place of column
                children: <Widget>[
                  getImage(),
                  Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                      child: TextFormField(
                        //use TextForm instead of TextField
                        style: textStyle,
                        // for validation
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Value";
                          } else if (double.parse(value) < 1)
                            return 'Enter Valid amount ';
                          else
                            return null;
                        },
                        controller: principal,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15.0,
                            ),
                            labelText: 'Principal',
                            hintText: 'Enter Principal Amount',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: rate,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Enter Value";
                          else if (double.parse(value) > 100 ||
                              double.parse(value) < 1)
                            return 'Enter Valid rate ';
                          else
                            return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15.0,
                            ),
                            labelText: 'Rate of Interest',
                            hintText: 'Enter Rate in %ge',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextFormField(
                            style: textStyle,
                            controller: term,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Enter Value";
                              else if (double.parse(value) < 1)
                                return 'Enter Valid time ';
                              else
                                return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 15.0,
                                ),
                                labelText: 'Term',
                                labelStyle: textStyle,
                                hintText: 'Time in Years',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                          Container(width: 8.0),
                          Expanded(
                              child: DropdownButton<String>(
                            iconSize: 34,
                            icon: Icon(Icons.arrow_drop_down),
                            elevation: 10,

                            items: _currencies.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: textStyle,
                                ),
                              );
                            }).toList(),
                            onChanged: (String valueSelected) {
                              changeCurrency(
                                  valueSelected); //separate function to change the state
                            },
                            value:
                                _currentCurrency, // Selected Value from Drop down
                          )),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                            color: Colors.lightBlue,
                            child: Text(
                              'Calculate',
                              style: textStyle,
                            ),
                            onPressed: () {
                              setState(() {
                                //validate before calculating using global key form
                                if (_formKey.currentState.validate()) {
                                  this.displayResult = _calculate();
                                }
                              });
                            },
                          )),
                          Container(
                            width: 12.0,
                          ),
                          Expanded(
                              child: RaisedButton(
                            color: Colors.lightGreen,
                            child: Text(
                              'Reset',
                              style: textStyle,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ))
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(displayResult),
                  )
                ],
              )),
        ));
  }

  // ImageWidget to display image
  Widget getImage() {
    AssetImage imageAsset = AssetImage(
      'images/money.png',
    );
    Image image = Image(image: imageAsset, height: 250, width: 250);
    return Center(child: image);
  }

  //drop down menu change value
  void changeCurrency(String value) {
    setState(() {
      this._currentCurrency = value;
    });
  }

  // logic of calculating for calculate button
  String _calculate() {
    double p = double.parse(principal.text);
    double r = double.parse(rate.text);
    double t = double.parse(term.text);

    double result = p + (p * r * t) / 100;

    return "After $t Years Investment will be Worth $result $_currentCurrency.";
  }

 // reset to null string on pressing Reset
  void _reset() {
    principal.text = '';
    rate.text = '';
    term.text = '';
    displayResult = '';
    _currentCurrency = _currencies[0];
  }
}
