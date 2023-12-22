import 'package:flutter/material.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class DialogDownloads extends StatelessWidget {
  const DialogDownloads({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderHome providerHome = Provider.of<ProviderHome>(context);
    return AlertDialog(
      title: const Text('Documentos', style: ThemeApp.primary20Bold),
      content: SizedBox(
        height: 170,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const Text('Autorización de Broker'),
                const Spacer(),
                IconButton(
                  onPressed: () => providerHome.downloadFiles(0),
                  icon: const Icon(Icons.download, color: ThemeApp.primary),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     const Text('Autorización de Datos'),
            //     const Spacer(),
            //     IconButton(
            //       onPressed: () => providerHome.downloadFiles(1),
            //       icon: const Icon(Icons.download, color: ThemeApp.primary),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                const Text('Autorización de Débito'),
                const Spacer(),
                IconButton(
                  onPressed: () => providerHome.downloadFiles(1),
                  icon: const Icon(Icons.download, color: ThemeApp.primary),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Certificado'),
                const Spacer(),
                IconButton(
                  onPressed: () => providerHome.downloadFiles(2),
                  icon: const Icon(Icons.download, color: ThemeApp.primary),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ThemeApp.secondary),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Salir'),
        ),
      ],
    );
  }
}
