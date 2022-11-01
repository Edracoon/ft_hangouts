
class Contact {
  final int?    id;
  final String  number;
  final String  firstname;
  final String  lastname;
  final String  email;
  final String  birthDate;

  Contact({this.id, required this.number, this.firstname = "", this.lastname = "", this.email = "", this.birthDate = ""});

  factory Contact.fromObject(Map<String, dynamic> json) => Contact(
    id: json['id'],
    number: json['number'],
    firstname: json['firstname'],
    lastname: json['lastname'],
    email: json['email'],
    birthDate: json['birthDate']
  );

  Map<String, dynamic> toObject() {
    return {
      'number': number,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'birthDate': birthDate
    };
  }
}