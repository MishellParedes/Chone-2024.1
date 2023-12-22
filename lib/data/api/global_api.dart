import 'package:sapo_benefica/globals/globals.dart' as globals;

const String cooperativa = 'benefica';

const String graphQLAPI =
    'https://uy2npvljbjaibdwklmzqnqombi.appsync-api.us-east-2.amazonaws.com/graphql';

const String queryClients =
    'https://ejgjlsgaod.execute-api.us-east-2.amazonaws.com/Prod/queryclients';

const String documentService =
    'https://ejgjlsgaod.execute-api.us-east-2.amazonaws.com/Prod/docService';

const String pointsUserGraphql =
    'https://5epx6phoezcvranxkly4lspave.appsync-api.us-east-2.amazonaws.com/graphql';

const String generateToken = 'https://api-v2.documento.ai/api/v2/token';

const String generateSignAuthDebit =
    'https://api-v2.documento.ai/api/v2/sign_request';

const String urlGenerateToken = 'https://api-v2.documento.ai/api/v2/token';

const String urlGenerateFile = 'https://api-v2.documento.ai/api/v2/mergepdfs3';

const String urlSignFile = 'https://api-v2.documento.ai/api/v2/sign_request';

Map<String, String> bodySign = {
  'signer_email': 'notificaciones@grupomancheno.com',
  'signer_cellphone': '0987654321',
  'signer_address': 'Ecuador',
  'signer_dni_scan':
      'https://cpnalmacenainnovacion.blob.core.windows.net/cpn-documentos/Cedulas/0201795598_CEDFRO_20220824102253.png',
  'signer_dni_scan_front':
      'https://cpnalmacenainnovacion.blob.core.windows.net/cpn-documentos/Cedulas/0201795598_CEDFRO_20220824102253.png',
  'signer_dni_scan_back':
      'https://cpnalmacenainnovacion.blob.core.windows.net/cpn-documentos/Cedulas/0201795598_CEDFRO_20220824102253.png',
  'biometric_method': 'facephi',
  'biometric_percentage': '80',
  'biometric_id':
      'oPJde4yb8+zNG70fCpQcR0EMizsE0TO0lB568QN9v0R0JlAzYbG3IN0hyd8SqONfli4a15s4IJPSw0zVQ4ZouSLL/mH7fKVvDZX5eonJ19WpG5ctCYUziQoRtDwW98YY9agxKQb9Tv20cZhxU4pz6YqQ0iFRF10OWc8ULueR2gwO04U4hSW/pQClmH3tCHkC91bLUaoSuXfJ5UWRD74GwK3twhU27crUA9wbg0dpsobeNfGhuXRV8xJeTxMJMaqXqQgtJButNerhVLOuVBeWIuWkW/Fxa2ZYHLvxT+l81pNLO0la1Xr7hGFeEk827mKeIV7HAuu2fH6fA10IG09nNw==',
  'biometric_rc_validation': 'true',
  'output_bucket': 'janus-afiliaciones-documents',
  'sign_position': '250,160,650,250',
  'sign_page_number': '1',
  'sign_field_tag':
      globals.isSapo ? 'SAPO Benefica 2023' : 'GEMA Benefica 2023',
  'signing_request_uuid': '',
  'biometric_trace_picture':
      'https://cpnalmacenainnovacion.blob.core.windows.net/cpn-documentos/Identificacion/1714133897_SELPHIE.png',
  'biometric_rc_picture':
      'https://cpnalmacenainnovacion.blob.core.windows.net/cpn-documentos/Identificacion/1714133897.png'
};
