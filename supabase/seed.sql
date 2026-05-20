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

-- 3. Insertar Platos de Alérgenos Iniciales (Deduplicados y Normalizados)
INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Sándwiches', 'Mixto', 'pan de molde, mantequilla, jamón york y queso, patata frita, barbacoa y ranchera', '3,5,11,14', 'lácteos y cereales con gluten, sulfito y mostaza', '', 'A la plancha con mantequilla', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Sándwiches', 'Vegetal', 'Zanahoria, cebolla roja, mango, tomate, pepino, lechuga y huevo duro, mantequilla, patata frita, barbacoa y ranchera', '3,5,7,11,14', 'cereales con gluten, huevo, lácteos, mostaza y sulfitos', '', 'Pan caliente plancha con toda la verdura en frío', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Sándwiches', 'Club', 'pan de cristal, pollo, bacón, jamón york, queso, mahonesa, huevo, lechuga y tomate, patata frita, barbacoa y ranchera', '3,5,7,11,14', 'lácteos, cereales con gluten, huevo, mostaza y sulfitos', '', 'Pan al horno, pollo, bacón, jamón york y queso a la plancha, lechuga y tomate en frío', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Sándwiches', 'Club salmón', 'Salmón ahumado, aguacate, tomate, cebolla roja, lechuga y mostaza y miel, patatas fritas, barbacoa y ranchera', '1,3,5,7,11,14', 'pescado, lácteos, cereales con gluten, huevo, mostaza y sulfitos', '', 'Pan caliente al horno, verduras y salmón en frío', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Sándwiches', 'Frío de queso y nuez', 'pan de molde, queso de untar y nuez, patata frita, mostaza, barbacoa y ranchera', '3,5,11,14', 'lácteos y cereales con gluten, mostaza y sulfitos', '', 'Pan caliente al horno, resto en frío', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Sándwiches', 'Caliente de pollo', 'Pollo, bacón, lechuga, huevo y parmesano con salsa, patata frita, mostaza, barbacoa y ranchera', '3,5,7,11,14', 'lácteos, cereales con gluten y huevo', '', 'Pan caliente en horno, bacón, huevo en plancha, lechuga y queso en frío', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Hamburguesas', 'Vaca gallega', 'Bacon, queso cheddar, cebolla, lechuga, tomate y piquillo, patata frita, barbacoa y ranchera', '3,5,11,14', 'lácteos y cereales con gluten, mostaza y sulfitos', '', 'Pan caliente, carne a la plancha con resto de ingredientes', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Hamburguesas', 'Pollo', 'Queso, cebolla frita, tomate, huevo frito y bacón, patata frita, barbacoa y ranchera', '3,5,11,14', 'lácteos y cereales con gluten, mostaza y sulfitos', '', 'Pan caliente, carne a la plancha con resto de ingredientes', 'Revisar: aparece huevo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Hamburguesas', 'Ibérica', 'Tomate casé, queso manchego, cebolla caramelizada y láminas de torreznos, patata frita, barbacoa y ranchera', '3,5,11,14', 'lácteos y cereales con gluten, mostaza y sulfitos', '', 'Pan caliente, carne a la plancha con resto de ingredientes', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Hamburguesas', 'Vegetal', 'Tofu, tomate casé, cebolla caramelizada y pimiento asado', '3,5,11,14', 'lácteos y cereales con gluten', '', 'Pan caliente, tofu a la plancha con resto de ingredientes', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Tostas', 'Matrimonio', 'Boquerón en vinagre, anchoa y salmorejo, patata frita', '1,3,5,7,14', 'pescado, lácteos, cereales con gluten, huevo y sulfitos', '', 'En rodaja de pan payes, salmorejo encima y resto en frío', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Tostas', 'Jamón ibérico', 'Jamón ibérico, tomate y aceite', '5', 'cereales con gluten', '', 'Tostada de pan con tomate rallado y resto encima', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Tostas', 'Vegetariana', 'tosta pan, verduras a la parrilla gratinadas con queso emmental, patata frita', '3,5', 'cereales con gluten y lácteos', '', 'Sobre tosta de pan caliente, verduras a la plancha y queso gratinado', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Tostas', 'Boloñesa', 'tosta de pan, tomate frito, boloñesa y queso gratinado, patata frita', '3,5,14', 'cereales con gluten, lácteos y sulfitos', '', 'Sobre tosta de pan caliente, tomate frito, carne cerdo y ternera a la plancha, y queso rallado gratinado', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bocadillos', 'Serranito', 'Pan bocadillo, jamón serrano, lomo de cerdo, tomate y pimiento verde frito, patata frita, barbacoa y ranchera', '5,11,14', 'cereales con gluten, sulfitos y mostaza', '', 'En pan de bocadillo, base de tomate, lomo cerdo a la plancha, pimiento frito, y loncha de jamón a la plancha', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bocadillos', 'Francesa al gusto', 'huevo, jamón york y queso, atún o chorizo, patata frita, barbacoa y ranchera', '1,3,5,7,11,14', 'lácteos, cereales con gluten y huevo, pescado, mostaza y sulfitos', '', 'En pan bocadillo, tortilla al gusto, servida al momento, huevo a 70 grados 2 min', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bocadillos', 'Pepito de ternera', 'Bistec, pimiento verde frito y queso cheddar, patata frita, barbacoa y ranchera', '3,5,11,14', 'lácteos y cereales con gluten, mostaza y sulfitos', '', 'En pan bocadillo caliente, carne a la plancha, con queso y pimientos fritos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bocadillos', 'Calamares', 'Chipirón frito, pimiento de padrón y alioli de cítricos, harina, pan rallado, patata frita, barbacoa y ranchera', '3,4,5,7,11,14', 'Lácteos, molusco, cereales con gluten y huevo', '', 'En pan de bocadillo caliente, chipirón frito, pimiento frito y alioli', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Pizzas / Pan pizzas', 'Vegana', 'pan pizza, tomate, queso y verduras, patatas fritas', '3,5,11', 'lácteos y cereales con gluten, mostaza', '', 'horno a 180 grados 15 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Pizzas / Pan pizzas', 'Jamón york y queso', 'pan pizza, tomate, queso, jamón york, patatas fritas', '3,5,7,9,11', 'lácteos y cereales con gluten, soja, mostaza y huevo', '', 'horno a 180 grados 15 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Pizzas / Pan pizzas', 'Barbacoa', 'pan pizza, tomate, queso, jamón york, salsa barbacoa y carne picada, patatas fritas', '3,5,7,9,10,14', 'cereales con gluten, lácteos, huevo, apio, soja, y sulfitos', '', 'horno a 180 grados 15 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Pizzas / Pan pizzas', 'Bacon', 'pan pizza, tomate, queso, jamón york, y bacón, patatas fritas', '3,5,7,9,11,14', 'lácteos, cereales con gluten y sulfitos, soja, mostaza y huevo', '', 'horno a 180 grados 15 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bowls', 'Vegetal', 'Espaguetis de calabacín, champiñón, zanahoria, cebollas crujientes, ajetes y arroz sushi con salsa hoisin)', '14', 'sulfitos', '', 'Verdura salteada en sartén, arroz cocido 12 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bowls', 'Pollo', 'Contramuslo de pollo asado, arroz, patatas dado, champiñón, huevo, berenjena y salsa de mojo picón', '7,14', 'huevo, y sulfitos', '', 'Verdura salteada en sartén, arroz cocido 12 minutos, pollo asado 160 grados 1 hora, 74 grados en interior', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Bowls', 'Salmón', 'Dados de salmón, aguacate, cherrys, mango, pepino, arroz sushi y sweet chili)', '1,14', 'pescado y sulfitos', '', 'Verdura en crudo, arroz cocido 12 minutos, salmón maridado en dados', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Platos combinados', 'Huevos fritos con pisto y bacalao frito', 'huevos, tomate, pimiento y bacalao', '1,5,7', 'pescado, cereales con gluten y huevo', '', 'huevo frito a 110 grados 2 minutos, verduras cocidas 84 grados 16 minutos, bacalao frito 170 grados', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Platos combinados', 'Pechuga de pollo, tortilla, patatas y barbacoa y ensalada', 'pollo, huevo, patata, tomate, lechuga y huevo', '7,14', 'huevo y sulfitos', '', 'Pollo a la plancha, tortilla francesa elaborada al momento 80 grados 2 minutos, verduras en crudo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Platos combinados', 'Entrecot con huevo frito, patatas y asadillo casero', 'entrecot de vaca, huevo, patata y pimientos', '7,14', 'huevo y sulfitos', '', 'carne a la plancha, huevo frito 2 min 80 grados, patata frita 5 min 160 grados', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Platos combinados', 'Mini cachopo, patatas y huevo', 'carne empanada, pan rallado, jamon, queso, patata y huevo', '3,5,7', 'lácteos, cereales con gluten y huevo', '', 'carne rellena de jamón, empanada en harina y huevo, frita a 180 grados 4 minutos, interior carne 74 grados, huevo frito 80 grados 2 minutos, patata frita 5 minutos 160 grado,', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Jamón ibérico con pan y tomate', 'Jamón, pan y tomate', '5', 'cereales con gluten', '', 'jamón curado, con tomate natural untado en pan', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Queso manchego curado', 'queso manchego curado', '3,7', 'lácteos, huevo', '', 'queso curado', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Gamba blanca gigante a la plancha o hervida', 'gamba', '6', 'crustáceos', '', 'gamba plancha 70 grados interior 2 min, gamba cocida 100 grados 2 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Lomo de anchoa del cantábrico, pimiento asado y crema de tomate aliñado', 'anchoa en aceite, pimiento rojo asado, tomate y aceite', '1,14', 'pescado y sulfitos', '', 'pimiento asado 160 grados 8 minutos, resto en crudo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Ensalada de quesos en texturas, pétalos de tomate y vinagreta de miel', 'queso semi, queso fresco, queso empanado, piñones, vinagre y aceite de oliva', '3,5,14', 'lácteos, cereales con gluten y sulfitos', '', 'sin elaboración, variedad quesos curados y crudos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Tomate gourmet con ventresca y cebolla morada', 'Tomate, ventresca de atún y aceite', '1,14', 'pescado y sulfitos', '', 'tomate en crudo, lavado y cortado, ventresca de conserva, y cebolla en crudo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Parrillada de verduras', 'seta, champiñón, esparrago verde, cebolla, zanahoria, calabacín y berenjena', '14', 'sulfitos', '', 'verduras plancha 8 minutos 80 grados', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Ensalada mixta', 'lechuga, cebolla, tomate, zanahoria, huevo, aceitunas atun', '1,7,14', 'huevo, sulfitos y pescado', '', 'verdura en crudo, lavada y cortada, huevo cocido 5 min 100 grados, atun de conserva', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Ensalada de perdiz en escabeche con pimientos asados', 'perdiz en escabeche, berenjena, mini alcachofa, lechuga y aceite de girasol', '14', 'sulfitos', '', 'perdiz de conservas, emulsión en frio con escabecha de conserva', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Guacamole y nachos', 'aguacate, aceite, totopos trigo, pimienta negra y limón o lima', '5,14', 'cereales con gluten, y sulfitos', '', 'emulsión en frio de aguacate, aceite y lima', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Burrito de pollo y guacamole', 'torta de trigo, relleno de cerdo y verduras, chimichurri y ranchera', '5,7,11,14', 'cereales con gluten y sulfitos, mostaza y huevo', '', 'guiso de carne con verduras 8 min a 60 grados, se enfría a 10 grados en 40 minutos, y se rellenan en tortas', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Pulpo a la brasa con patatas asadas y mojo rojo', 'pulpo, patatas y pimiento rojo y vinagre y pan', '4,5,14', 'molusco, sulfitos y cereales con gluten', '', 'pulpo asado a 120º, 12 minutos, patata asada 10 min horno 160º, pimiento asado 10 min horno 160º', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Boquerones crujientes con mahonesa de cítricos', 'boquerón, panko, harina, huevo, aceite y leche', '1,3,5,7', 'pescado, cereales con gluten huevo y lácteos', '', 'boquerón congelado, descongelación y limpieza, empanado y frito 170º, 5 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Surtido de croquetas caseras', 'jamon, bacalao, carrillera, huevo, pan rallado, leche y harina', '1,3,5,7,11', 'pescado, lácteos, cereales con gluten, huevo y sulfitos', '', 'masa de croqueta frita a 74º, enfriada en 70 minutos a 10º, frita a 170º en 8 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Otras raciones', 'Huevos rotos con patata y jamón', 'huevos, patata, jamón, aceite y sal', '7', 'huevo', '', 'huevos fritos a 84º 5 min, jamón a la plancha y patatas fritas a 80º 5 min', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Menú infantil', 'Hamburguesa infantil, nuggets y patatas', 'hamburguesa, pollo, pan rallado huevo y patata', '5,7', 'cereales con gluten y huevos', '', 'carne a la plancha, pollo frito a 170º 5 minutos, patatas fritas 170º 5 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Menú infantil', 'Pasta con tomate', 'pasta y tomate frito', '5', 'cereales con gluten', '', 'pasta cocida 100º 12 minutos, tomate frito industrial', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Menú infantil', 'Mini pizzas, croquetas de jamón y patatas', 'pizzas, jamon, leche, pan rallado y huevos', '3,5,11', 'cereales con gluten, huevo y lácteos', '', 'horno a 180º 12 minutos, croquetas con masa de mantequilla y leche y harina, frito en sartén, y enfriado en 70 minutos, empanadas con huevo y pan rallado, y fritas a 170º 5 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Postres', 'Cheescake neoyorkino con polvos de cookies y helado de nata', 'crema de queso, nata, azúcar, huevos', '2,3,5,7', 'frutos secos, cereales con gluten, huevo y lácteos', '', 'batir todos los ingredientes, meter a 180º 10 minutos, y luego a 160º 25 minutos, enfriamiento de 60 a 10º, en 90 minutos, porcionamos y congelamos a -18º, caducidad 6 meses.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Postres', 'Tarta de whisky casera flameada', 'leche, gelatina, huevo confitado y wisky', '3,5,11', 'lácteos, cereales con gluten, huevo y sulfitos', '', 'batir todos los ingredientes, meter a 180º 10 minutos, y luego a 160º 25 minutos, enfriamiento de 60 a 10º, en 90 minutos, porcionamos y congelamos a -18º, caducidad 6 meses.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Postres', 'Torrija de Baileys con helado de crema de orujo', 'pan brioche, nata, huevo, leche', '3,5,11', 'lácteos, cereales con gluten, huevo, sulfitos', '', 'Mojar el pan con la leche, nata y baileys a 80º, enfriar de 60 a 10º en 90 minutos, porcionamos y congelamos, caducidad 6 meses. regeneración en sartén con caramelo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cafetería', 'Postres', 'Brownie de caramelo, dulce de leche y crumble de canela', 'chocolate, harina, huevo, mantequilla, leche condensada', '3,5,11', 'lácteos, cereales con gluten, huevo', '', 'batir todos los ingredientes, meter a 180º 10 minutos, y luego a 160º 25 minutos, enfriamiento de 60 a 10º, en 90 minutos, porcionamos y congelamos a -18º, caducidad 6 meses.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Jamón ibérico con pan y tomate', 'Jamón, pan y tomate', '5', 'cereales con gluten', '', 'jamón curado, con tomate natural untado en pan', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Queso manchego curado', 'queso manchego curado', '3,7', 'lácteos, huevo', '', 'queso curado', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Gamba blanca gigante a la plancha o hervida', 'gamba', '6', 'crustáceos', '', 'gamba plancha 70 grados interior 2 min, gamba cocida 100 grados 2 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Lomo de anchoa del cantábrico, pimiento asado y crema de tomate aliñado', 'anchoa en aceite, pimiento rojo asado, tomate y aceite', '1,14', 'pescado y sulfitos', '', 'pimiento asado 160 grados 8 minutos, resto en crudo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Ensalada de quesos en texturas, pétalos de tomate y vinagreta de miel', 'queso semi, queso fresco, queso empanado, piñones, vinagre y aceite de oliva', '3,5,14', 'lácteos, cereales con gluten y sulfitos', '', 'sin elaboración, variedad quesos curados y crudos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Ensalada de perdiz en escabeche con pimientos asados', 'perdiz en escabeche, berenjena, mini alcachofa, lechuga y aceite de girasol', '14', 'sulfitos', '', 'perdiz de conservas, emulsión en frio con escabecha de conserva', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Tomate gourmet con ventresca y cebolla morada', 'Tomate, ventresca de atún y aceite', '1,14', 'pescado y sulfitos', '', 'tomate en crudo, lavado y cortado, ventresca de conserva, y cebolla en crudo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Taco de foie, mermelada de pimientos asados, chutney de piña, mango y brotes', 'hígado de pato, coñac, pimiento rojo, azúcar, piña, mango y canela', '14', 'sulfitos', '', 'se aliña el foie y se moldea, vapor a 90º, temperatura interior 90º, enfriamos de 90 a 10º en 30 minutos en agua y hielo, envasamos, congelamos y caducidad 6 meses. Regeneración en cámara a 4º con caducidad 2 días', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Tataki de atún rojo con costra de sésamo, teriyaki, aceite de trufas y anacardos', 'atun rojo, sésamo, sake, soja, mirimy anacardo', '1,2,9,14', 'pescados, frutos secos, sulfitos y soja', '', 'Cortamos el atún, y congelamos a -20º, regenerar a 50º para consumo inmediato', 'Revisar: aparece sésamo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Mixto de croquetas caseras', 'jamon, bacalao, carrillera, huevo, pan rallado, leche y harina', '1,3,5,7,11', 'pescado, lácteos, cereales con gluten, huevo y sulfitos', '', 'hacer masa de croqueta, en sartén a 74º, enfriada en 70 minutos a 10º, frita a 170º en 8 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Parrillada de verduras', 'seta, champiñón, esparrago verde, cebolla, zanahoria, calabacín y berenjena', '14', 'sulfitos', '', 'verduras plancha 8 minutos 80 grados', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Pulpo a la brasa con patatas asadas y mojo rojo', 'pulpo, patatas y pimiento rojo y vinagre y pan', '4,5,14', 'molusco, sulfitos y cereales con gluten', '', 'pulpo asado a 120º, 12 minutos, patata asada 10 min horno 160º, pimiento asado 10 min horno 160º', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Entretenimientos', 'Boquerones crujientes con mahonesa de cítricos', 'boquerón, panko, harina, huevo, aceite y leche', '1,3,5,7', 'pescado, cereales con gluten huevo y lácteos', '', 'boquerón congelado, descongelación y limpieza, empanado y frito 170º, 5 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Pescados', 'Lomo de lubina con gazpacho malagueño y gambón', 'lubina, pan, aceite, leche y gambón', '1,3,5,6', 'pescado, cereales con gluten, crustáceos y lácteos', '', 'marcar lubina plancha 5 minutos, terminar al horno temperatura interior 70º, emulsionar salsa a 90º consumo inmediato', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Pescados', 'Merluza con mejillón, salsa blanca y noodles de calamar', 'merluza, mejillón, leche harina', '1,3,5,6', 'pescado, cereales con gluten, crustáceos y lácteos', '', 'marcar pescado plancha 5 minutos, terminar al horno temperatura interior 70º, emulsionar salsa a 90º consumo inmediato', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Pescados', 'Tronco de bacalao asado con velo de tocino ibérico, pil-pil de pisto y crujiente de puerro', 'bacalao, tocino y puerro, verduras y tomate', '1,5,14', 'pescado y sulfitos, cereales con gluten', '', 'confitar pescado a 65º 15 minutos, temperatura interior 70º, emulsionar pisto a 85º y tapar al momento', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Pescados', 'Salmón con cítricos y espaguetis de calabacín al wok', 'salmón, naranja, nata y verduras', '1,3,14', 'pescado, lácteos y sulfitos', '', 'cocer naranja con nata a 90º 40 minutos, marcar pescado en plancha a 70º interior y servir al momento con salsa', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Pescados', 'Nuestro arroz con bogavante', 'arroz, bogavante, verduras y almejas', '1,4,6', 'pescado, moluscos y crustáceos', '', 'hacer caldo cocido con las verduras, y pescados varios 20 minutos a 90º, enfriar en 105 minutos de 60º a 10º, saltear marisco, añadimos arroz y cocemos en su caldo 14 minutos a 90º, servir al momento', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Carnes', 'Fricando de carrillera de ternera, patata provenzal y polvo de ibéricos', 'carrillera de ternera, verduras, vino tinto, patata', '14', 'sulfitos', '', 'confitar carrilladas con vino, 40 horas a 85º, enfriar en 20 minutos en agua y hielo, regenerar a 90º vapor 15 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Carnes', 'Cochinillo asado crujiente, patata y manzana asada', 'cochinillo, aceite y manzana, patata, sal y agua', '', '', '', 'confitar el cochinillo a 100º en vapor a 2,30 horas, patata asada a 120º 45 minutos, manzana asada a 120º 40 minutos, regeneración a 215º 22 minutos', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Carnes', 'Cordero asado a baja temperatura con jugo de miel y romero con patata rostí', 'cordero, miel, romero y patatas', '14', 'sulfitos', '', 'confitar el cordero a 100º vapor 2,30 horas, patata asada 120º 45 minutos, mojo picón por encima, regeneración 195º 18 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Carnes', 'Solomillo de añojo con praliné de avellanas y patata chafada', 'solomillo, avellanas, harina y nata, patata', '3,5,8', 'cereales con gluten, cacahuetes y lácteos', '', 'marcar solomillo plancha 5 minutos, horno 70º 5 minutos, emulsionar avellana con nata, jugo de carne 74º 8 minutos, salsear y servir', 'Revisar: avellanas deberían figurar como frutos secos.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Carnes', 'Solomillo ibérico, espuma de romesco y crema de vino de la región', 'solomillo, verduras, pan vino y azúcar', '5,14', 'cereales con gluten y sulfitos', '', 'cocer vino 2 horas a 95º, verduras asadas a 120º 6 minutos, marcar solomillo en plancha 5 minutos, terminar en horno 140º 8 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Menú infantil', 'Hamburguesa infantil, nuggets y patatas', 'hamburguesa, pollo, pan rallado huevo y patata', '5,7', 'cereales con gluten y huevos', '', 'carne a la plancha, pollo frito a 170º 5 minutos, patatas fritas 170º 5 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Menú infantil', 'Pasta con tomate', 'pasta y tomate frito', '5', 'cereales con gluten', '', 'pasta cocida 100º 12 minutos, tomate frito industrial', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Menú infantil', 'Mini pizzas, croquetas de jamón y patatas', 'pizzas, jamon, leche, pan rallado y huevos', '3,5,11', 'cereales con gluten, huevo y lácteos', '', 'horno a 180º 12 minutos, croquetas con masa de mantequilla y leche y harina, frito en sartén, y enfriado en 70 minutos, empanadas con huevo y pan rallado, y fritas a 170º 5 minutos', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Postres', 'Cheescake neoyorkino con polvos de cookies y helado de nata', 'crema de queso, nata, azúcar, huevos', '2,3,5,7', 'frutos secos, cereales con gluten, huevo y lácteos', '', 'batir todos los ingredientes, meter a 180º 10 minutos, y luego a 160º 25 minutos, enfriamiento de 60 a 10º, en 90 minutos, porcionamos y congelamos a -18º, caducidad 6 meses.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Postres', 'Tarta de whisky casera flameada', 'leche, gelatina, huevo confitado y wisky', '3,5,11', 'lácteos, cereales con gluten, huevo y sulfitos', '', 'batir todos los ingredientes, meter a 180º 10 minutos, y luego a 160º 25 minutos, enfriamiento de 60 a 10º, en 90 minutos, porcionamos y congelamos a -18º, caducidad 6 meses.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Postres', 'Torrija de Baileys con helado de crema de orujo', 'pan brioche, nata, huevo, leche', '3,5,11', 'lácteos, cereales con gluten, huevo, sulfitos', '', 'Mojar el pan con la leche, nata y baileys a 80º, enfriar de 60 a 10º en 90 minutos, porcionamos y congelamos, caducidad 6 meses. regeneración en sartén con caramelo', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Restaurante', 'Postres', 'Brownie de caramelo, dulce de leche y crumble de canela', 'chocolate, harina, huevo, mantequilla, leche condensada', '3,5,11', 'lácteos, cereales con gluten, huevo', '', 'batir todos los ingredientes, meter a 180º 10 minutos, y luego a 160º 25 minutos, enfriamiento de 60 a 10º, en 90 minutos, porcionamos y congelamos a -18º, caducidad 6 meses. TODOS LOS HELADOS SON INDUSTRIALES NO ELABORADOS', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Arroz a la cubana con tomate frito y huevo', 'arroz, huevo, tomate frito, aceite y sal', '7', 'huevo', '', 'Cocer arroz a 90ºC vapor 20 min. Enfriar en 15 min. Regeneración a 90ºC vapor 6 min. Conservación cámara a 4ºC. Caducidad 5 días. Huevo frito 3 minutos a 90º en sartén, servir al momento.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Pasta con salsa boloñesa', 'pasta, aceite, sal, pimienta negra, queso, salsa boloñesa (cebolla, ajo, aceite, sal, carne ternera y cerdo, tomate y vino tinto)', '3,5,14', 'cereales con gluten, lácteos, sulfitos', '', 'Cocer pasta 20 min 90ºC vapor. Añadir boloñesa. Enfriar en 30 min. Regeneración 90ºC vapor 6 min. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Salteado de verduras con jamón', 'verduras variadas, jamón, aceite y sal', '', '', '', 'Cocer verduras 40 min 90ºC vapor. Enfriar 20 min. Saltear 6 min para regenerar. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Crema de calabacín con quesitos', 'puerro, ajo, aceite, sal, calabacín, nuez moscada y queso fresco', '2,3', 'lácteos, frutos secos', '', 'Cocer todos los ingredientes 20 min 100ºC vapor. Enfriar 1’30 horas. Regenerar a 90ºC vapor 10 min. Conservación en cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Gazpacho con guarnición', 'tomate, pimiento, cebolla, pepino, ajo, aceite, vinagre, sal y agua', '14', 'sulfitos', '', 'Batir todo. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Tortilla de patatas y ensalada', 'patata, huevo, aceite, sal, tomate, lechuga, pepino', '7', 'huevo', '', 'Cuajar tortilla a 73ºC interior. No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Sopa de fideos con jamón', 'caldo jamón, verduras varias, fideos, aceite, sal y jamón', '5', 'cereales con gluten', '', 'Cocer caldo a 100ºC 1’30 horas. Enfriar en 2 horas. Regenerar con los fideos 15 min 100ºC vapor. No conservación después.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Ensalada de espirales de pasta', 'pasta, queso, aceitunas, atún, huevos, pimiento rojo', '1,3,5,7', 'pescado, lácteos, cereales con gluten, huevo', '', 'Cocer pasta 20 min a 100ºC vapor y enfriar en 20 min. Mezclar con el resto. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Paella de verduras con magro de cerdo', 'arroz, pimiento verde y rojo, ajo, tomate, pimentón, carne de cerdo, aceite y sal', '', '', '', 'Guisar 20 min a 100ºC vapor. Enfriar en ½ hora. Regeneración a 140ºC 6 min. Conservación cámara a 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Primeros platos', 'Lasaña de verduras', 'pasta, calabacín, berenjena, pimiento, tomate, leche, harina, nuez moscada', '3,5,8', 'cereales con gluten, lácteos, cacahuetes', '', 'Mezclar y hornear 20 min a 160º seco. Enfriado en 30 min. Regeneración a 140ºC 10 min. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Pechuga de pollo a la plancha con guarnición', 'pollo, aceite, patatas y sal', '', '', '', 'Asar a 170ºC hasta 74ºC interior. No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Muslo de pollo asado con guarnición', 'pollo, limón, aceite, sal y hierbas aromáticas', '', '', '', 'Asar a 160ºC 40 min y luego a 180ºC 20 min. Enfriar a 10ºC en 1’30 horas. Regenerar a 160ºC 10 min (74ºC interior). Conservar en cámara 4ºC. Caducidad 2 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Cinta de lomo asado con guarnición', 'lomo de cerdo, aceite, sal, hierbas aromáticas', '', '', '', 'Asar a 170ºC hasta 74ºC interior. Enfriar a 10ºC en 40 min. Regenerar a 130ºC 10 min. Conservar en cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Emperador a la plancha con guarnición', 'pescado, aceite, sal', '1', 'pescado', '', 'Asar a 150ºC 6 min por cada lado (73ºC interior). No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Bistec de ternera con guarnición', 'ternera, aceite, pimienta y sal', '', '', '', 'Asar a 150ºC 6 min por cada lado (73ºC interior). No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Salmón a la plancha con guarnición', 'pescado, aceite y sal', '1', 'pescado', '', 'Asar a 180ºC con sonda hasta 73ºC interior. No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Ragú de pollo', 'patata, cebolla, ajo, zanahoria, hierbas aromáticas, vino, tomate frito, carne de pollo', '2,14', 'sulfitos, frutos secos', '', 'Guisar el pollo a 95ºC vapor 40 min. Enfriar en 2 horas. Regenerar a 90ºC vapor 10 min. Conservación en cámara a 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Segundos platos', 'Atún a la plancha con tomate frito y guarnición', 'atún, aceite, sal, tomate frito', '1', 'pescado', '', 'Asar atún a 130ºC hasta 73ºC interior. Cocer patatas a vapor 100ºC una hora. No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Patatas panaderas', 'patata, aceite, vino blanco y sal', '14', 'sulfitos', '', 'Cocer patatas a 100ºC vapor 1 h. Enfriar en 50 min. Regenerar a 150ºC 20 min. Conservar en cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Patatas asadas y chafadas', 'patata, aceite y sal', '', '', '', 'Patata asada al horno 120ºC 18 min.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Puré de patatas', 'patata, aceite, sal', '', '', '', 'Cocer patatas a 100ºC vapor 1 h. Triturar. Enfriar en 40 min. Regenerar a 100ºC vapor 10 min. Conservar cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Champiñones salteados con jamón', 'champiñón, aceite, ajo, perejil y jamón', '', '', '', 'Saltear a 120ºC 15 min. No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Pimientos asados', 'pimientos, aceite y sal', '', '', '', 'Asar a 180ºC 40 min. Enfriar en 1 hora. Regenerar a 100ºC 10 min. Conservación en cámara a 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Espárragos al horno', 'espárragos, aceite y sal', '', '', '', 'Asar a 180ºC 30 min. No regeneración. No conservación.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Guarniciones', 'Hummus de guisante', 'guisantes, garbanzos, aceite, comino, ajo, sal, pimienta negra, semillas sésamo, limón', '12,14', 'sésamo, sulfitos', '', 'Cocer todo 20 min a 100ºC vapor. Triturar. Enfriar en 1’30 horas a 10ºC. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Flan casero', 'azúcar, leche, huevo (ovo producto)', '3,7', 'lácteos, huevo', '', 'Cocer a 90ºC vapor 45 min (73ºC interior). Enfriar en 1’45 horas a 10ºC. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Crema de vainilla', 'azúcar, leche, huevo, vainilla (ovo producto)', '3,7', 'lácteos, huevo', '', 'Cuajar la crema a 86ºC 5 min. Enfriar en 1’30 horas a 10ºC. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Fruta entera', 'fruta variada', '', '', '', 'Servir lavada.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Gelatinas sin azúcar', 'zumo de fruta, gelatina y fruta', '', '', '', 'Cuajar la gelatina. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Pannacotta', 'azúcar, nata, vainilla, hojas gelatina', '3', 'lácteos', '', 'Cocer nata a 90ºC y gelatinizar. Enfriar hasta 10ºC en 40 min. Conservación cámara 4ºC. Caducidad 5 días.', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Yogurt', 'según etiqueta', '3', 'lácteos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menú Deportivo', 'Postres', 'Vasitos de fruta preparada', 'fruta variada', '6', 'Crustáceos', '', 'Pelar y cortar fruta en vasito. Caducidad 4 horas', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Cóctel Nº 1', 'JAMON IBERICO CON REGAÑAS', 'JAMON IBERICO Y REGAÑAS', '', 'CEREALES CON GLUTEN', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'QUESO MANCHEGO D.O.', 'QUESO MANCHEGO', '', 'LACTEOS', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'MINI BURGER DE BUEY', 'CARNE PICADA, AJO EN POLVO, PIMIENTA, KETCHUP, PAN DE HAMBURGUESA', '', 'SULFITOS, LACTEOS, CEREALES CON GLUTEN', '', 'COCCION A 140º 10 MINUTOS HASTA 73 EN INTERIOR REGENERACION A 90º CINCO MINUTOS, NO CONSERVACION', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'CROQUETAS DE JAMÓN', 'JAMON PICADO,LECHE,HARINA,NUEZ MOSCASA,SAL Y PIMIENTA', '', 'LACTEOS,CEREALES CON GLUTEN,FRUTOS SECOS', '', 'FRITURA A 170 º CINCO MINUTOS NO REGENERACION CONSERVACION A -18º EN CAMARA', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'NIDO DE PATATAS Y LANGOSTINOS', 'PATATAS, LANGOSTINOS,LECHE HARINA', '', 'MOLUSCOS,CEREALES CON GLUTEN,SULFITOS', '', 'REGENERACION A 180º DIEZ MINUTOS', 'Revisar: aparece leche en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'CUCURUCHO DE PATE DE MEJILLONES EN ESCABECHE', 'HOJALDRE,QUESO CREMA, MEJILLONES EN ESCABECHE', '', 'PESCADOS DE CONCHA,LACTEOS,CEREALES CON GLUTEN,HUEVO,SULFITOS', '', 'NO REGENERACION, CONSERVACION EN CAMARA DOS DIAS', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'MARINERA DE ENSALADILLA Y ANCHOAS', 'PAN,VERDURAS,ATUN,HUEVO,MAHONESA, ANCHOAS', '', 'CEREALES CON GLUTEN,PESCADO,HUEVOS,LACTEOS Y SULFITOS', '', 'NO REGENERACION,CONSERVACION EN CAMARA Y CADUCIDAD CINCO DIAS', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'TIRAS DE POLLO KENTUCKY CON CHIMICHURRI', 'PANKO,HUEVO,CURRY,ENELDO,TOMILLO,HARINA,POLLO', '', 'HUEVOS,LACTEOS,CEREALES CON GLUTEN Y SULFITOS', '', 'FRITURA A 170º CINCO MINUTOS,NO REGENERACION Y CONSERVACION A -18º CON CADUCIDAD DE SEIS MESES', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'TORTILLITAS DE CAMARON CON PIMIENTOS DE PADRON', 'HUEVOS,HARINA DE GARBANZOS, CEBOLLETA', '', 'HUEVOS Y SULFITOS', '', 'FRITURA A 170º SEIS MINUTOS,NO REGENERACION, NO CONSERVACION', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'PINCHO DE SALMON, GAMBA Y PIPARRA', 'SALMON MARINADO,PAN CRISTAL,GAMBA COCIDA Y PIPARRA EN VINAGRE', '', 'PESCADOS,MARISCO,CREREALES CON GLUTEN Y SULFITOS CEREALES CON GLUTEN Y SULFITOS', '', 'SERVIDO EN BROCHETA,CONSERVACION EN CAMARA DOS DIAS PATATAS CHIPS Y ACEITUNAS ENCURTIDAS CONSEVACION EN CAMARA TRES DIAS UNA VEZ ABIERTAS', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'PASTELITOS VARIADOS', 'HUEVO,HARNA ,AZUCAR,GLUCOSA,LACTEOS, CHOCOLATE', '', 'HUEVO,LACTEOS,CEREALES CON GLUTEN,SULFITOS', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Cóctel Nº 2', 'JAMON IBERICO CON REGAÑAS', 'JAMON IBERICO Y REGAÑAS', '', 'CEREALES CON GLUTEN', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'MINI PAN BAO CON SECRETO Y SALSA HOISIN', 'HARINA,AGUA,LEVADURA,SECRETO,ALGA WAKAME, SALSA HOISIN(SOJA,SAKE Y MIRIM)', '', 'CEREALES CON GLUTEN,SULFITOS', '', 'VAPOR 10 MINUTOS,NO CONNSERVACION, NO REGENERACION', 'Revisar: aparece soja en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'MEDIASNOCHES DE TERNERA Y SETAS', 'PAN BRIOCHE,TERNERA ASADA Y SETA A LA PLANCHA,SALSA CHUMICHURRI PATATAS CHIPS Y ACEITUNAS ENCURTIDAS', '', 'CEREALES CON GLUTEN Y SULFITOS', '', 'CONSEVACION EN CAMARA TRES DIAS UNA VEZ ABIERTAS', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Cóctel Nº 3', 'JAMON IBERICO CON REGAÑAS', 'JAMON IBERICO Y REGAÑAS', '', 'CEREALES CON GLUTEN', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'BROCHETA DE POLLO TERIYAKI', 'POLLO,SOJA,SAKE,MIRIM', '', 'SULFITOS, SOJA', '', 'NO REGENERACION,NO CONSERVACION,COCCIN 10 MINUTOS 180º', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'MINI FLAMENQUIN CASERO CON ALI OLI', 'LOMO DE CERDO,JAMON SERRANO,HUEVO,PAN RALLADO,LECHE,ACEITE', '', 'HUEVO,CEREALES CON GLUTEN,LACTEOS Y SULFITOS', '', 'FRITURA SEIS MINUTOS A 170º,NO REGENERACION,NO CONSERVACION', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'MINI BURRITOS CON SALSA RANCHERA', 'CARNE DE CERDO, CAJUN,TOMATE,SALSA RANCHERA,TORTITAS DE TRIGO', '', 'CEREALES CON GLUTEN,LACTEOS Y SULFITOS', '', 'HORNEADO A 170º SEIS MINUTOS, NO REGENERACION, NO CONSERVACION', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'EMPANADILLA FRITA DE ATUN', 'MASA DE EMPANADILLAS,ATUN,HUEVO,TOMATE Y PIMIENTO ROJO', '', 'CEREALES CON GLUTEN,HUEVO Y SULFITOS', '', 'FRITURA DE SEIS MINUTOS A 170º,NO REGENERACION, NO CONSERVACION', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'QUESO BRIE EMPANADO CON MAHINESA DE SIRACHA', 'QUESO BRIE,HUEVO,PAN RALLADO,LECHE AJO Y SIRACHA', '', 'LACTEOS,CEREALES CON GLUTEN Y SULFITOS', '', 'FRITO A 170º SEIS MINUTOS, NO REGENERACION, NO CONSERVACION', 'Revisar: aparece huevo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Cócteles', 'Resto de cócteles', 'SWAHUARMA DE POLLO Y ALI OLI DE CILANTRO', 'TORTITA DE TRIGO,CEBOLLA, POLLO, LECHUGA ,CILANTRO, LECHE ,ACEIT Y VINAGRE', '', 'CEREALES CON GLUTEN,LACTEOS Y SULFITOS', '', 'HORNO A 160 SEIS MINUTOS, NO REGENERACION, NO CONSERVACION', '', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Sopa Juliana', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Sopa de picadillo', 'fideos, pollo, apio, zanahorias, huevo, jamón, sal, puerro, agua, aceite y sal', '5,7', 'cereales con gluten, huevo', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Sopa de pescado', 'fideos, pescado, apio, zanahoria, sal, puerro, agua, aceite y hojas aromáticas', '1,5', 'pescado, cereales con gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Crema de mejillón', '', '1,3,5,7,11', 'Pescado, Lácteos, Gluten, Huevos, Mostaza', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Crema reina con pollo y jamón', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Crema de verduras con sus costrones', '', '3,5,7', 'Lácteos, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Sopa de fideos con jamón', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Crema de calabaza con jamón frito y queso', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Judias estofadas', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Patatas guisadas con calamar', '(Tofu, tomate cassé, cebolla caramelizada y pimiento asado)', '3,5', 'lácteos y cereales con gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Cocido madrileño', '', '1,3,5,7,14', 'Pescado, Lácteos, Gluten, Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Potaje de vigilia', '', '5', 'Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Patatas guisadas con ternera', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Judias con perdíz', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Paella mixta', '', '5', 'Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Fideua de ibericos', '', '3,5,7', 'Lácteos, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Arroz a la milanesa', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Arroz caldoso con calamar', '', '1,3,4,5,7', 'Pescado, Lácteos, Moluscos, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Pisto manchego con huevo frito', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Revisar: aparece huevo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Asadillo con huevo y atún', '', '3,5', 'Lácteos, Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Revisar: aparece huevo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Migas manchegas con huevo', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Revisar: aparece huevo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Gazpacho andaluz', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Entremeses variados', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Ensaladilla rusa con salmón', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Ensalada Cesar', '', '1,14', 'Pescado, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Ensalada de tomate, cebolla roja y bonito', '', '1,5,7', 'Pescado, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Carpaccio de tomate, mozzarella y mango', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Tallarines boloñesa', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Lasaña de verduras', '', '3,5,7', 'Lácteos, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Macarrones pomodoro', '', '5', 'Gluten', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Tortilla de patatas con ensalada', '', '3', 'Lácteos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Menestra de verduras con ajo y jamón', '', '6', 'Crustáceos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Primeros platos', 'Judias verdes con ensalada', '', '6', 'Crustáceos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Bacalao vizcaina', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Palometa con tomate', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Rollitos de lenguado al limón', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Merluza romana o salsa verde', '', '1,14', 'Pescado, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Ternera de mar con ajo y perejil', '', '1,5,7', 'Pescado, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Filete de corvina al azafan', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Dorada donostierra', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Bonito en cama de crema de pisto', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Salmón a la naranja', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Albondigas de sepia y gambas', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Jamón de cerdo asado', '', '1,14', 'Pescado, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Ternera braseada con patatas panadera', '', '1,5,7', 'Pescado, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Caldereta de cordero', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Muslo de pollo deshuesado a la brasa', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Cachopo de ternera con jamón y queso', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Pechuguitas de pollo a la pimienta', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Ragu de ternera en salsa de verduras', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Ensalada Cesar', '', '1,14', 'Pescado, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Magro de cerdo con tomate', '', '1,5,7', 'Pescado, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Escalopes de ternera al limón', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Pollo en pepitoria', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Muslo de pollo asado al limón', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Segundos platos', 'Magras con pisto', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Flan casero', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Natillas caseras', '', '1,14', 'Pescado, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Pudin de chocolate', '', '1,5,7', 'Pescado, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Helado de vasito', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Babarois al limón', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Pan de calatrava', '', '3,5,14', 'Lácteos, Gluten, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Vasito mouse de fresa', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Vasito mouse chocolate y nata', '', '14', 'Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Tarta de queso y frutos rojos', '', '1,14', 'Pescado, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Arroz con leche', '', '1,5,7', 'Pescado, Gluten, Huevos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Revisar: aparece leche en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Menús de Grupo', 'Postres', 'Tarta de la casa', '', '7,14', 'Huevos, Sulfitos', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Bollería', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Donuts', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Bizcocho', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Paté', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Mantequilla', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Mermelada', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Cereales', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Yogurt', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Leche de soja', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven. Revisar: aparece leche en ingredientes. Revisar: aparece soja en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'ColaCao', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pan', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pan de molde', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pan integral', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pan artis', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Huevos fritos', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven. Revisar: aparece huevo en ingredientes.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Beicon', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Sandwich mixto', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Chorizo, salchichón, salami', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Jamón bodega', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'York', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pavo', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Mortadela', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Mortadela aceitunas', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Empanada de Atún', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tortilla de Patatas', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarta de Queso', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarta de Galleta', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarta de Chocolate Sacher', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarta Red Velvet', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarta San Marcos', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pepito Crema', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Pepito Chocolate', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Zumo', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Miel', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Membrillo', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Mostillo', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarrina Tomate', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarrina Paté', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarrina jamón / york / serrano', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Tarrina Cachuela', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Queso Fresco', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Queso Semi', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

INSERT INTO public.food_items (area, category, name, ingredients, allergen_codes, allergens, traces, preparation, supplier_notes, status)
VALUES ('Desayuno Buffet', 'Desayuno Buffet', 'Queso gouda', '', '', '', '', '', 'Pendiente de completar ingredientes/alérgenos/elaboración. Pendiente completar ingredientes, alérgenos, proveedor y posibles trazas. Incluir tortilla nueva y gofres si se sirven.', 'pendiente')
ON CONFLICT (area, category, name) 
DO UPDATE SET 
  ingredients = EXCLUDED.ingredients,
  allergen_codes = EXCLUDED.allergen_codes,
  allergens = EXCLUDED.allergens,
  traces = EXCLUDED.traces,
  preparation = EXCLUDED.preparation,
  supplier_notes = EXCLUDED.supplier_notes,
  status = EXCLUDED.status;

