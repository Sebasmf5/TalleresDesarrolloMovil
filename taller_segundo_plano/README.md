# Taller Segundo Plano (Asincronía en Flutter)

Este proyecto es una aplicación desarrollada en Flutter que tiene como objetivo principal demostrar el uso de tareas asíncronas y ejecución de procesos en segundo plano. La aplicación se divide en tres módulos fundamentales para enseñar cómo manejar operaciones que toman tiempo sin bloquear la interfaz de usuario.

La aplicación contiene tres demostraciones principales:

1. **Módulo Future (Simulación de API)**: El proyecto utiliza `Future` para simular una petición de red que tarda un par de segundos en responder. Muestra cómo la interfaz de usuario puede exhibir un indicador de carga de forma asíncrona y luego actualizarse con los datos obtenidos. También cuenta con una probabilidad simulada de errores para ilustrar el manejo de excepciones.
2. **Módulo Timer (Cronómetro)**: Implementa un cronómetro utilizando la clase `Timer`. Demuestra cómo ejecutar código de manera periódica (cada segundo) y cómo controlar su ciclo de vida (iniciar, pausar, reanudar y reiniciar) actualizando la vista en tiempo real de forma segura.
3. **Módulo Isolate (Tareas Pesadas)**: Para evitar que tareas matemáticamente complejas congelen la pantalla de la aplicación, este módulo ejecuta un bucle muy pesado en un hilo de ejecución completamente separado utilizando `Isolate.spawn`. Se incluye una función adicional para ejecutar la misma tarea en el hilo principal (Main Thread) y así evidenciar cómo se bloquea la interfaz si no se usa un Isolate.

## Estructura del Proyecto (Árbol)

El código fuente principal se encuentra dentro de la carpeta `lib/` y se organiza mediante una arquitectura modular y orientada a "Clean Code":

```text
taller_segundo_plano/
├── lib/
│   ├── features/               # Contiene los submódulos funcionales de la app
│   │   ├── future/             # Lógica y UI de la simulación de red
│   │   │   ├── future_screen.dart
│   │   │   └── future_service.dart
│   │   ├── isolate/            # Lógica y UI del procesamiento pesado
│   │   │   ├── isolate_screen.dart
│   │   │   └── isolate_service.dart
│   │   └── timer/              # Lógica y UI del cronómetro
│   │       ├── timer_screen.dart
│   │       └── timer_service.dart
│   ├── screens/                
│   │   └── home_screen.dart    # Menú principal que enruta a cada funcionalidad
│   ├── utils/                  
│   │   └── logger_mixin.dart   # Utilidad compartida (Mixin) para registrar eventos
│   ├── widgets/                # Componentes visuales reutilizables
│   │   ├── custom_card.dart    # Contenedor decorativo
│   │   └── log_console.dart    # Consola visual oscura para mostrar registros
│   └── main.dart               # Punto de inicio y configuración del tema de la app
```

En esta arquitectura:
- La carpeta **`features/`** asegura que cada funcionalidad de la aplicación tenga su propia pantalla (`_screen.dart`) estrictamente separada de su lógica de negocio (`_service.dart`).
- Las carpetas **`widgets/`** y **`utils/`** agrupan herramientas y componentes de interfaz gráfica que se comparten a lo largo de todo el código, eliminando así la duplicación de bloques repetitivos.

## Pasos para ejecutar el proyecto

Para correr el proyecto en un entorno local, se requiere tener el SDK de Flutter instalado. Se deben seguir estos sencillos pasos:

1. **Abrir la terminal** y navegar a la carpeta raíz del proyecto:
   ```bash
   cd "taller_segundo_plano"
   ```

2. **Descargar e instalar las dependencias** (aunque por ahora solo se usen las herramientas base, esto prepara el entorno):
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   Asegurándose de tener un emulador (Android o iOS) iniciado, un dispositivo físico conectado, o simplemente usando Google Chrome/Edge, se ejecuta el siguiente comando:
   ```bash
   flutter run
   ```
