-- =====================================================================
-- Plan de Gestión de Alérgenos "Food Safety" · Hotel Guadiana
-- Script de Carga de Datos Iniciales (Seed) Seguro y No Destructivo
-- =====================================================================

-- 1. Insertar Proveedores de Ejemplo (si no existen)
INSERT INTO public.suppliers (id, name, phone, email, products, technical_sheet_available, notes)
VALUES 
  ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Distribuciones La Mancha', '926112233', 'contacto@distribucioneslamancha.com', 'Harinas, aceites, azúcar, legumbres y productos de panadería', true, 'Proveedor principal de materias primas no perecederas.'),
  ('b2c3d4e5-f67a-8b9c-0d1e-2f3a4b5c6d7e', 'Pescados El Cantábrico', '926445566', 'pedidos@pescadoselcantabrico.es', 'Pescado fresco, mariscos, pulpo y congelados marinos', true, 'Entregas martes y viernes a las 7:00 AM.'),
  ('c3d4e5f6-7a8b-9c0d-1e2f-3a4b5c6d7e8f', 'Carnes Guadiana', '926778899', 'admin@carnesguadiana.com', 'Ternera gallega, cerdo ibérico, pollo y embutidos locales', false, 'Ficha técnica pendiente de actualizar por cambio de etiquetado en el proveedor.')
ON CONFLICT (id) DO NOTHING;

-- 2. Insertar Tareas Iniciales (si no existen)
INSERT INTO public.tasks (id, title, description, area, priority, status, assigned_to, due_date)
VALUES
  ('d4e5f67a-8b9c-0d1e-2f3a-4b5c6d7e8f9a', 'Completar alérgenos de Desayuno Buffet', 'Revisar ingredientes, trazas y alérgenos de gofres, bollería, panes y fiambres envasados.', 'Desayuno Buffet', 'alta', 'pendiente', 'Equipo Cocina', CURRENT_DATE + 3),
  ('e5f67a8b-9c0d-1e2f-3a4b-5c6d7e8f9a0b', 'Solicitar ficha técnica a Carnes Guadiana', 'Contactar por email o teléfono para obtener la ficha técnica actualizada de los embutidos.', 'Compras', 'critica', 'pendiente', 'Natalio Fernández', CURRENT_DATE + 1),
  ('f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c', 'Revisión técnica de tapas de cafetería', 'Revisar y verificar los alérgenos y trazas con el chef Luengo.', 'Cafetería', 'media', 'en_proceso', 'Sergio Luengo', CURRENT_DATE + 7)
ON CONFLICT (id) DO NOTHING;
