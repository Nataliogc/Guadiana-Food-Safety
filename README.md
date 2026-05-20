# Food Safety · Plan de Gestión de Alérgenos · Hotel Guadiana

Aplicación web profesional para la gestión del Plan de Alérgenos, ingredientes, proveedores y tareas del Hotel Guadiana, conectada a una base de datos en tiempo real mediante **Supabase**.

## Stack Tecnológico

- **Frontend**: React + Vite + TypeScript
- **Backend/DB**: Supabase (PostgreSQL) con políticas RLS (Row Level Security) activas
- **Estilos**: CSS moderno, responsivo y adaptado para impresión oficial (Sanidad)

---

## Instrucciones de Instalación y Puesta en Marcha

Sigue estos pasos en orden para configurar el proyecto con Supabase:

### 1. Inicializar la Base de Datos
1. Inicia sesión en tu panel de control de [Supabase](https://supabase.com).
2. Crea un nuevo proyecto.
3. Ve a la sección **SQL Editor** y ejecuta por completo el contenido del archivo:
   - [supabase/schema.sql](file:///supabase/schema.sql)
4. (Opcional) Ejecuta el archivo [supabase/seed.sql](file:///supabase/seed.sql) para cargar datos de prueba iniciales de proveedores y tareas.

### 2. Crear el Usuario e Iniciar Sesión
1. Inicia la aplicación localmente (ver instrucciones abajo) o accede al despliegue.
2. Haz clic en **Crear nueva cuenta** en la pantalla de login.
3. Regístrate con el correo electrónico correspondiente.

### 3. Convertir el Usuario en Administrador (Admin)
Por seguridad, los nuevos usuarios creados se registran por defecto con el rol de `consulta` (solo lectura). Para elevar tu usuario al rol de administrador, ejecuta la siguiente consulta en el **SQL Editor** de Supabase:

```sql
update profiles
set role = 'admin', full_name = 'Natalio Fernández'
where email = 'comunicaciones@hotelguadiana.es';
```

*Nota: Si aún no has creado la cuenta en Supabase Auth, hazlo primero en la aplicación y luego ejecuta esta consulta.*

### 4. Configurar Variables de Entorno en Local
Crea un archivo `.env` en la raíz del proyecto (basándote en `.env.example`) con las claves públicas de tu Supabase:

```env
VITE_SUPABASE_URL=https://kihqiclsrfeqgexshnho.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_iugBgqQ9BFKb-RSjJ9ezjQ_cJ1wkjvg
```

> [!WARNING]
> **SEGURIDAD**: Nunca subas el archivo `.env` a GitHub. Está incluido por defecto en `.gitignore`. No compartas ni utilices nunca la clave `service_role` en el frontend del cliente.

---

## Cómo Ejecutar en Local

Asegúrate de tener [Node.js](https://nodejs.org) instalado, luego ejecuta en tu terminal:

1. **Instalar Dependencias**:
   ```bash
   npm install
   ```
2. **Arrancar Servidor de Desarrollo**:
   ```bash
   npm run dev
   ```
   Abre [http://localhost:5173](http://localhost:5173) en tu navegador.
3. **Compilar para Producción**:
   ```bash
   npm run build
   ```

---

## Control de Acceso por Roles (RBAC)

La aplicación tiene un control estricto de roles tanto en el frontend como en la base de datos a nivel de registro (RLS):

| Rol | Descripción y Permisos |
| :--- | :--- |
| **`admin`** | Acceso total: Puede crear, editar y eliminar platos/productos, proveedores, tareas y perfiles de usuario. |
| **`cocina`** | Gestión operativa: Puede crear y editar platos/productos, y gestionar tareas pendientes de cocina. |
| **`sala`** | Consulta y servicio: Puede ver platos y proveedores. Puede crear y editar tareas de servicio/sala. |
| **`consulta`** | Solo lectura (por defecto): Útil para que cualquier empleado del hotel consulte alérgenos e ingredientes sin realizar modificaciones accidentales. |

---

## Inspecciones de Sanidad y Exportación

La aplicación está preparada para responder de inmediato ante inspecciones de Sanidad alimentaria:
- **Impresión Profesional**: Al pulsar Ctrl+P o usar el botón "Imprimir", el sistema oculta menús, botones y barras de navegación, formateando la tabla en un documento PDF limpio y formal listo para entregar al inspector.
- **Exportaciones**: Es posible descargar el catálogo al completo en formatos **JSON** (copia de seguridad) y **CSV** (compatible con Excel).
