-- =====================================================================
-- Plan de Gestión de Alérgenos "Food Safety" · Hotel Guadiana
-- Script de Base de Datos Seguro y No Destructivo
-- =====================================================================

-- ---------------------------------------------------------------------
-- PELIGRO: SOLO EJECUTAR EN BASE DE DATOS VACÍA
-- (Descomenta esta sección si deseas limpiar y reiniciar todo)
-- ---------------------------------------------------------------------
/*
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS trg_profiles_updated_at ON public.profiles;
DROP TRIGGER IF EXISTS trg_food_items_updated_at ON public.food_items;
DROP TRIGGER IF EXISTS trg_suppliers_updated_at ON public.suppliers;
DROP TRIGGER IF EXISTS trg_tasks_updated_at ON public.tasks;
DROP TRIGGER IF EXISTS audit_food_items ON public.food_items;
DROP TRIGGER IF EXISTS audit_suppliers ON public.suppliers;
DROP TRIGGER IF EXISTS audit_tasks ON public.tasks;

DROP TABLE IF EXISTS public.audit_log CASCADE;
DROP TABLE IF EXISTS public.tasks CASCADE;
DROP TABLE IF EXISTS public.food_items CASCADE;
DROP TABLE IF EXISTS public.suppliers CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;
*/

-- Activar extensión pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ---------------------------------------------------------------------
-- 1. TABLA: profiles
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text UNIQUE,
  full_name text,
  role text DEFAULT 'consulta',
  created_at timestamptz NOT null DEFAULT now(),
  updated_at timestamptz NOT null DEFAULT now()
);

-- Asegurar columnas si la tabla ya existía
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS full_name text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS role text DEFAULT 'consulta';

-- Agregar restricción de rol si no existe
DO $$
BEGIN
  ALTER TABLE public.profiles ADD CONSTRAINT check_profiles_role CHECK (role IN ('admin', 'cocina', 'sala', 'consulta'));
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- ---------------------------------------------------------------------
-- 2. TABLA: suppliers
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.suppliers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT null,
  phone text,
  email text,
  products text,
  technical_sheet_available boolean NOT null DEFAULT false,
  notes text,
  created_at timestamptz NOT null DEFAULT now(),
  updated_at timestamptz NOT null DEFAULT now()
);

-- Asegurar compatibilidad
ALTER TABLE public.suppliers ADD COLUMN IF NOT EXISTS technical_sheet_available boolean NOT null DEFAULT false;
ALTER TABLE public.suppliers ADD COLUMN IF NOT EXISTS phone text;
ALTER TABLE public.suppliers ADD COLUMN IF NOT EXISTS email text;
ALTER TABLE public.suppliers ADD COLUMN IF NOT EXISTS products text;
ALTER TABLE public.suppliers ADD COLUMN IF NOT EXISTS notes text;

-- ---------------------------------------------------------------------
-- 3. TABLA: food_items
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.food_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  area text,
  category text,
  name text NOT null,
  ingredients text,
  allergen_codes text,
  allergens text,
  traces text,
  preparation text,
  supplier_notes text,
  status text DEFAULT 'pendiente',
  validated_by text,
  validated_at timestamptz,
  created_at timestamptz NOT null DEFAULT now(),
  updated_at timestamptz NOT null DEFAULT now()
);

-- Agregar restricción de estado si no existe
DO $$
BEGIN
  ALTER TABLE public.food_items ADD CONSTRAINT check_food_items_status CHECK (status IN ('pendiente', 'en_revision', 'validado'));
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- Agregar restricción única de platos si no existe
DO $$
BEGIN
  ALTER TABLE public.food_items ADD CONSTRAINT unique_food_item UNIQUE (area, category, name);
EXCEPTION
  WHEN OTHERS THEN NULL;
END $$;


-- ---------------------------------------------------------------------
-- 4. TABLA: tasks
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT null,
  description text,
  area text,
  priority text DEFAULT 'media',
  status text DEFAULT 'pendiente',
  assigned_to text,
  due_date date,
  created_at timestamptz NOT null DEFAULT now(),
  updated_at timestamptz NOT null DEFAULT now()
);

-- Agregar restricciones de prioridad y estado
DO $$
BEGIN
  ALTER TABLE public.tasks ADD CONSTRAINT check_tasks_priority CHECK (priority IN ('baja', 'media', 'alta', 'critica'));
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER TABLE public.tasks ADD CONSTRAINT check_tasks_status CHECK (status IN ('pendiente', 'en_proceso', 'completada'));
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- ---------------------------------------------------------------------
-- 5. TABLA: audit_log
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.audit_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name text,
  record_id uuid,
  action text,
  old_data jsonb,
  new_data jsonb,
  changed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT null DEFAULT now()
);

-- ---------------------------------------------------------------------
-- ÍNDICES (Para mejorar el rendimiento de búsquedas frecuentes)
-- ---------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_food_items_area ON public.food_items(area);
CREATE INDEX IF NOT EXISTS idx_food_items_status ON public.food_items(status);
CREATE INDEX IF NOT EXISTS idx_tasks_priority ON public.tasks(priority);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON public.tasks(status);

-- ---------------------------------------------------------------------
-- FUNCIONES Y TRIGGERS COMUNES
-- ---------------------------------------------------------------------

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  new.updated_at = now();
  RETURN new;
END;
$$;

-- Triggers de updated_at
DROP TRIGGER IF EXISTS trg_profiles_updated_at ON public.profiles;
CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_suppliers_updated_at ON public.suppliers;
CREATE TRIGGER trg_suppliers_updated_at BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_food_items_updated_at ON public.food_items;
CREATE TRIGGER trg_food_items_updated_at BEFORE UPDATE ON public.food_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_tasks_updated_at ON public.tasks;
CREATE TRIGGER trg_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Sincronizar usuarios de Auth con Profiles
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    new.id, 
    new.email, 
    coalesce(new.raw_user_meta_data->>'name', new.email), 
    'consulta' -- Rol inicial seguro por defecto
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Función auxiliar para obtener el rol del usuario actual de manera segura
CREATE OR REPLACE FUNCTION public.current_user_role()
RETURNS text LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT coalesce((SELECT role FROM public.profiles WHERE id = auth.uid()), 'consulta');
$$;

-- Función de auditoría automática
CREATE OR REPLACE FUNCTION public.audit_changes()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF tg_op = 'INSERT' THEN
    INSERT INTO public.audit_log(table_name, record_id, action, changed_by, new_data)
    VALUES (tg_table_name, new.id, tg_op, auth.uid(), to_jsonb(new));
    RETURN new;
  ELSIF tg_op = 'UPDATE' THEN
    INSERT INTO public.audit_log(table_name, record_id, action, changed_by, old_data, new_data)
    VALUES (tg_table_name, new.id, tg_op, auth.uid(), to_jsonb(old), to_jsonb(new));
    RETURN new;
  ELSIF tg_op = 'DELETE' THEN
    INSERT INTO public.audit_log(table_name, record_id, action, changed_by, old_data)
    VALUES (tg_table_name, old.id, tg_op, auth.uid(), to_jsonb(old));
    RETURN old;
  END IF;
  RETURN null;
END;
$$;

DROP TRIGGER IF EXISTS audit_food_items ON public.food_items;
CREATE TRIGGER audit_food_items AFTER INSERT OR UPDATE OR DELETE ON public.food_items FOR EACH ROW EXECUTE FUNCTION public.audit_changes();

DROP TRIGGER IF EXISTS audit_suppliers ON public.suppliers;
CREATE TRIGGER audit_suppliers AFTER INSERT OR UPDATE OR DELETE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.audit_changes();

DROP TRIGGER IF EXISTS audit_tasks ON public.tasks;
CREATE TRIGGER audit_tasks AFTER INSERT OR UPDATE OR DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.audit_changes();

-- ---------------------------------------------------------------------
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- ---------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------
-- POLÍTICAS DE SEGURIDAD (RLS)
-- ---------------------------------------------------------------------

-- POLÍTICAS: profiles
DROP POLICY IF EXISTS "profiles_select_authenticated" ON public.profiles;
CREATE POLICY "profiles_select_authenticated" ON public.profiles 
  FOR SELECT TO authenticated 
  USING (id = auth.uid() OR public.current_user_role() = 'admin');

DROP POLICY IF EXISTS "profiles_update_own_or_admin" ON public.profiles;
CREATE POLICY "profiles_update_own_or_admin" ON public.profiles 
  FOR UPDATE TO authenticated 
  USING (id = auth.uid() OR public.current_user_role() = 'admin') 
  WITH CHECK (
    public.current_user_role() = 'admin' 
    OR (id = auth.uid() AND role = (SELECT role FROM public.profiles WHERE id = auth.uid()))
  );

-- POLÍTICAS: suppliers
DROP POLICY IF EXISTS "suppliers_select_authenticated" ON public.suppliers;
CREATE POLICY "suppliers_select_authenticated" ON public.suppliers 
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "suppliers_insert_admin" ON public.suppliers;
CREATE POLICY "suppliers_insert_admin" ON public.suppliers 
  FOR INSERT TO authenticated 
  WITH CHECK (public.current_user_role() = 'admin');

DROP POLICY IF EXISTS "suppliers_update_admin" ON public.suppliers;
CREATE POLICY "suppliers_update_admin" ON public.suppliers 
  FOR UPDATE TO authenticated 
  USING (public.current_user_role() = 'admin') 
  WITH CHECK (public.current_user_role() = 'admin');

DROP POLICY IF EXISTS "suppliers_delete_admin" ON public.suppliers;
CREATE POLICY "suppliers_delete_admin" ON public.suppliers 
  FOR DELETE TO authenticated 
  USING (public.current_user_role() = 'admin');

-- POLÍTICAS: food_items
DROP POLICY IF EXISTS "food_items_select_authenticated" ON public.food_items;
CREATE POLICY "food_items_select_authenticated" ON public.food_items 
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "food_items_insert_admin_cocina" ON public.food_items;
CREATE POLICY "food_items_insert_admin_cocina" ON public.food_items 
  FOR INSERT TO authenticated 
  WITH CHECK (public.current_user_role() IN ('admin', 'cocina'));

DROP POLICY IF EXISTS "food_items_update_admin_cocina" ON public.food_items;
CREATE POLICY "food_items_update_admin_cocina" ON public.food_items 
  FOR UPDATE TO authenticated 
  USING (public.current_user_role() IN ('admin', 'cocina')) 
  WITH CHECK (public.current_user_role() IN ('admin', 'cocina'));

DROP POLICY IF EXISTS "food_items_delete_admin" ON public.food_items;
CREATE POLICY "food_items_delete_admin" ON public.food_items 
  FOR DELETE TO authenticated 
  USING (public.current_user_role() = 'admin');

-- POLÍTICAS: tasks
DROP POLICY IF EXISTS "tasks_select_authenticated" ON public.tasks;
CREATE POLICY "tasks_select_authenticated" ON public.tasks 
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "tasks_insert_authenticated" ON public.tasks;
CREATE POLICY "tasks_insert_authenticated" ON public.tasks 
  FOR INSERT TO authenticated 
  WITH CHECK (true); -- Cualquier usuario autenticado puede crear tareas

DROP POLICY IF EXISTS "tasks_update_authenticated" ON public.tasks;
CREATE POLICY "tasks_update_authenticated" ON public.tasks 
  FOR UPDATE TO authenticated 
  USING (true)
  WITH CHECK (true); -- Permite actualizar el estado de tareas

DROP POLICY IF EXISTS "tasks_delete_admin" ON public.tasks;
CREATE POLICY "tasks_delete_admin" ON public.tasks 
  FOR DELETE TO authenticated 
  USING (public.current_user_role() = 'admin');

-- POLÍTICAS: audit_log
DROP POLICY IF EXISTS "audit_select_admin" ON public.audit_log;
CREATE POLICY "audit_select_admin" ON public.audit_log 
  FOR SELECT TO authenticated 
  USING (public.current_user_role() = 'admin');

-- ---------------------------------------------------------------------
-- 6. TABLA: generated_reports
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.generated_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  generated_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  generated_at timestamptz NOT NULL DEFAULT now(),
  report_type text NOT NULL,
  filters_used jsonb NOT NULL,
  total_items integer NOT NULL,
  pending_items integer NOT NULL,
  validated_items integer NOT NULL,
  notes text
);

-- Habilitar RLS
ALTER TABLE public.generated_reports ENABLE ROW LEVEL SECURITY;

-- Políticas de RLS para generated_reports
DROP POLICY IF EXISTS "reports_select_admin_cocina" ON public.generated_reports;
CREATE POLICY "reports_select_admin_cocina" ON public.generated_reports
  FOR SELECT TO authenticated
  USING (public.current_user_role() IN ('admin', 'cocina'));

DROP POLICY IF EXISTS "reports_insert_authenticated" ON public.generated_reports;
CREATE POLICY "reports_insert_authenticated" ON public.generated_reports
  FOR INSERT TO authenticated
  WITH CHECK (true);
