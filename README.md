# ¿Qué perfil eres?

Aplicación web en Flutter para reflexionar sobre las enseñanzas del libro de
Proverbios.

## Estado actual

La primera entrega contiene la estructura inicial de Flutter y una propuesta
responsive para la pantalla principal. Las tarjetas muestran las tres secciones
previstas; su contenido funcional, autenticación y conexión con Supabase quedan
para las siguientes etapas. No se usan datos de demostración para simular esas
integraciones.

## Estructura

```text
lib/
  app/
    app.dart
    theme/
  features/
    home/
      presentation/
  main.dart
test/
web/
```

La interfaz y el tema están separados de las futuras funciones por carpetas
`features`. En etapas posteriores se incorporarán autenticación y datos reales
de Supabase, el test, el proverbio diario y los temas de aprendizaje.

## Ejecutar localmente

Requiere Flutter con soporte para Web. Desde la raíz del proyecto:

```powershell
flutter pub get
flutter run -d chrome
```

Para comprobar la entrega:

```powershell
flutter analyze
flutter test
flutter build web
```

## Publicar en Netlify

El archivo `netlify.toml` configura Netlify para compilar Flutter y publicar
`build/web`, que es donde Flutter genera el `index.html` del sitio. El script
usa Flutter 3.41.1 (la versión de esta entrega) y descarga el SDK oficial en el
entorno de compilación si no está instalado.

Para despliegue continuo, conecta el repositorio a Netlify y usa la raíz del
repositorio como directorio base. La configuración de `netlify.toml` se aplica
al siguiente deploy.

Para una publicación manual desde tu computadora, ejecuta:

```powershell
flutter build web --release
```

Luego publica la carpeta `build/web` en Netlify. No publiques la raíz del
proyecto ni la carpeta `web`: ninguna contiene el sitio compilado completo.
