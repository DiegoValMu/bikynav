import 'dart:convert'; // Para Base64

// Camuflar el ID usando Base64
String camuflarID(String id) {
  return base64Url.encode(utf8.encode(id));
}

// Decodificar el ID camuflado
String decodificarID(String camuflado) {
  return utf8.decode(base64Url.decode(camuflado));
}

// Generar un enlace de ejemplo para compartir el ID camuflado
String generarDynamicLink(String idCamuflado) {
  return '$idCamuflado';
}


