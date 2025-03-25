import 'package:bikynav/features/users/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class SensitiveInfoSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SensitiveInfoSection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      title: 'Información sensible',
      children: [
        const Divider(),
        const SizedBox(height: 10),
        CustomTextFormField(controller: passwordController, icon: Icons.lock, placeholder: 'Contraseña', isPassword: true),
        const SizedBox(height: 10),
        CustomTextFormField(controller: confirmPasswordController, icon: Icons.lock, placeholder: 'Repetir Contraseña', isPassword: true),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ExpansionTile(
          leading: IconButton(padding: EdgeInsets.zero, onPressed: () {}, icon: const Icon(Icons.info)), // Manteniendo el IconButton original
          title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          maintainState: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          children: children,
        ),
      ),
    );
  }
}