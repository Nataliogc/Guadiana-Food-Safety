import React, { useState, useEffect } from 'react';
import { supabase } from '../utils/supabase';
import { Users, Shield, User, Loader2, Check, Edit2, X, Save, Calendar } from 'lucide-react';

interface Profile {
  id: string;
  email: string | null;
  full_name: string | null;
  role: 'admin' | 'gestor' | 'cocina' | 'sala' | 'consulta';
  created_at?: string;
}

interface UsersPanelProps {
  currentUserId: string;
  addToast: (message: string, type: 'success' | 'error') => void;
}

export const UsersPanel: React.FC<UsersPanelProps> = ({ currentUserId, addToast }) => {
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loading, setLoading] = useState(true);
  const [updatingId, setUpdatingId] = useState<string | null>(null);
  
  // Edit states
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editName, setEditName] = useState<string>('');
  const [editRole, setEditRole] = useState<'admin' | 'gestor' | 'cocina' | 'sala' | 'consulta'>('consulta');

  const fetchProfiles = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setProfiles(data || []);
    } catch (err: any) {
      addToast(`Error al cargar usuarios: ${err.message}`, 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProfiles();
  }, []);

  const handleStartEdit = (profile: Profile) => {
    setEditingId(profile.id);
    setEditName(profile.full_name || '');
    setEditRole(profile.role);
  };

  const handleCancelEdit = () => {
    setEditingId(null);
  };

  const handleSave = async (userId: string) => {
    if (!editName.trim()) {
      addToast('El nombre completo no puede estar vacío.', 'error');
      return;
    }
    setUpdatingId(userId);
    try {
      const isSelf = userId === currentUserId;
      // Safeguard: do not allow changing role if editing self (prevent self-demotion or self-promotion)
      const payload: any = { full_name: editName };
      if (!isSelf) {
        payload.role = editRole;
      }

      const { error } = await supabase
        .from('profiles')
        .update(payload)
        .eq('id', userId);

      if (error) throw error;

      setProfiles(prev => prev.map(p => p.id === userId ? { ...p, full_name: editName, role: isSelf ? p.role : editRole } : p));
      addToast('Perfil actualizado correctamente.', 'success');
      setEditingId(null);
    } catch (err: any) {
      addToast(`Error al actualizar el usuario: ${err.message}`, 'error');
    } finally {
      setUpdatingId(null);
    }
  };

  const getRoleLabel = (role: string) => {
    switch (role) {
      case 'admin': return 'Administrador';
      case 'gestor': return 'Gestor';
      case 'cocina': return 'Cocina';
      case 'sala': return 'Sala / Restauración';
      case 'consulta': return 'Consulta';
      default: return role;
    }
  };

  const getRoleBadgeStyle = (role: string) => {
    switch (role) {
      case 'admin':
        return { backgroundColor: '#e6fffa', color: '#234e52', border: '1px solid #319795' };
      case 'gestor':
        return { backgroundColor: '#fffaf0', color: '#7b341e', border: '1px solid #dd6b20' };
      case 'cocina':
        return { backgroundColor: '#f0fff4', color: '#22543d', border: '1px solid #38a169' };
      case 'sala':
        return { backgroundColor: '#ebf8ff', color: '#2a4365', border: '1px solid #3182ce' };
      default:
        return { backgroundColor: '#f7fafc', color: '#4a5568', border: '1px solid #a0aec0' };
    }
  };

  return (
    <div className="panel">
      <div className="panel-header">
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
          <Users size={24} style={{ color: 'var(--color-primary)' }} />
          <h3>Gestión de Usuarios y Roles</h3>
        </div>
      </div>

      <div style={{ marginBottom: '20px', padding: '12px 16px', backgroundColor: 'var(--color-bg-main)', borderRadius: 'var(--radius-md)', border: '1px solid var(--color-border)', fontSize: '0.85rem', color: 'var(--color-text-muted)', display: 'flex', gap: '10px', alignItems: 'center' }}>
        <Shield size={16} style={{ color: 'var(--color-secondary)', flexShrink: 0 }} />
        <span>
          Como Administrador, puedes gestionar los nombres y roles de acceso de la plantilla. Los cambios se guardan y aplican instantáneamente mediante políticas de RLS en Supabase.
        </span>
      </div>

      <div className="table-responsive">
        {loading ? (
          <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', padding: '60px', gap: '10px', color: 'var(--color-text-muted)' }}>
            <Loader2 className="spin" size={24} />
            <span>Cargando lista de usuarios...</span>
          </div>
        ) : profiles.length > 0 ? (
          <table>
            <thead>
              <tr>
                <th style={{ width: '30%' }}>Nombre Completo</th>
                <th style={{ width: '25%' }}>Correo Electrónico</th>
                <th style={{ width: '20%' }}>Rol de Acceso</th>
                <th style={{ width: '15%' }}>Fecha de Registro</th>
                <th style={{ textAlign: 'center', width: '10%' }}>Acción</th>
              </tr>
            </thead>
            <tbody>
              {profiles.map(profile => {
                const isSelf = profile.id === currentUserId;
                const isEditing = editingId === profile.id;
                
                return (
                  <tr key={profile.id} style={isSelf ? { backgroundColor: 'rgba(197, 160, 89, 0.03)' } : {}}>
                    <td>
                      {isEditing ? (
                        <input
                          type="text"
                          className="form-input"
                          value={editName}
                          onChange={(e) => setEditName(e.target.value)}
                          placeholder="Nombre Completo"
                          style={{ padding: '6px 10px', width: '100%', fontSize: '0.85rem' }}
                        />
                      ) : (
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          <div style={{ 
                            width: '28px', 
                            height: '28px', 
                            borderRadius: '50%', 
                            backgroundColor: isSelf ? 'var(--color-primary)' : 'var(--color-border)', 
                            color: isSelf ? '#ffffff' : 'var(--color-text-main)', 
                            display: 'flex', 
                            alignItems: 'center', 
                            justifyContent: 'center',
                            fontSize: '0.8rem',
                            fontWeight: 'bold',
                            flexShrink: 0
                          }}>
                            {profile.full_name ? profile.full_name[0].toUpperCase() : <User size={14} />}
                          </div>
                          <div>
                            <span style={{ fontWeight: 600 }}>{profile.full_name || 'Sin nombre'}</span>
                            {isSelf && (
                              <span style={{ fontSize: '0.65rem', marginLeft: '6px', padding: '1px 5px', backgroundColor: 'var(--color-secondary)', color: 'var(--color-primary)', borderRadius: '3px', fontWeight: 'bold' }}>
                                Tú
                              </span>
                            )}
                          </div>
                        </div>
                      )}
                    </td>
                    <td>
                      <span style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>
                        {profile.email || '—'}
                      </span>
                    </td>
                    <td>
                      {isEditing ? (
                        isSelf ? (
                          <div style={{ fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-text-muted)' }}>
                            {getRoleLabel(profile.role)} (No modificable)
                          </div>
                        ) : (
                          <select
                            className="filter-select"
                            value={editRole}
                            onChange={(e) => setEditRole(e.target.value as any)}
                            style={{ padding: '6px 8px', fontSize: '0.85rem', width: '100%' }}
                          >
                            <option value="consulta">Consulta</option>
                            <option value="sala">Sala / Restauración</option>
                            <option value="cocina">Cocina</option>
                            <option value="gestor">Gestor</option>
                            <option value="admin">Administrador</option>
                          </select>
                        )
                      ) : (
                        <span style={{ 
                          fontSize: '0.75rem', 
                          fontWeight: 600, 
                          padding: '3px 8px', 
                          borderRadius: '4px',
                          display: 'inline-block',
                          ...getRoleBadgeStyle(profile.role)
                        }}>
                          {getRoleLabel(profile.role).toUpperCase()}
                        </span>
                      )}
                    </td>
                    <td>
                      <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', display: 'flex', alignItems: 'center', gap: '4px' }}>
                        <Calendar size={12} />
                        {profile.created_at ? new Date(profile.created_at).toLocaleDateString('es-ES') : '—'}
                      </span>
                    </td>
                    <td style={{ textAlign: 'center' }}>
                      {updatingId === profile.id ? (
                        <Loader2 className="spin" size={16} style={{ color: 'var(--color-secondary)' }} />
                      ) : isEditing ? (
                        <div style={{ display: 'flex', gap: '6px', justifyContent: 'center' }}>
                          <button 
                            className="btn btn-outline btn-small" 
                            onClick={() => handleSave(profile.id)} 
                            style={{ padding: '4px 6px', color: 'var(--color-success)', borderColor: 'var(--color-success)' }}
                            title="Guardar"
                          >
                            <Save size={14} />
                          </button>
                          <button 
                            className="btn btn-outline btn-small" 
                            onClick={handleCancelEdit} 
                            style={{ padding: '4px 6px' }}
                            title="Cancelar"
                          >
                            <X size={14} />
                          </button>
                        </div>
                      ) : (
                        <button 
                          className="btn btn-outline btn-small" 
                          onClick={() => handleStartEdit(profile)}
                          style={{ padding: '4px 6px' }}
                          title="Editar usuario"
                        >
                          <Edit2 size={14} />
                        </button>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        ) : (
          <p style={{ textAlign: 'center', padding: '40px', color: 'var(--color-text-muted)' }}>
            No se encontraron usuarios.
          </p>
        )}
      </div>
    </div>
  );
};
