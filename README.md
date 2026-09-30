# bikynav

Características Principales

🗺️ Navegación y Trazado de Rutas: Integración con Google Maps API (google_maps_flutter, google_polyline_algorithm) y geolocalización precisa en tiempo real (geolocator).

🚨 Alertas en Tiempo Real (WebSockets): Comunicación mediante socket_io_client para emitir alertas instantáneas (p. ej., robo o emergencias) calculando áreas de desplazamiento en tiempo real.

🔒 Persistencia del Estado de Navegación: Conservación del estado de la app incluso con la pantalla del teléfono bloqueada mediante hydrated_bloc.

📲 Gestión de Códigos QR & Capturas: Generación de códigos QR (qr_flutter), escaneo rápido con cámara (mobile_scanner), y capacidad de tomar capturas (screenshot) y guardarlas/compartirlas (flutter_image_gallery_saver, share_plus).

🔐 Autenticación y Nube: Autenticación de usuarios y backend Serverless con Firebase (firebase_auth, cloud_firestore).

🎨 UI/UX Interactiva y Animada: Enrutamiento declarativo con go_router, marcadores animados personalizables (animated_marker), animaciones de interfaz (animate_do, animated_check) e íconos de aplicación personalizados (flutter_launcher_icons).

Stack Tecnológico

Frontend (Mobile)
Framework: Flutter (Dart)

Gestión de Estado: flutter_bloc & hydrated_bloc (Estado hidratado)

Navegación: go_router

Mapas & Ubicación: google_maps_flutter, geolocator, google_polyline_algorithm

Realtime & Redes: socket_io_client, dio, http

Base de Datos Local & Preferencias: shared_preferences, path_provider

Escaneo, QR & Utilidades: mobile_scanner, qr_flutter, screenshot, share_plus, permission_handler

Firebase: firebase_core, firebase_auth, cloud_firestore

Backend & Servicios Integrados
Servidor Propio: Node.js + Express + WebSockets (Socket.io)

Base de Datos Backend: MongoDB

Cloud: Firebase Services

Autor
Diego Valderrama Muñoz

GitHub: @DiegoValMu

LinkedIn: Diego Valderrama Muñoz

Email: diego.valderrama.mu@gmail.com
