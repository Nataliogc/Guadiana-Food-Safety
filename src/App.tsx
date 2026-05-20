import React, { useState, useEffect, useCallback } from 'react';
import { supabase } from './utils/supabase';
import { Layout } from './components/Layout';
import { Dashboard } from './components/Dashboard';
import { FoodItemsTable } from './components/FoodItemsTable';
import { FoodItemForm } from './components/FoodItemForm';
import { SuppliersTable } from './components/SuppliersTable';
import { SupplierForm } from './components/SupplierForm';
import { TasksPanel } from './components/TasksPanel';
import { ImportExportPanel } from './components/ImportExportPanel';
import { UsersPanel } from './components/UsersPanel';
import { AuditPanel } from './components/AuditPanel';
import { ShieldAlert, LogIn, UserPlus, RefreshCw } from 'lucide-react';

interface Toast {
  id: string;
  message: string;
  type: 'success' | 'error';
}

function App() {
  // Authentication & Session
  const [session, setSession] = useState<any>(null);
  const [profile, setProfile] = useState<any>({ role: 'consulta', full_name: '' });
  const [authLoading, setAuthLoading] = useState(true);
  const [authMode, setAuthMode] = useState<'login' | 'signup' | 'reset-password'>('login');
  
  // Auth Form State
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  // App Data
  const [foodItems, setFoodItems] = useState<any[]>([]);
  const [suppliers, setSuppliers] = useState<any[]>([]);
  const [tasks, setTasks] = useState<any[]>([]);
  const [dataLoading, setDataLoading] = useState(false);

  // Active View Navigation
  const [activeView, setActiveView] = useState('dashboard');

  // Modals / Dialog State
  const [activeItem, setActiveItem] = useState<any | null>(null);
  const [isItemFormOpen, setIsItemFormOpen] = useState(false);
  const [activeSupplier, setActiveSupplier] = useState<any | null>(null);
  const [isSupplierFormOpen, setIsSupplierFormOpen] = useState(false);

  // UI Alerts Toast List
  const [toasts, setToasts] = useState<Toast[]>([]);

  const addToast = useCallback((message: string, type: 'success' | 'error' = 'success') => {
    const id = Math.random().toString(36).substr(2, 9);
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 4000);
  }, []);

  // 1. Fetch Session on Mount
  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setAuthLoading(false);
    });

    // Detect recovery/reset-password from URL params or hash
    const params = new URLSearchParams(window.location.search);
    const isReset = window.location.pathname.endsWith('/reset-password') || 
                    window.location.hash.includes('reset-password') || 
                    window.location.hash.includes('type=recovery') ||
                    params.has('reset');
    if (isReset) {
      setAuthMode('reset-password');
    }

    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      setSession(session);
      if (event === 'PASSWORD_RECOVERY') {
        setAuthMode('reset-password');
      }
      if (!session) {
        setProfile({ role: 'consulta', full_name: '' });
        setFoodItems([]);
        setSuppliers([]);
        setTasks([]);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  // 2. Fetch Profile and Data when Session exists
  const loadProfile = async (userId: string, userEmail: string) => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();

      if (error) throw error;
      if (data) {
        setProfile(data);
      } else {
        // Fallback locally if profile trigger hasn't finished
        setProfile({ role: 'consulta', full_name: userEmail.split('@')[0] });
      }
    } catch (err: any) {
      console.warn("Could not load user profile:", err.message);
      setProfile({ role: 'consulta', full_name: userEmail.split('@')[0] });
    }
  };

  const loadData = useCallback(async () => {
    if (!session) return;
    setDataLoading(true);
    try {
      const [itemsRes, suppliersRes, tasksRes] = await Promise.all([
        supabase.from('food_items').select('*').order('area').order('category').order('name'),
        supabase.from('suppliers').select('*').order('name'),
        supabase.from('tasks').select('*').order('created_at', { ascending: false })
      ]);

      if (itemsRes.error) throw itemsRes.error;
      if (suppliersRes.error) throw suppliersRes.error;
      if (tasksRes.error) throw tasksRes.error;

      setFoodItems(itemsRes.data || []);
      setSuppliers(suppliersRes.data || []);
      setTasks(tasksRes.data || []);
    } catch (err: any) {
      addToast(`Error al cargar datos: ${err.message}`, 'error');
    } finally {
      setDataLoading(false);
    }
  }, [session, addToast]);

  useEffect(() => {
    if (session) {
      loadProfile(session.user.id, session.user.email);
      loadData();
    }
  }, [session, loadData]);

  const getFriendlyAuthErrorMessage = (errorMsg: string): string => {
    const msg = errorMsg.toLowerCase();
    if (msg.includes('rate limit') || msg.includes('too many requests')) {
      return 'Límite de solicitudes excedido. Por seguridad, por favor espera 60 segundos antes de volver a intentarlo.';
    }
    if (msg.includes('invalid credentials') || msg.includes('invalid login credentials')) {
      return 'Correo electrónico o contraseña incorrectos.';
    }
    if (msg.includes('email not confirmed')) {
      return 'El correo electrónico no ha sido verificado aún. Revisa tu bandeja de entrada.';
    }
    if (msg.includes('user already exists')) {
      return 'Ya existe una cuenta registrada con este correo electrónico.';
    }
    if (msg.includes('password should be')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    return errorMsg;
  };

  // 3. Auth Actions
  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) return;
    setAuthLoading(true);
    try {
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
      addToast('Sesión iniciada correctamente.', 'success');
    } catch (err: any) {
      addToast(getFriendlyAuthErrorMessage(err.message || 'Error de conexión'), 'error');
    } finally {
      setAuthLoading(false);
    }
  };

  const handleForgotPassword = async () => {
    if (!email) {
      addToast('Por favor, introduce tu correo electrónico en el campo superior.', 'error');
      return;
    }
    setAuthLoading(true);
    try {
      const isGitHubPages = window.location.hostname.includes('github.io');
      const redirectTo = isGitHubPages
        ? window.location.origin + window.location.pathname + '?reset=true'
        : window.location.origin + '/reset-password';

      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: redirectTo
      });
      if (error) throw error;
      addToast('Si el correo existe, recibirás un enlace para restablecer la contraseña.', 'success');
    } catch (err: any) {
      addToast(getFriendlyAuthErrorMessage(err.message || 'Error al procesar la solicitud'), 'error');
    } finally {
      setAuthLoading(false);
    }
  };

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newPassword) return;
    if (newPassword !== confirmPassword) {
      addToast('Las contraseñas no coinciden.', 'error');
      return;
    }
    setAuthLoading(true);
    try {
      const { error } = await supabase.auth.updateUser({
        password: newPassword
      });
      if (error) throw error;
      
      addToast('Contraseña restablecida con éxito. Inicia sesión con tus nuevas credenciales.', 'success');
      
      await supabase.auth.signOut();
      setNewPassword('');
      setConfirmPassword('');
      setAuthMode('login');
      window.history.replaceState(null, '', window.location.origin + window.location.pathname);
    } catch (err: any) {
      addToast(getFriendlyAuthErrorMessage(err.message || 'Error al actualizar contraseña. El enlace puede haber caducado.'), 'error');
    } finally {
      setAuthLoading(false);
    }
  };

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password || !fullName) return;
    setAuthLoading(true);
    try {
      const { error, data } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            name: fullName
          }
        }
      });
      if (error) throw error;
      
      addToast('Usuario registrado.', 'success');
      
      // Intentar forzar la inserción en perfiles si fallase el trigger por RLS/roles
      if (data?.user) {
        await supabase.from('profiles').insert({
          id: data.user.id,
          email: email,
          full_name: fullName,
          role: 'consulta'
        });
      }
      setAuthMode('login');
    } catch (err: any) {
      addToast(getFriendlyAuthErrorMessage(err.message || 'Error en el registro'), 'error');
    } finally {
      setAuthLoading(false);
    }
  };

  const handleLogout = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) {
      addToast('Error al cerrar sesión.', 'error');
    } else {
      addToast('Sesión cerrada.', 'success');
    }
  };

  // 4. Data Operations: Food Items
  const handleSaveFoodItem = async (data: Partial<any>) => {
    try {
      if (activeItem) {
        // Update
        const { error } = await supabase
          .from('food_items')
          .update(data)
          .eq('id', activeItem.id);
        if (error) throw error;
        addToast('Plato actualizado con éxito.', 'success');
      } else {
        // Insert
        const { error } = await supabase
          .from('food_items')
          .insert(data);
        if (error) throw error;
        addToast('Plato guardado en el catálogo.', 'success');
      }
      loadData();
    } catch (err: any) {
      addToast(`Error al guardar plato: ${err.message}`, 'error');
      throw err;
    }
  };

  const handleDeleteFoodItem = async (id: string) => {
    try {
      const { error } = await supabase
        .from('food_items')
        .delete()
        .eq('id', id);
      if (error) throw error;
      addToast('Plato eliminado del catálogo.', 'success');
      loadData();
    } catch (err: any) {
      addToast(`Error al eliminar: ${err.message}`, 'error');
      throw err;
    }
  };

  // 5. Data Operations: Suppliers
  const handleSaveSupplier = async (data: Partial<any>) => {
    try {
      if (activeSupplier) {
        // Update
        const { error } = await supabase
          .from('suppliers')
          .update(data)
          .eq('id', activeSupplier.id);
        if (error) throw error;
        addToast('Proveedor actualizado.', 'success');
      } else {
        // Insert
        const { error } = await supabase
          .from('suppliers')
          .insert(data);
        if (error) throw error;
        addToast('Proveedor añadido.', 'success');
      }
      loadData();
    } catch (err: any) {
      addToast(`Error al guardar proveedor: ${err.message}`, 'error');
      throw err;
    }
  };

  const handleDeleteSupplier = async (id: string) => {
    try {
      const { error } = await supabase
        .from('suppliers')
        .delete()
        .eq('id', id);
      if (error) throw error;
      addToast('Proveedor eliminado.', 'success');
      loadData();
    } catch (err: any) {
      addToast(`Error al eliminar: ${err.message}`, 'error');
      throw err;
    }
  };

  // 6. Data Operations: Tasks
  const handleSaveTask = async (taskData: Partial<any> & { id?: string }) => {
    try {
      if (taskData.id) {
        // Update
        const { id, ...payload } = taskData;
        const { error } = await supabase
          .from('tasks')
          .update(payload)
          .eq('id', id);
        if (error) throw error;
        addToast('Tarea actualizada.', 'success');
      } else {
        // Insert
        const { error } = await supabase
          .from('tasks')
          .insert(taskData);
        if (error) throw error;
        addToast('Tarea añadida con éxito.', 'success');
      }
      loadData();
    } catch (err: any) {
      addToast(`Error al guardar tarea: ${err.message}`, 'error');
      throw err;
    }
  };

  const handleDeleteTask = async (id: string) => {
    try {
      const { error } = await supabase
        .from('tasks')
        .delete()
        .eq('id', id);
      if (error) throw error;
      addToast('Tarea eliminada.', 'success');
      loadData();
    } catch (err: any) {
      addToast(`Error al eliminar: ${err.message}`, 'error');
      throw err;
    }
  };

  // Memoized stats for Dashboard
  const stats = React.useMemo(() => {
    const total = foodItems.length;
    const validated = foodItems.filter(x => x.status === 'validado').length;
    const pending = foodItems.filter(x => x.status === 'pendiente').length;
    
    const critical = tasks.filter(t => 
      t.status !== 'completada' && (t.priority === 'critica' || t.priority === 'alta')
    ).slice(0, 5);

    const recentPending = foodItems.filter(x => 
      x.status === 'pendiente'
    ).slice(0, 5);

    return { total, validated, pending, critical, recentPending };
  }, [foodItems, tasks]);

  // Main UI routing
  const renderView = () => {
    if (dataLoading) {
      return (
        <div style={{ textAlign: 'center', padding: '100px 0', color: 'var(--color-primary)' }}>
          <p style={{ fontSize: '1.2rem', fontWeight: '500' }}>Cargando catálogo e información de Supabase...</p>
        </div>
      );
    }

    switch (activeView) {
      case 'dashboard':
        return (
          <Dashboard 
            totalItems={stats.total}
            pendingItems={stats.pending}
            validatedItems={stats.validated}
            totalSuppliers={suppliers.length}
            criticalTasks={stats.critical}
            recentPendingItems={stats.recentPending}
            onViewItems={() => setActiveView('items')}
            onViewTasks={() => setActiveView('tasks')}
            onViewUsers={() => setActiveView('users')}
            profileRole={profile.role}
          />
        );
      case 'items':
        return (
          <FoodItemsTable 
            items={foodItems}
            userRole={profile.role}
            onEditItem={(item) => {
              setActiveItem(item);
              setIsItemFormOpen(true);
            }}
            onNewItem={() => {
              setActiveItem(null);
              setIsItemFormOpen(true);
            }}
          />
        );
      case 'suppliers':
        return (
          <SuppliersTable 
            suppliers={suppliers}
            userRole={profile.role}
            onEditSupplier={(supplier) => {
              setActiveSupplier(supplier);
              setIsSupplierFormOpen(true);
            }}
            onNewSupplier={() => {
              setActiveSupplier(null);
              setIsSupplierFormOpen(true);
            }}
          />
        );
      case 'tasks':
        return (
          <TasksPanel 
            tasks={tasks}
            userRole={profile.role}
            onSaveTask={handleSaveTask}
            onDeleteTask={handleDeleteTask}
          />
        );
      case 'import':
        return (
          <ImportExportPanel 
            items={foodItems}
            suppliers={suppliers}
            tasks={tasks}
            onRefreshData={loadData}
            userRole={profile.role}
          />
        );
      case 'users':
        if (profile.role !== 'admin') {
          return <div className="panel"><p style={{ padding: '20px', color: 'var(--color-danger)' }}>Acceso denegado. Solo administradores pueden gestionar usuarios.</p></div>;
        }
        return (
          <UsersPanel 
            currentUserId={session.user.id}
            addToast={addToast}
          />
        );
      case 'audit':
        return (
          <AuditPanel 
            items={foodItems}
            suppliers={suppliers}
            tasks={tasks}
            userRole={profile.role}
            onEditItem={(item) => {
              setActiveItem(item);
              setIsItemFormOpen(true);
            }}
            onEditSupplier={(supplier) => {
              setActiveSupplier(supplier);
              setIsSupplierFormOpen(true);
            }}
          />
        );
      default:
        return <div>Vista no encontrada.</div>;
    }
  };

  // If loading session, show cover loader
  if (authLoading && !session) {
    return (
      <div style={{
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#0d3822',
        color: '#c5a059'
      }}>
        <h2 style={{ fontFamily: 'Playfair Display', fontSize: '2rem' }}>Cargando Food Safety...</h2>
      </div>
    );
  }

  // If not logged in or in reset-password mode, show Auth Screen
  if (!session || authMode === 'reset-password') {
    return (
      <div className="login-backdrop">
        <div className="login-card">
          <div className="login-header">
            <span className="login-subtitle">Control de Alérgenos</span>
            <div className="login-logo">Food <span>Safety</span></div>
            <div className="login-divider"></div>
            <p style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', fontFamily: 'Playfair Display', fontStyle: 'italic' }}>
              Plan de Gestión · Hotel Guadiana
            </p>
          </div>

          {authMode === 'reset-password' ? (
            <form onSubmit={handleResetPassword} className="login-form">
              <h3 style={{ fontSize: '1.1rem', color: 'var(--color-primary)', textAlign: 'center', marginBottom: '10px' }}>
                Restablecer Contraseña
              </h3>
              <p style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', textAlign: 'center', marginBottom: '15px' }}>
                Introduce tu nueva contraseña a continuación.
              </p>
              
              <div className="form-group">
                <label className="form-label">Nueva Contraseña</label>
                <input 
                  type="password" 
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  placeholder="••••••••"
                  required
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label className="form-label">Confirmar Contraseña</label>
                <input 
                  type="password" 
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder="••••••••"
                  required
                  className="form-input"
                />
              </div>

              <div className="login-actions">
                <button type="submit" className="btn btn-primary" style={{ justifyContent: 'center' }} disabled={authLoading}>
                  {authLoading ? <RefreshCw size={16} className="spin" /> : <ShieldAlert size={16} />}
                  <span>Actualizar contraseña</span>
                </button>

                <button 
                  type="button" 
                  onClick={async () => {
                    await supabase.auth.signOut();
                    setAuthMode('login');
                    window.history.replaceState(null, '', window.location.origin + window.location.pathname);
                  }}
                  className="btn btn-outline"
                  style={{ justifyContent: 'center', fontSize: '0.8rem' }}
                  disabled={authLoading}
                >
                  <span>Cancelar</span>
                </button>
              </div>
            </form>
          ) : (
            <form onSubmit={authMode === 'login' ? handleLogin : handleSignup} className="login-form">
              {authMode === 'signup' && (
                <div className="form-group">
                  <label className="form-label">Nombre Completo</label>
                  <input 
                    type="text" 
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    placeholder="Natalio Fernández"
                    required
                    className="form-input"
                  />
                </div>
              )}

              <div className="form-group">
                <label className="form-label">Correo Electrónico</label>
                <input 
                  type="email" 
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="comunicaciones@hotelguadiana.es"
                  required
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label className="form-label">Contraseña</label>
                <input 
                  type="password" 
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  required
                  className="form-input"
                />
              </div>

              {authMode === 'login' && (
                <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '-12px' }}>
                  <button
                    type="button"
                    onClick={handleForgotPassword}
                    disabled={authLoading}
                    style={{
                      background: 'none',
                      border: 'none',
                      color: 'var(--color-secondary)',
                      fontSize: '0.8rem',
                      cursor: 'pointer',
                      textDecoration: 'underline',
                      padding: 0
                    }}
                  >
                    He olvidado mi contraseña
                  </button>
                </div>
              )}

              <div className="login-actions">
                <button type="submit" className="btn btn-primary" style={{ justifyContent: 'center' }} disabled={authLoading}>
                  {authLoading ? <RefreshCw size={16} className="spin" /> : <LogIn size={16} />}
                  <span>{authMode === 'login' ? 'Entrar al Panel' : 'Registrarse'}</span>
                </button>

                <button 
                  type="button" 
                  onClick={() => setAuthMode(authMode === 'login' ? 'signup' : 'login')}
                  className="btn btn-outline"
                  style={{ justifyContent: 'center', fontSize: '0.8rem' }}
                  disabled={authLoading}
                >
                  <UserPlus size={14} />
                  <span>{authMode === 'login' ? 'Crear nueva cuenta' : '¿Ya tienes cuenta? Inicia sesión'}</span>
                </button>
              </div>
            </form>
          )}

          <div className="login-info-text">
            La seguridad del sistema está gestionada mediante Row Level Security en Supabase. 
            Los nuevos registros se crean inicialmente con rol de <strong>Consulta</strong>.
          </div>
        </div>

        {/* Floating Toast Alerts */}
        <div className="toast-container">
          {toasts.map(toast => (
            <div key={toast.id} className={`toast ${toast.type}`}>
              {toast.type === 'error' && <ShieldAlert size={16} />}
              <span>{toast.message}</span>
            </div>
          ))}
        </div>
      </div>
    );
  }

  // Logged-in view
  return (
    <Layout
      activeView={activeView}
      setActiveView={setActiveView}
      currentUserEmail={session.user.email}
      profileName={profile.full_name}
      profileRole={profile.role}
      onLogout={handleLogout}
    >
      {renderView()}

      {/* Edit dish modal form */}
      {isItemFormOpen && (
        <FoodItemForm 
          item={activeItem}
          userRole={profile.role}
          currentUserEmail={session.user.email}
          onSave={handleSaveFoodItem}
          onDelete={handleDeleteFoodItem}
          onClose={() => {
            setIsItemFormOpen(false);
            setActiveItem(null);
          }}
        />
      )}

      {/* Edit supplier modal form */}
      {isSupplierFormOpen && (
        <SupplierForm 
          supplier={activeSupplier}
          userRole={profile.role}
          onSave={handleSaveSupplier}
          onDelete={handleDeleteSupplier}
          onClose={() => {
            setIsSupplierFormOpen(false);
            setActiveSupplier(null);
          }}
        />
      )}

      {/* Floating Toast Alerts */}
      <div className="toast-container">
        {toasts.map(toast => (
          <div key={toast.id} className={`toast ${toast.type}`}>
            {toast.type === 'error' && <ShieldAlert size={16} />}
            <span>{toast.message}</span>
          </div>
        ))}
      </div>
    </Layout>
  );
}

export default App;
