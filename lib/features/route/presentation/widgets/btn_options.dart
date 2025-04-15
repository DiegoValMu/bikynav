import 'package:bikynav/features/bikes/app/helpers/generate_qr_code.dart';
import 'package:flutter/material.dart';

class VerticalThreeDotsMenu extends StatelessWidget {
  final VoidCallback onShareCode;
  final VoidCallback onDelete;
  final String routeId;

  const VerticalThreeDotsMenu({
    Key? key,
    required this.onShareCode,
    required this.onDelete,
    required this.routeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      key: const Key('vertical_three_dots_menu'),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'compartir':
            onShareCode();
            break;
          case 'compartirQr':
            generateQRCode(context, routeId, 'route');
            break;
          case 'eliminar':
            onDelete();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'compartir',
          child: Row(
            children: [
              Icon(
                Icons.copy,
                color: Colors.green,
              ),
              SizedBox(width: 7),
              Text('Copiar codigo'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'compartirQr',
          child: const Row(
            children: [
              Icon(
                Icons.qr_code,
                color: Colors.deepPurple,
              ),
              SizedBox(width: 7),
              Text('Compartir QR'),
            ],
          ),
          onTap: () {},
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'eliminar',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
              ),
              SizedBox(width: 7),
              Text('Eliminar'),
            ],
          ),
        ),
      ],
    );
  }
}