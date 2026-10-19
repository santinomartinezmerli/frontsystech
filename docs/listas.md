# Pantalla de Listas — SmartLists (Frontend)

Documentación de lo implementado en el frontend Flutter (`pf_systech_frontend`) para el catálogo de listas de antecedentes. Parte del trabajo del Integrante 4 (packs, listas y límites de consultas).

## 1. Contexto

SmartLists es la evolución del módulo de Listas de Vigía (Systech): verificación de identidades contra listas de sanciones, PEP y personas reportadas.

Reglas funcionales que condicionan esta pantalla:

- Las listas de antecedentes (OFAC, ONU, UE, etc.) las **provee y carga Systech**. Los bancos (clientes) **no** pueden subir sus propias listas.
- Un servicio **ingestor** (`ms-ingestor`) descarga cada lista desde su URL, la guarda en la base de datos y la mantiene actualizada.
- El **administrador de Systech** puede dar de alta y de baja fuentes de listas. El cliente nunca ve esas acciones.
- Más adelante, cada cliente tendrá un **pack**: conjunto de listas habilitadas más un máximo de consultas.

## 2. Qué se implementó

### Pantalla `/list` (Listas)

- Tabla del catálogo con: fuente, jurisdicción, objetivos, total procesado, última actualización y estado (Activa, Pendiente, Error).
- **Agregar fuente:** botón que abre un formulario con nombre, jurisdicción y URL de descarga. La URL debe ser `https` válida. La fuente nueva queda en estado *Pendiente* hasta que el ingestor la cargue.
- **Eliminar fuente:** ícono de papelera por fila, con diálogo de confirmación.
- Aviso permanente: las cifras no deben sumarse entre listas (hay duplicados entre jurisdicciones) y provienen de OpenSanctions, no de certificaciones oficiales.
- Estados de carga y de error de la lista.

### Modelos de dominio

- `ListaSource`: fuente de lista (id, nombre, jurisdicción, objetivos, total procesado, última actualización, estado, URL de descarga).
- `Pack`: nombre, IDs de listas habilitadas y máximo de consultas. *(Definido; todavía sin pantalla.)*
- `Cliente`: nombre, activo, pack asignado y consultas usadas. *(Definido; todavía sin pantalla.)*

### Capa de datos

- `ListasRepository` (interfaz): `obtenerListas`, `agregarLista`, `eliminarLista`.
- `ListasMockRepository`: implementación en memoria con datos de ejemplo. Los cambios se pierden al recargar.

## 3. Estructura de archivos

```
lib/
├── domain/models/
│   ├── lista_source.dart
│   ├── pack.dart
│   └── cliente.dart
├── data/repositories/
│   └── listas_repository.dart      # interfaz + mock
└── presentation/screens/
    └── listas_screen.dart          # pantalla /list
```

El router y el sidebar no se modificaron: `/list` ya estaba conectado a `ListScreen`.

## 4. Decisiones de diseño

- **Catálogo sin carga por parte del cliente.** Respeta la aclaración funcional: solo Systech provee listas.
- **Repositorio como interfaz.** La pantalla solo pide "dame las listas". Cambiar de datos de ejemplo a backend real no obliga a tocar la tabla, los formularios ni los modelos.
- **Datos de ejemplo basados en el catálogo técnico de Systech** (corte 16/10/2026; Australia, 07/10). Suiza (SECO) aparece como "Sin cifra validada", igual que en el documento.
- **Objetivos vs. total.** «Objetivos» son los sujetos sancionados; «Total» incluye domicilios y otros objetos auxiliares. No equivalen a filas del archivo original.

## 5. Cómo reemplazar los datos de ejemplo por el backend real

1. Obtener del equipo de backend: URL base, endpoint y formato JSON del catálogo, y cómo se da de alta y de baja una fuente.
2. Agregar el paquete `http` al `pubspec.yaml`.
3. Crear `ListasHttpRepository implements ListasRepository` que llame a los endpoints y convierta el JSON en `ListaSource`.
4. En `listas_screen.dart`, cambiar `ListasMockRepository()` por `ListasHttpRepository()` (línea marcada con `TODO`).

Requisitos del lado del backend y de la integración:

- **Autenticación:** login contra `ms-authenticator` y envío del JWT en la cabecera `Authorization: Bearer <token>` en cada llamada. Hoy el login del front solo navega a `/client`.
- **CORS y HTTPS:** los servicios usan HTTPS con certificado propio; si el front corre en navegador, el backend debe permitir CORS y el navegador debe confiar en el certificado.

## 6. Pendientes y limitaciones conocidas

- **Rol administrador:** el botón *Agregar fuente* y la papelera se muestran siempre. Hay que mostrarlos solo al administrador cuando exista el login real con roles (`TODO` en el código).
- **Backend:** no existe todavía un endpoint confirmado para listar fuentes con su estado ni para dar de alta y de baja.
- **Eliminar una fuente usada por un pack:** definir si se bloquea el borrado o se quita de los packs automáticamente.
- **Pantalla de packs:** administración de packs, asignación a clientes e indicador de consumo (por ejemplo 3.200 / 10.000), integrándose con `ms-biller`.
- **Control de acceso y límites de consulta:** la cadena cliente activo → lista habilitada → consultas disponibles → descontar consumo es lógica de backend. El front solo mostrará estado, consumo y errores.

## 7. Cómo probar

```
flutter pub get
flutter analyze
flutter run -d chrome
```

Ir a **Listas** desde el sidebar y verificar: tabla con 8 filas, aviso amarillo, "Sin cifra validada" en SECO, alta de una fuente (aparece como Pendiente) y baja con confirmación.

## 8. Fuentes de las cifras

Catálogo técnico de listas internacionales de Systech (corte 16/10/2026). Cifras de OpenSanctions, no oficiales. No sumar objetivos entre listas.
