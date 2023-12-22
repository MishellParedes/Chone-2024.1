import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class CardPointsUser extends StatelessWidget {
  const CardPointsUser({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    final int puntosGanados = providerHome.systemVariables['puntosAsignar'];
    final int puntosTotales = providerHome.systemVariables['puntosAcumulados'] +
        providerHome.systemVariables['puntosAsignar'];
    return SizedBox(
      width: 450,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: ThemeApp.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '¡Felicidades Amigo! ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        providerHome.systemVariables['nombreEjecutivo'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: ThemeApp.accentSidebarColor,
                  height: 6,
                  thickness: 3,
                ),
              ),
              Row(
                children: <Widget>[
                  const Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Ganaste:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "$puntosGanados ${puntosGanados == 1 ? 'punto' : 'puntos'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Puntos totales:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '$puntosTotales ${puntosTotales == 1 ? 'punto' : 'puntos'}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
