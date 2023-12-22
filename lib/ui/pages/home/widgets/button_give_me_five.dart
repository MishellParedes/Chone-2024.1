import 'package:flutter/material.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class ButtonGiveMeFive extends StatelessWidget {
  const ButtonGiveMeFive({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    return Column(
      children: [
        const Text(
          "Give me 5 para finalizar",
          style: TextStyle(fontSize: 14, color: ThemeApp.accentSidebarColor),
        ),
        const SizedBox(height: 10),
        InkWell(
            child: Image.asset(
              "assets/img/giveme5.png",
              height: 120,
            ),
            onTap: () => providerHome.giveMeFive())
      ],
    );
  }
}
