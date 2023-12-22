import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class AmazonConstant {
  static const regionAWS = 'us-east-2';
  static const awsUserPoolId = 'us-east-2_V8B6nhETp';
  static const awsClientId = '15e25s9ffpo7fqjdke7tvielaf';

  static const identityPoolId =
      'us-east-2:e8be7eee-4b79-47a3-ae55-a47bffc74921';

  static const s3EndpointCarteraPagoFiles =
      'https://erp-cartera-pagos.s3.us-east-2.amazonaws.com/';
  static const s3BucketNameCarteraPagoFiles = 'erp-cartera-pagos';
  static const s3BucketAgenciamientoFiles = 'erp-agenciamientos';

  static const s3EndpointAgenciamientoFiles =
      'https://erp-agenciamientos.s3.us-east-2.amazonaws.com/';

  static const url =
      'https://lcazg67lmbgjrkfve34ryqbkx4.appsync-api.us-east-2.amazonaws.com/graphql';

  static final userPool = CognitoUserPool(awsUserPoolId, awsClientId);

  static const graphQLAPI = "https://uy2npvljbjaibdwklmzqnqombi.appsync-api.us-east-2.amazonaws.com/graphql";
  
 

}
