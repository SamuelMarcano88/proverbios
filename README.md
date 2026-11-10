# ¿Qué perfil eres?

Aplicación web en Flutter para reflexionar sobre las enseñanzas del libro de
Proverbios.

## Funciones

- Test de reflexión que mezcla preguntas y respuestas cada vez que se inicia,
  con resultados orientativos para el sabio, el simple y el insensato. No es un
  diagnóstico ni una etiqueta permanente.
- Proverbio diario con una reflexión breve; usa textos de Reina-Valera 1909,
  de dominio público.
- Guía de aprendizaje sobre los tres perfiles, con enseñanzas y prácticas que
  cambian aleatoriamente al entrar.
- Cuentas con correo y contraseña, historial del test y favoritos en Supabase.
  Las cuentas y el guardado en la nube requieren configurar el proyecto según
  los pasos de abajo.

## Estructura

```text
lib/
  app/
    app.dart
    theme/
  features/
    daily_proverb/
    home/
    learning/
    progress/
    quiz/
    shared/
  main.dart
test/
web/
```

El script [supabase/schema.sql](./supabase/schema.sql) crea las tablas de
progreso y sus políticas de seguridad por usuario.

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

### Configurar Supabase

1. En el SQL Editor del proyecto Supabase, ejecuta el contenido de
   `supabase/schema.sql`.
2. En la configuración de autenticación de Supabase, habilita el proveedor
   **Email** y configura la confirmación de correo y las URLs de redirección
   según el dominio de Netlify.
3. En Netlify, abre **Project configuration → Environment variables** y agrega:
   - `SUPABASE_URL`: URL del proyecto.
   - `SUPABASE_PUBLISHABLE_KEY`: clave pública/publishable del proyecto (nunca
     uses la `service_role` en el cliente).
4. Vuelve a desplegar la rama `main`.

El build pasa esas variables a Flutter mediante `--dart-define`. Para desarrollo
local, proporciona los mismos valores al ejecutar `flutter run` o
`flutter build web`, por ejemplo:

```powershell
flutter run -d chrome `
  --dart-define="SUPABASE_URL=$env:SUPABASE_URL" `
  --dart-define="SUPABASE_PUBLISHABLE_KEY=$env:SUPABASE_PUBLISHABLE_KEY"
```

Sin esas variables, las secciones de lectura funcionan, pero no se pueden crear
cuentas ni guardar progreso o favoritos en la nube.
