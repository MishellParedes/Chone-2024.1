import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/data/models/plans_model.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';

class TablePlansHome extends StatelessWidget {
  TablePlansHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    final int len = providerHome.systemVariables['plansToShow'].length;
    return SizedBox(
      width: 410 + (len * Plan.metrics['2']!.toDouble()),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(children: generateListRows(len, providerHome)),
              Positioned(
                top: Plan.metrics['4'],
                left: Plan.metrics['5'],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: generateListBoxes(len),
                ),
              ),
              Positioned(
                left: Plan.metrics['5'],
                child: Row(
                  children: generateListInkWell(len, providerHome, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> generateListRows(int len, ProviderHome providerHome) {
    List<Widget> listRows = [];
    listRows.add(Row(children: generateRow(len, 0, providerHome, false)));
    listRows.add(
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(
          color: ThemeApp.accentSidebarColor,
          height: 6,
          thickness: 3,
        ),
      ),
    );
    listRows.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: generateRow(len, 1, providerHome, false),
        ),
      ),
    );
    listRows.add(const SizedBox(height: 25));
    for (int i = 0; i < Plan.coverages.length; i++) {
      listRows.add(
        i % 2 != 0
            ? Row(children: generateRow(len, i, providerHome, true))
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  children: generateRow(len, i, providerHome, true),
                ),
              ),
      );
    }
    return listRows;
  }

  List<Widget> generateRow(
      int len, int row, ProviderHome providerHome, bool coverage) {
    List<Widget> list = [
      SizedBox(
        width: Plan.metrics['1'],
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 1, bottom: 1),
          child: Text(
            row == 0 && !coverage
                ? 'Planes'
                : row == 1 && !coverage
                    ? 'Valor Total'
                    : Plan.coverages[row],
            style: row == 0 && !coverage
                ? ThemeApp.secondary20_800
                : row == 1 && !coverage
                    ? ThemeApp.sixtieth20_800
                    : ThemeApp.sixtieth16_600,
          ),
        ),
      ),
    ];
    for (int i = 0; i < len; i++) {
      list.add(
        SizedBox(
          width: Plan.metrics['2'],
          child: Center(
            child: Text(
              row == 0 && !coverage
                  ? Plan.plans[providerHome.systemVariables['plansToShow'][i]]
                      ['name']
                  : row == 1 && !coverage
                      ? '\$ ${providerHome.getDecimalFormat(providerHome.systemVariables['formaPago'] == "Mensual" ? Plan.plans[providerHome.systemVariables['plansToShow'][i]]['value'] : Plan.plans[providerHome.systemVariables['plansToShow'][i]]['value'] * 12)}'
                      : Plan.plans[providerHome.systemVariables['plansToShow']
                          [i]]['coverages'][row],
              style: row == 0 && !coverage
                  ? ThemeApp.secondary20_800
                  : row == 1 && !coverage
                      ? ThemeApp.primary18_800
                      : ThemeApp.sixtieth16_600,
            ),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> generateListBoxes(int len) {
    List<Widget> listBoxes = [];
    for (int i = 0; i < len; i++) {
      listBoxes.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: Plan.metrics['2'],
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemeApp.primaryLight,
            ),
          ),
        ),
      );
    }
    return listBoxes;
  }

  List<Widget> generateListInkWell(
      int len, ProviderHome providerHome, BuildContext context) {
    List<Widget> listInkWell = [];
    for (int i = 0; i < len; i++) {
      listInkWell.add(
        SizedBox(
          width: Plan.metrics['2'],
          height: 280,
          child: InkWell(
            hoverColor: Colors.grey.shade200,
            onTap: () {
              providerHome.planSelected(
                  providerHome.systemVariables['plansToShow'][i], context);

              if (providerHome.systemVariables['formaPago'] == "Anual") {
                var valorMensual = providerHome.systemVariables['valueToDebit'];
                var valorAnual = double.parse(valorMensual) * 12;
                providerHome.systemVariables['valueToDebit'] =
                    valorAnual.toStringAsFixed(2);
              }
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }
    return listInkWell;
  }
}
