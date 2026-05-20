import React, { useState, useEffect } from 'react';
import { supabase } from '../utils/supabase';
import { Users, Shield, User, Loader2, Check } from 'lucide-react';

interface Profile {
  id: string;
  email: string | null;
  full_name: string | null;
  role: 'admin' | 'cocina' | 'sala' | 'consulta';
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

  const fetchProfiles = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .order('full_name', { ascending: true });

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

  const handleRoleChange = async (userId: string, newRole: 'admin' | 'cocina' | 'sala' | 'consulta') => {
    setUpdatingId(userId);
    try {
      const { error } = await supabase
        .from('profiles')
        .update({ role: newRole })
        .eq('id', userId);

      if (error) throw error;
      
      setProfiles(prev => prev.map(p => p.id === userId ? { ...p, role: newRole } : p));
      addToast('Rol de usuario actualizado correctamente.', 'success');
    } catch (err: any) {
      addToast(`Error al actualizar rol: ${err.message}`, 'error');
    } finally {
      setUpdatingId(null);
    }
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
          Como Administrador, puedes ver y modificar el rol de acceso de los usuarios registrados. Los cambios de rol se aplican instantáneamente en la base de datos de Supabase.
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
                <th>Nombre del Usuario</th>
                <th>Correo Electrónico</th>
                <th>Rol de Acceso</th>
                <th style={{ textAlign: 'center', width: '120px' }}>Estado</th>
              </tr>
            </thead>
            <tbody>
              {profiles.map(profile => {
                const isSelf = profile.id === currentUserId;
                return (
                  <tr key={profile.id} style={isSelf ? { backgroundColor: 'rgba(197, 160, 89, 0.05)' } : {}}>
                    <td>
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
                          fontWeight: 'bold'
                        }}>
                          {profile.full_name ? profile.full_name[0].toUpperCase() : <User size={14} />}
                        </div>
                        <div>
                          <strong>{profile.full_name || 'Sin nombre'}</strong>
                          {isSelf && <span style={{ fontSize: '0.7rem', marginLeft: '6px', padding: '2px 6px', backgroundColor: 'var(--color-secondary)', color: 'var(--color-primary)', borderRadius: '4px', fontWeight: 'bold' }}>Tú</span>}
                        </div>
                      </div>
                    </td>
                    <td><span style={{ fontSize: '0.85rem' }}>{profile.email || '—'}</span></td>
                    <td>
                      {isSelf ? (
                        <div style={{ fontSize: '0.9rem', fontWeight: 600, color: 'var(--color-primary)', display: 'flex', alignItems: 'center', gap: '6px' }}>
                          <Shield size={14} style={{ color: 'var(--color-secondary)' }} />
                          {getRoleLabel(profile.role)} (No modificable)
                        </div>
                      ) : (
                        <select
                          className="filter-select"
                          value={profile.role}
                          onChange={(e) => handleRoleChange(profile.id, e.target.value as any)}
                          disabled={updatingId === profile.id}
                          style={{ 
                            padding: '6px 12px', 
                            fontSize: '0.85rem', 
                            minWidth: '180px',
                            borderColor: updatingId === profile.id ? 'var(--color-border)' : 'var(--color-primary)'
                          }}
                        >
                          <option value="consulta">Consulta (Lector)</option>
                          <option value="sala">Sala / Restauración</option>
                          <option value="cocina">Cocina</option>
                          <option value="admin">Administrador</option>
                        </select>
                      )}
                    </td>
                    <td style={{ textAlign: 'center' }}>
                      {updatingId === profile.id ? (
                        <Loader2 className="spin" size={16} style={{ color: 'var(--color-secondary)' }} />
                      ) : (
                        <span style={{ color: 'var(--color-success)', display: 'inline-flex', alignItems: 'center', gap: '4px', fontSize: '0.8rem', fontWeight: 600 }}>
                          <Check size={12} /> Guardado
                        </span>
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
