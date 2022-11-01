import 'package:flutter/material.dart'; // Flutter global import
import 'package:flutter/services.dart'; // For TextInputFormatter and FilteringTextInputFormatter for forms

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../contact_model.dart';    // Contact Model
import '../database_helper.dart';  // Database

// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage, Contact? contact);

class EditContact extends StatefulWidget {

  // The callback variable
  final Callback callback;

  final Contact contact;

  // The constructor
  const EditContact({Key? key, required this.callback, required this.contact }) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final _text = ''; // just used to update things reactively
  late Contact _contact;
  bool _submitted = false;

  final nbCtrl = TextEditingController();
  final fnCtrl = TextEditingController();
  final lnCtrl = TextEditingController();
  final emCtrl = TextEditingController();
  final bdCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
    nbCtrl.text = _contact.number.substring(1);
    fnCtrl.text = _contact.firstname;
    lnCtrl.text = _contact.lastname;
    emCtrl.text = _contact.email;
    bdCtrl.text = _contact.birthDate;
  }


  final ScrollController scrollCtrl = ScrollController();

  PhoneCountryData? _initialCountryData;

  // Create a global key that uniquely identifies the Form widget  
  // and allows validation of the form.  
  final _formKey = GlobalKey<FormState>();  

  getInputError(String text) {

    if (nbCtrl.text.isEmpty) { return 'Can\'t be empty'; }
    if (_initialCountryData?.getCorrectMask(_initialCountryData?.countryCode).length != nbCtrl.text.length)
    { return 'Incorrect format number'; }
    return null;
  }

  void updateContact() async {
    setState(() => _submitted = true);
    // It returns true if the form is valid, otherwise returns false
    if (_formKey.currentState!.validate() && getInputError(nbCtrl.text) == null) {
      // If the form is valid, display a Snackbar.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Saved !'),
        backgroundColor: Colors.green,
      ));

      nbCtrl.text = "0${nbCtrl.text}";
      Contact editedContact = Contact(id: _contact.id, number: nbCtrl.text, firstname: fnCtrl.text, lastname: lnCtrl.text,
                                    email: emCtrl.text, birthDate: bdCtrl.text);

      await DatabaseHelper.instance.update(editedContact);
      widget.callback(0, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Edit contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {  widget.callback(0, null); },
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
                        flex: 5,
                        child: TextFormField(
                          controller: nbCtrl,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.phone),
                            hintText: 'Enter a phone number',
                            labelText: 'Phone',
                            errorText: _submitted ? getInputError(nbCtrl.text) : null,
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            PhoneInputFormatter(
                              allowEndlessPhone: false,
                              defaultCountryCode: _initialCountryData?.countryCode,
                            )
                          ],
                          onChanged: (text) => setState(() => _text)
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
                      onPressed: () => updateContact(),
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