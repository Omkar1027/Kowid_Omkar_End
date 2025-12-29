class SignupData {
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? password;
  String? pin;
  String? token; // To store the JWT from Step 2

  SignupData({this.firstName, this.lastName, this.phone, this.email, this.password, this.pin, this.token});
}