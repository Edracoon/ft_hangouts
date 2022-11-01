// ignore_for_file: file_names

import 'package:flutter/material.dart'; // Flutter global import
import 'package:flutter/services.dart'; // For TextInputFormatter and FilteringTextInputFormatter for forms
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


import '../contact_model.dart';    // Contact Model
import '../database_helper.dart';  // Database

// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage);

class AddContact extends StatefulWidget {

  // The callback variable
  final Callback callback;

  // The constructor
  const AddContact({Key? key, required this.callback}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final nbFocus = FocusNode();
  final nbCtrl = TextEditingController();

  final fnFocus = FocusNode();
  final fnCtrl = TextEditingController();

  final lnFocus = FocusNode();
  final lnCtrl = TextEditingController();

  final emFocus = FocusNode();
  final emCtrl = TextEditingController();

  final bdFocus = FocusNode();
  final bdCtrl = TextEditingController();

  final ScrollController scrollCtrl = ScrollController();

  PhoneCountryData? _initialCountryData;

  // Create a global key that uniquely identifies the Form widget  
  // and allows validation of the form.  
  final _formKey = GlobalKey<FormState>();  


  void registerContact() async {
    // It returns true if the form is valid, otherwise returns false  
    if (_formKey.currentState!.validate()) {  
      // If the form is valid, display a Snackbar.  
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Contact is registered !'),
        backgroundColor: Colors.green,
      ));
      Contact newContact = Contact(number: nbCtrl.text, firstname: fnCtrl.text, lastname: lnCtrl.text,
                                    email: emCtrl.text, birthDate: bdCtrl.text);
      print('hello ${newContact.number}');

      await DatabaseHelper.instance.add(newContact);
      widget.callback(0);
    }  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('New contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {  widget.callback(0); },
        ),
      ),
      body: Scrollbar(
        controller: scrollCtrl,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollCtrl,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    controller: fnCtrl,
                    focusNode: fnFocus,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Firstname of the contact',
                      labelText: 'Firstname',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18)
                    ],
                  ),
                  TextFormField(
                    controller: lnCtrl,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Lastname of the contact',
                      labelText: 'Lastname',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CountryDropdown(
                          printCountryName: true,
                          initialCountryCode: 'FR',
                          onCountrySelected: (PhoneCountryData countryData) {
                            setState(() {
                              _initialCountryData = countryData;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          controller: nbCtrl,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText: 'Enter a phone number',
                            labelText: 'Phone',
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            PhoneInputFormatter(
                              allowEndlessPhone: false,
                              defaultCountryCode: _initialCountryData?.countryCode,
                            )
                          ],
                        )
                      )
                    ],
                  ),
                  TextFormField(
                    controller: emCtrl,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: 'E-mail of the contact',
                      labelText: 'E-mail',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30)
                    ],
                  ),
                  TextFormField(
                    controller: bdCtrl,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      hintText: 'Enter a birth date',
                      labelText: 'Birth Date',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18)
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 0.0, top: 60.0),
                    child: ElevatedButton(
                      onPressed: () => registerContact(),
                      child: const Text('Register'),
                    )
                  ),
                ],
              )
            )
          )
        )
      )
    );
  }
}