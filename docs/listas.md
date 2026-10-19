# Catálogo de listas

La pantalla `/list` muestra en modo de solo lectura las listas de antecedentes provistas y mantenidas por Systech mediante el ingestor. Los bancos no cargan listas.

## Estructura

- `lib/domain/models/`: modelos `ListaSource`, `Pack` y `Cliente`.
- `lib/data/repositories/`: contrato `ListasRepository` e implementación mock.
- `lib/presentation/screens/`: pantalla de catálogo `listas_screen.dart`.

## Conexión con el backend

Implementar `ListasRepository` para obtener el catálogo desde el backend y reemplazar la instancia `ListasMockRepository` por esa implementación en `listas_screen.dart`.

## Fuente de cifras

Los datos mock reflejan el catálogo técnico de Systech con corte al 16/10/2026 (Australia: 07/10/2026). Las cifras provienen de OpenSanctions y no son oficiales. No deben sumarse objetivos entre listas, porque existen duplicados entre jurisdicciones.
