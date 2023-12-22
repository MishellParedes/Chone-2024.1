import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:sapo_benefica/data/aws/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static UserService? _instance;
  factory UserService(CognitoUserPool userPool) {
    _instance ??= UserService._internal(userPool);
    return _instance!;
  }
  UserService._internal(this._userPool);

  final CognitoUserPool _userPool;
  CognitoUser? cognitoUser;
  CognitoUserSession? _session;
  CognitoUserSession? get session => _session;
  CognitoCredentials? credentials;

  /// Initiate user session from local storage if present
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = Storage(prefs);
    _userPool.storage = storage;

    cognitoUser = await _userPool.getCurrentUser();

    if (cognitoUser == null) {
      return false;
    }
    _session = await cognitoUser!.getSession();
    return _session!.isValid();
  }

  /// Get existing user from session with his/her attributes
  Future<User?> getCurrentUser() async {
    if (cognitoUser == null || _session == null) {
      return null;
    }
    if (!_session!.isValid()) {
      return null;
    }
    final attributes = await cognitoUser!.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = User.fromUserAttributes(attributes);
    user.hasAccess = true;
    return user;
  }

  Future<dynamic> getAttributesUser() async {
    List<CognitoUserAttribute>? attributes;
    if (cognitoUser == null || _session == null) {
      return null;
    }
    if (!_session!.isValid()) {
      return null;
    }
    attributes = await cognitoUser!.getUserAttributes();
    if (attributes == null) {
      return null;
    }

    return attributes;
  }

  /// Retrieve user credentials -- for use with other AWS services
  Future<CognitoCredentials?> getCredentials() async {
    if (cognitoUser == null || _session == null) {
      return null;
    }

    credentials = CognitoCredentials(
        AmazonConstant.identityPoolId, AmazonConstant.userPool);
    await credentials!.getAwsCredentials(_session!.getIdToken().getJwtToken());
    return credentials;
  }

  /// Login user
  Future<User?> login(String email, String password) async {
    cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );

    bool isConfirmed;
    try {
      _session = await cognitoUser?.authenticateUser(authDetails);
      isConfirmed = true;
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        rethrow;
      }
    } on CognitoUserException catch (e) {
      isConfirmed = false;
      if (e.message == 'User Confirmation Necessary') {
        _session = await cognitoUser?.authenticateUser(authDetails);
        isConfirmed = true;
      }
    }

    if (!_session!.isValid()) {
      return null;
    }

    final attributes = await cognitoUser!.getUserAttributes();
    final user = User.fromUserAttributes(attributes!);
    user.confirmed = isConfirmed;
    user.hasAccess = true;

    return user;
  }

  /// Confirm user's account with confirmation code sent to email
  Future<bool?> confirmAccount(String email, String confirmationCode) async {
    cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

    return await cognitoUser?.confirmRegistration(confirmationCode);
  }

  /// Resend confirmation code to user's email
  Future<void> resendConfirmationCode(String email) async {
    cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
    await cognitoUser?.resendConfirmationCode();
  }

  /// Check if user's current session is valid
  Future<bool?> checkAuthenticated() async {
    if (cognitoUser == null || _session == null) {
      return false;
    }
    return _session?.isValid();
  }

  /// Sign upuser
  Future<User> signUp(String email, String password, String name) async {
    CognitoUserPoolData data;
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
    ];
    data =
        await _userPool.signUp(email, password, userAttributes: userAttributes);

    final user = User();
    user.email = email;
    user.name = name;
    user.confirmed = data.userConfirmed;

    return user;
  }

  Future<void> signOut() async {
    cognitoUser = await _userPool.getCurrentUser();
    if (credentials != null) {
      await credentials?.resetAwsCredentials();
    }
    if (cognitoUser != null) {
      return cognitoUser?.signOut();
    }
  }

  Future<void> globalSignOut() async {
    cognitoUser = await _userPool.getCurrentUser();
    return cognitoUser?.signOut();
  }
}
