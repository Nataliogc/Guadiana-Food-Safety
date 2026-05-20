import React, { useState } from 'react';
import { 
  LayoutDashboard, 
  Utensils, 
  Truck, 
  CheckSquare, 
  UploadCloud, 
  LogOut, 
  Menu, 
  X,
  User,
  Users,
  ShieldCheck
} from 'lucide-react';

interface LayoutProps {
  children: React.ReactNode;
  activeView: string;
  setActiveView: (view: string) => void;
  currentUserEmail: string | undefined;
  profileName: string;
  profileRole: string;
  onLogout: () => void;
}

export const Layout: React.FC<LayoutProps> = ({
  children,
  activeView,
  setActiveView,
  currentUserEmail,
  profileName,
  profileRole,
  onLogout
}) => {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navItems = [
    { id: 'dashboard', label: 'Resumen', icon: <LayoutDashboard size={20} /> },
    { id: 'items', label: 'Platos / Productos', icon: <Utensils size={20} /> },
    { id: 'audit', label: 'Informe Sanidad', icon: <ShieldCheck size={20} /> },
    { id: 'suppliers', label: 'Proveedores', icon: <Truck size={20} /> },
    { id: 'tasks', label: 'Tareas', icon: <CheckSquare size={20} /> },
    ...(profileRole === 'admin' ? [{ id: 'users', label: 'Control de Usuarios', icon: <Users size={20} /> }] : []),
    { id: 'import', label: 'Importar / Exportar', icon: <UploadCloud size={20} /> },
  ];

  const handleNavClick = (viewId: string) => {
    setActiveView(viewId);
    setMobileMenuOpen(false);
  };

  const getRoleLabel = (role: string) => {
    switch (role) {
      case 'admin': return 'Administrador';
      case 'cocina': return 'Cocina';
      case 'sala': return 'Sala / Restauración';
      case 'consulta': return 'Consulta';
      default: return role;
    }
  };

  return (
    <div className="app-container">
      {/* Sidebar Navigation */}
      <aside className={`sidebar ${mobileMenuOpen ? 'mobile-open' : ''}`}>
        <div>
          <div className="sidebar-header">
            <h1>Food Safety</h1>
            <p>Hotel Guadiana</p>
          </div>
          
          <ul className="nav-menu">
            {navItems.map((item) => (
              <li 
                key={item.id} 
                className={`nav-item ${activeView === item.id ? 'active' : ''}`}
              >
                <button onClick={() => handleNavClick(item.id)}>
                  {item.icon}
                  <span>{item.label}</span>
                </button>
              </li>
            ))}
          </ul>
        </div>

        <div className="sidebar-footer">
          <div className="user-profile-info">
            <div className="user-avatar">
              <User size={16} />
            </div>
            <div className="user-meta">
              <span className="user-name" title={profileName || currentUserEmail}>
                {profileName || currentUserEmail?.split('@')[0]}
              </span>
              <span className="user-role-badge">
                {getRoleLabel(profileRole)}
              </span>
            </div>
          </div>
          
          <button onClick={onLogout} className="logout-btn">
            <LogOut size={16} />
            <span>Cerrar Sesión</span>
          </button>
        </div>
      </aside>

      {/* Main Panel Area */}
      <div className="main-content">
        <header className="top-navbar">
          <button 
            className="menu-toggle-btn"
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          >
            {mobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
          
          <div className="page-title">
            <h2>Control de Alérgenos</h2>
            <p>Plan de Gestión Interno del Hotel Guadiana</p>
          </div>
          
          <div className="navbar-actions">
            <span className="hotel-badge">Hotel Guadiana</span>
          </div>
        </header>

        <main className="content-body">
          {profileRole === 'admin' && (
            <div style={{ padding: '10px 16px', backgroundColor: '#e6fffa', borderLeft: '4px solid #319795', color: '#234e52', fontSize: '0.8rem', borderRadius: '4px', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px' }} className="no-print">
              <ShieldCheck size={16} style={{ color: '#319795' }} />
              <div>
                <strong>Acceso Administrador:</strong> Tienes control total del sistema (configuración de alérgenos, informes y gestión de usuarios).
              </div>
            </div>
          )}
          {profileRole === 'cocina' && (
            <div style={{ padding: '10px 16px', backgroundColor: '#f0fff4', borderLeft: '4px solid #38a169', color: '#22543d', fontSize: '0.8rem', borderRadius: '4px', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px' }} className="no-print">
              <ShieldCheck size={16} style={{ color: '#38a169' }} />
              <div>
                <strong>Acceso Cocina:</strong> Tienes permisos para revisar, editar y validar platos/productos.
              </div>
            </div>
          )}
          {profileRole === 'sala' && (
            <div style={{ padding: '10px 16px', backgroundColor: '#ebf8ff', borderLeft: '4px solid #3182ce', color: '#2a4365', fontSize: '0.8rem', borderRadius: '4px', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px' }} className="no-print">
              <ShieldCheck size={16} style={{ color: '#3182ce' }} />
              <div>
                <strong>Acceso Sala / Restauración:</strong> Tienes permisos para consultar platos y crear/gestionar tareas.
              </div>
            </div>
          )}
          {profileRole === 'consulta' && (
            <div style={{ padding: '10px 16px', backgroundColor: '#f7fafc', borderLeft: '4px solid #a0aec0', color: '#4a5568', fontSize: '0.8rem', borderRadius: '4px', display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px' }} className="no-print">
              <ShieldCheck size={16} style={{ color: '#a0aec0' }} />
              <div>
                <strong>Acceso Consulta:</strong> Tienes acceso de solo lectura al catálogo.
              </div>
            </div>
          )}
          {children}
        </main>
      </div>
    </div>
  );
};
