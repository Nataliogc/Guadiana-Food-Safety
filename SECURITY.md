# Seguridad

## Reglas básicas

1. No subir nunca claves privadas ni `service_role key` de Supabase.
2. Mantener Row Level Security activado en todas las tablas.
3. Crear usuarios individuales; no compartir contraseña.
4. Asignar roles mínimos: viewer, editor o admin.
5. Si el repositorio es público, no subir datos sensibles de proveedores ni documentación privada.
6. Revisar periódicamente la tabla `audit_log`.
7. Dar de baja usuarios que ya no deban acceder.

## Recomendación operativa

Para uso real del hotel, se recomienda repositorio privado y Supabase con acceso restringido por usuarios autenticados.
