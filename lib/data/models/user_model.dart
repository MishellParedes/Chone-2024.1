import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class User {
  String? email;
  String? name;
  String? password;
  String? rol;
  String? cooperativa;
  bool? confirmed = false;
  bool? hasAccess = false;

  User({this.email, this.name});

  /// Decode user from Cognito User Attributes
  factory User.fromUserAttributes(List<CognitoUserAttribute> attributes) {
    final user = User();
    for (var attribute in attributes) {
      if (attribute.name == 'email') {
        user.email = attribute.value;
      } else if (attribute.name == 'name') {
        user.name = attribute.value;
      } else if (attribute.name! == 'email_verified') {
        if (attribute.value! == 'true') {
          user.confirmed = true;
        }
      } else if (attribute.name == 'zoneinfo') {
        user.cooperativa = attribute.value;
      } else if (attribute.name == 'custom:rol') {
        user.rol = attribute.value;
      }
    }
    return user;
  }

  @override
  String toString() {
    return "email: $email,\nname: $name,\nrol: $rol,\ncooperativa: $cooperativa,\nconfirmed: $confirmed,\nhasAccess: $hasAccess";
  }
}
