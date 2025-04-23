import 'package:animate_do/animate_do.dart';
import 'package:bikynav/features/users/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class TallerForm extends StatefulWidget {

  final markerPosition;

  const TallerForm({
    super.key,
    this.markerPosition
  });

  @override
  State<TallerForm> createState() => _TallerFormState();
}



class _TallerFormState extends State<TallerForm> {
  late TextEditingController etiquetaController;
  late TextEditingController contactoController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    etiquetaController = TextEditingController(text: '');
    contactoController = TextEditingController(text: '');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: _buildBasicInfoTaller(),
      )
    );
  }

  Padding _buildBasicInfoTaller() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ExpansionTile(
          leading: const Icon(Icons.info),
          title: const Text(
            'Información básica taller',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          initiallyExpanded: true,
          maintainState: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          children: [
            FadeInDown(
              child: BasicTallerFormFields(
                etiquetaController: etiquetaController,
                contactoController: contactoController,
              )
            ),
          ],
        ),
      );
  }
}


class BasicTallerFormFields extends StatefulWidget {
  final TextEditingController etiquetaController;
  final TextEditingController contactoController;

  const BasicTallerFormFields({
    super.key,
    required this.etiquetaController,
    required this.contactoController,
  });

  @override
  State<BasicTallerFormFields> createState() => _BasicTallerFormFieldsState();
}

class _BasicTallerFormFieldsState extends State<BasicTallerFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        CustomTextFormField(
          controller: widget.etiquetaController,
          icon: Icons.edit,
          placeholder: 'Etiqueta',
          inputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          controller: widget.contactoController,
          icon: Icons.directions_bike,
          placeholder: 'Marca',
          inputType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ],
    );
  }
}