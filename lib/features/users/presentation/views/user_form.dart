import 'dart:convert';
import 'package:bikynav/features/users/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bikynav/features/users/config/models/country.dart';

mixin RegionComunaMixin<T extends StatefulWidget> on State<T> {
  List<Region> regiones = [];
  List<String> comunas = [];
  String? selectedRegion;
  String? selectedComuna;

  Future<void> loadRegionsAndComunas() async {
    final response = await rootBundle.loadString('assets/data/regiones_comunas.json');
    final countryData = CountryData.fromMap(json.decode(response));
    if (mounted) {
      setState(() => regiones = countryData.regions);
    }
  }

  void updateComunas(String regionName) async {
    final response = await rootBundle.loadString('assets/data/regiones_comunas.json');
    final countryData = CountryData.fromMap(json.decode(response));
    final selectedRegionData = countryData.regions.firstWhere((region) => region.name == regionName);
    if (mounted) {
      setState(() {
        comunas = selectedRegionData.communes.map((commune) => commune.name).toList();
        selectedComuna = null; // Reset comuna when region changes
      });
    }
  }

  Widget buildRegionDropdown({required void Function(String?) onRegionChanged}) {
    return DropdownButtonFormField<String>(
      value: selectedRegion,
      items: regiones.map((region) => DropdownMenuItem<String>(value: region.name, child: Text(region.name))).toList(),
      onChanged: onRegionChanged,
      decoration: InputDecoration(
        labelText: 'Región',
        prefixIcon: Icon(Icons.home, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue)), // Use your theme color
      ),
    );
  }

  Widget buildComunaDropdown({required void Function(String?) onComunaChanged}) {
    return DropdownButtonFormField<String>(
      value: selectedComuna,
      items: comunas.map((comuna) => DropdownMenuItem<String>(value: comuna, child: Text(comuna))).toList(),
      onChanged: onComunaChanged,
      decoration: InputDecoration(
        labelText: 'Comuna',
        prefixIcon: Icon(Icons.location_on, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue)), // Use your theme color
      ),
    );
  }
}

class UserFormSection extends StatefulWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final String? initialRegion;
  final String? initialComuna;
  final ValueChanged<Map<String, String>> onBasicInfoChanged;

  const UserFormSection({
    super.key,
    required this.nombreController,
    required this.apellidoController,
    this.initialRegion,
    this.initialComuna,
    required this.onBasicInfoChanged,
  });

  @override
  State<UserFormSection> createState() => _UserFormSectionState();
}

class _UserFormSectionState extends State<UserFormSection> with RegionComunaMixin {
  @override
  void initState() {
    super.initState();
    loadRegionsAndComunas();
    selectedRegion = widget.initialRegion;
    if (widget.initialRegion != null) {
      updateComunas(widget.initialRegion!);
      selectedComuna = widget.initialComuna;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      title: 'Información básica',
      children: [
        const Divider(),
        const SizedBox(height: 10),
        CustomTextFormField(controller: widget.nombreController, icon: Icons.person, placeholder: 'Correo electronico', inputType: TextInputType.emailAddress), // Manteniendo el placeholder original
        const SizedBox(height: 10),
        CustomTextFormField(controller: widget.nombreController, icon: Icons.person, placeholder: 'Nombre', inputType: TextInputType.name),
        const SizedBox(height: 10),
        CustomTextFormField(controller: widget.apellidoController, icon: Icons.person, placeholder: 'Apellido', inputType: TextInputType.name),
        const SizedBox(height: 10),
        buildRegionDropdown(
          onRegionChanged: (value) {
            setState(() {
              selectedRegion = value;
              selectedComuna = null;
              comunas.clear();
              if (value != null) updateComunas(value);
              widget.onBasicInfoChanged({
                'region': selectedRegion ?? '',
                'comuna': selectedComuna ?? '',
                'nombre': widget.nombreController.text.trim(),
                'apellido': widget.apellidoController.text.trim(),
              });
            });
          },
        ),
        const SizedBox(height: 10),
        buildComunaDropdown(
          onComunaChanged: (value) {
            setState(() {
              selectedComuna = value;
              widget.onBasicInfoChanged({
                'region': selectedRegion ?? '',
                'comuna': selectedComuna ?? '',
                'nombre': widget.nombreController.text.trim(),
                'apellido': widget.apellidoController.text.trim(),
              });
            });
          },
        ),
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
          initiallyExpanded: true,
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