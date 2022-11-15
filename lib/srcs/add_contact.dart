import 'package:flutter/material.dart'; // Flutter global import
import 'package:flutter/services.dart'; // For TextInputFormatter and FilteringTextInputFormatter for forms

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../contact_model.dart';    // Contact Model
import '../database_helper.dart';  // Database     

// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage, Contact? contact);

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
  final _text = '';
  bool _submitted = false;

  final fnFocus = FocusNode();
  final fnCtrl = TextEditingController();

  final lnFocus = FocusNode();
  final lnCtrl = TextEditingController();

  final emFocus = FocusNode();
  final emCtrl = TextEditingController();

  final bdFocus = FocusNode();
  final bdCtrl = TextEditingController();

  final ScrollController scrollCtrl = ScrollController();

  // Create a global key that uniquely identifies the Form widget  
  // and allows validation of the form.  
  final _formKey = GlobalKey<FormState>();  

  getInputError(String text) {
    // final phoneRegex = RegExp(r'^\s*[1-9](?:[\s.-]*\d{2}){4}$');
    if (nbCtrl.text.isEmpty) { return AppLocalizations.of(context).emptyError; }
    if (nbCtrl.text.length != 13) { return AppLocalizations.of(context).formatError; }
    return null;
  }

  void registerContact() async {
    setState(() => _submitted = true);
    // It returns true if the form is valid, otherwise returns false
    if (_formKey.currentState!.validate() && getInputError(nbCtrl.text) == null) {
      // If the form is valid, display a Snackbar.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).contactRegistered),
        backgroundColor: Colors.green,
      ));

      Contact newContact = Contact(number: "0${nbCtrl.text}", firstname: fnCtrl.text, lastname: lnCtrl.text,
                                    email: emCtrl.text, birthDate: bdCtrl.text);

      await DatabaseHelper.instance.add(newContact);
      widget.callback(0, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(AppLocalizations.of(context).newContact),
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
                    focusNode: fnFocus,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: AppLocalizations.of(context).firstNameLabel,
                      labelText: AppLocalizations.of(context).firstName,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18)
                    ],
                  ),
                  TextFormField(
                    controller: lnCtrl,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: AppLocalizations.of(context).lastNameLabel,
                      labelText: AppLocalizations.of(context).lastName,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          controller: nbCtrl,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.phone),
                            hintText: AppLocalizations.of(context).phoneLabel,
                            labelText: '${AppLocalizations.of(context).phone} (+33)',
                            errorText: _submitted ? getInputError(nbCtrl.text) : null,
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            PhoneInputFormatter(
                              allowEndlessPhone: false,
                              defaultCountryCode: 'FR',
                            )
                          ],
                          onChanged: (text) => setState(() => _text)
                        )
                      )
                    ],
                  ),
                  TextFormField(
                    controller: emCtrl,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.mail),
                      hintText: AppLocalizations.of(context).emailLabel,
                      labelText: AppLocalizations.of(context).email,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30)
                    ],
                  ),
                  TextFormField(
                    controller: bdCtrl,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: AppLocalizations.of(context).birthDateLabel,
                      labelText: AppLocalizations.of(context).birthDate,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18)
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 0.0, top: 60.0),
                    child: ElevatedButton(
                      onPressed: () => registerContact(),
                      child: Text(AppLocalizations.of(context).register),
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