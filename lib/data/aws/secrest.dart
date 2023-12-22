import 'package:amazon_cognito_identity_dart_2/cognito.dart';


const aWSUserPoolId = 'us-east-2_V8B6nhETp';

const aWSClientId = '15e25s9ffpo7fqjdke7tvielaf';

const identityPoolId = 'us-east-2:e8be7eee-4b79-47a3-ae55-a47bffc74921';

// formularios-digitales_Auth-Role
// formularios-digitales_Unauth_Role

// Setup endpoints here:
const region = 'us-east-2';
final userPool = CognitoUserPool(aWSUserPoolId, aWSClientId);

// * Buckets S3

const s3EndpointPlantillas =
    'https://formularios-gm-plantillas.s3.us-east-2.amazonaws.com/';
const s3EndpointImagenes =
    'https://formularios-gm-imagenes.s3.us-east-2.amazonaws.com/';
const s3EndpointAutorizaciones =
    'https://formularios-gm-autorizaciones.s3.us-east-2.amazonaws.com/';
const s3EndpointDocsSinFirmar =
    'https://formularios-gm-sin-firmar.s3.us-east-2.amazonaws.com/';
const s3EndpointDocsFirmados =
    'https://formularios-gm-firmados.s3.us-east-2.amazonaws.com/';
const s3EndpointArchivos =
    'https://formularios-gm-archivos.s3.us-east-2.amazonaws.com/';

const s3BucketNamePlantillas = 'formularios-gm-plantillas';
const s3BucketNameImagenes = 'formularios-gm-imagenes';
const s3BucketNameAutorizaciones = 'formularios-gm-autorizaciones';
const s3BucketNameDocsFirmados = 'formularios-gm-firmados';
const s3BucketNameDocsSinFirmar = 'formularios-gm-sin-firmar';
const s3BucketNameSiniestros = 'formularios-gm-siniestros';
const s3BucketNameArchivos = 'formularios-gm-archivos';

const aPIEndpoint = 'https://janus.grupomancheno.com';

// * GraphQL
const graphQLAPIEndpointForms =
    'https://dadlmomuofdazc7kcpnajzeavq.appsync-api.us-east-2.amazonaws.com/graphql';
// ID> gnagrcyohjhzxpinsg7gbuk7cm
// API KEY> da2-tysafphubnfv7lj4enl52uz37q

const graphQLAPIEndpointgemaUsuarios =
    'https://5epx6phoezcvranxkly4lspave.appsync-api.us-east-2.amazonaws.com/graphql';
const apiKeygemaUsuarios = 'da2-eojqnvfrovctlb26ckf7xssq2a';

const graphQLAPIEndpointNumerosCertificadosFormulariosDig =
    'https://xqfxp7o2lzei5altz4iuzyfzim.appsync-api.us-east-2.amazonaws.com/graphql';
const apiKeyNumerosCertificadosFormulariosDig =
    'da2-6gv5fl37dfhv5f3qfvmwicpgea';
