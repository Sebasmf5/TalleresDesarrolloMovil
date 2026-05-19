# Taller Firebase - Universidades

Aplicacion Flutter que integra Firebase y gestiona la coleccion `universidades` en Cloud Firestore con operaciones CRUD en tiempo real.

## Requisitos

- Flutter SDK 3.41+
- Cuenta de Firebase con Cloud Firestore habilitado

## Configuracion de Firebase

1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com)
2. Habilitar **Cloud Firestore** en modo de prueba
3. Agregar una app Android con el package `com.taller.taller_firebase` y descargar `google-services.json`
4. Colocar el archivo en `android/app/google-services.json`
5. Copiar las credenciales de la app Web (apiKey, appId, projectId, etc.) en `lib/firebase_options.dart`

## Estructura del proyecto

```
lib/
  main.dart                          # Inicializacion de Firebase y MaterialApp
  firebase_options.dart              # Credenciales de Firebase por plataforma
  models/
    universidad.dart                 # Modelo de datos Universidad
  services/
    firebase_service.dart            # Servicio CRUD contra Firestore
  screens/
    universidades_list_screen.dart   # Listado en tiempo real
    agregar_universidad_screen.dart  # Formulario de creacion
```

## Funcionalidades

- **Listado en tiempo real**: `StreamBuilder` conectado a Firestore
- **Crear universidad**: formulario con validaciones
- **Eliminar universidad**: boton con confirmacion
- **Validacion de campos**: todos requeridos, URL valida en pagina_web

## Ejecucion

```bash
cd taller_firebase
flutter pub get
flutter run
```

## Dependencias

| Paquete | Version | Uso |
|---------|---------|-----|
| firebase_core | ^4.9.0 | Inicializacion de Firebase |
| cloud_firestore | ^6.4.1 | Operaciones Firestore |

## Repositorio

https://github.com/Sebasmf5/TalleresDesarrolloMovil

Rama: `feature/taller_firebase_universidades`
