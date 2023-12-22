import 'package:flutter/widgets.dart';
import 'package:sapo_benefica/data/models/plans_model.dart';
import 'package:sapo_benefica/globals/globals.dart' as globals;

class ApiGetTableFormat {
  static Future<dynamic> getTableFormat() async {
    final dynamic response = {
      'system_name': globals.isSapo ? 'sapo_benefica' : 'gema_benefica',
      'items': {
        'plans': <Map<String, dynamic>>[
          {
            'name': 'Opción 1 Socio Antiguo',
            'value': 1.50,
            'values': <double>[
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
              1.50,
            ],
            'coverages': <String>[
              '1.500',
              '1.500',
              '750',
              'Ilimitado',
              'Ilimitado',
            ],
            'rules': {
              'min_age_new': <int>[0, 0, 1],
              'max_age_new': <int>[80, 0, 1],
              'min_age_old': <int>[0, 0, 1],
              'max_age_old': <int>[80, 0, 1],
            }
          },
          {
            'name': 'Opción 2 Socio + Familia Antiguo',
            'value': 2.50,
            'values': <double>[
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
            ],
            'coverages': <String>[
              '2.000',
              '2.000',
              '1.000',
              'Ilimitado',
              'Ilimitado',
            ],
            'rules': {
              'min_age_new': <int>[0, 0, 1],
              'max_age_new': <int>[80, 0, 1],
              'min_age_old': <int>[0, 0, 1],
              'max_age_old': <int>[80, 0, 1],
            }
          },
          {
            'name': 'Opción 1 \nSocio + Familia',
            'value': 2.50,
            'values': <double>[
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
              2.50,
            ],
            'coverages': <String>[
              '1.500',
              '1.500',
              '750',
              'Ilimitado',
              'Ilimitado',
            ],
            'rules': {
              'min_age_new': <int>[0, 0, 1],
              'max_age_new': <int>[80, 0, 1],
              'min_age_old': <int>[0, 0, 1],
              'max_age_old': <int>[80, 0, 1],
            }
          },
          {
            'name': 'Opción 2 \nSocio + Familia',
            'value': 3.50,
            'values': <double>[
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
              3.50,
            ],
            'coverages': <String>[
              '2.500',
              '2.500',
              '1.500',
              'Ilimitado',
              'Ilimitado',
            ],
            'rules': {
              'min_age_new': <int>[0, 0, 1],
              'max_age_new': <int>[80, 0, 1],
              'min_age_old': <int>[0, 0, 1],
              'max_age_old': <int>[80, 0, 1],
            }
          },
        ],
        'coverages': <String>[
          'Vida',
          'Incapacidad',
          'Enfermedades Graves',
          'Medicina General',
          'Medicinas',
        ],
        'metrics': <String, int>{
          'valuesInBox': 2,
        },
      },
    };
    debugPrint('Tabla obtenida: ${response['system_name']}');
    final Plan plan = Plan();
    plan.fromJson(response['items']);
    return null;
  }
}
