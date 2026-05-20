import React from 'react';
import { Plus, Check, AlertCircle, Eye, Phone, Mail } from 'lucide-react';

interface Supplier {
  id: string;
  name: string;
  phone: string | null;
  email: string | null;
  products: string | null;
  technical_sheet_available: boolean;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

interface SuppliersTableProps {
  suppliers: Supplier[];
  userRole: string;
  onEditSupplier: (supplier: Supplier) => void;
  onNewSupplier: () => void;
}

export const SuppliersTable: React.FC<SuppliersTableProps> = ({
  suppliers,
  userRole,
  onEditSupplier,
  onNewSupplier
}) => {
  const isAdmin = userRole === 'admin';

  return (
    <div className="panel">
      <div className="panel-header">
        <h3>Registro de Proveedores</h3>
        {isAdmin && (
          <button className="btn btn-primary" onClick={onNewSupplier}>
            <Plus size={16} />
            <span>Nuevo Proveedor</span>
          </button>
        )}
      </div>

      <div className="table-responsive">
        {suppliers.length > 0 ? (
          <table>
            <thead>
              <tr>
                <th>Nombre del Proveedor</th>
                <th>Contacto</th>
                <th>Productos Suministrados</th>
                <th>Ficha Técnica</th>
                <th>Observaciones</th>
                <th style={{ width: '100px' }}>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {suppliers.map(supplier => (
                <tr key={supplier.id}>
                  <td><strong>{supplier.name}</strong></td>
                  <td>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', fontSize: '0.82rem' }}>
                      {supplier.phone && (
                        <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                          <Phone size={12} />
                          {supplier.phone}
                        </span>
                      )}
                      {supplier.email && (
                        <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                          <Mail size={12} />
                          {supplier.email}
                        </span>
                      )}
                      {!supplier.phone && !supplier.email && <span style={{ color: 'var(--color-text-muted)' }}>Sin contacto</span>}
                    </div>
                  </td>
                  <td>
                    <p style={{ 
                      fontSize: '0.85rem', 
                      maxWidth: '250px',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                      whiteSpace: 'nowrap' 
                    }} title={supplier.products || ''}>
                      {supplier.products || '—'}
                    </p>
                  </td>
                  <td>
                    {supplier.technical_sheet_available ? (
                      <span className="badge validado" style={{ display: 'inline-flex', alignItems: 'center', gap: '4px' }}>
                        <Check size={12} />
                        Disponible
                      </span>
                    ) : (
                      <span className="badge pendiente" style={{ display: 'inline-flex', alignItems: 'center', gap: '4px' }}>
                        <AlertCircle size={12} />
                        Pendiente
                      </span>
                    )}
                  </td>
                  <td>
                    <p style={{ 
                      fontSize: '0.82rem', 
                      color: 'var(--color-text-muted)',
                      maxWidth: '220px',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                      whiteSpace: 'nowrap'
                    }} title={supplier.notes || ''}>
                      {supplier.notes || '—'}
                    </p>
                  </td>
                  <td>
                    <button 
                      onClick={() => onEditSupplier(supplier)}
                      className={`btn btn-outline btn-small ${isAdmin ? 'btn-secondary' : ''}`}
                      style={{ display: 'flex', alignItems: 'center', gap: '4px' }}
                    >
                      {isAdmin ? (
                        <span>Editar</span>
                      ) : (
                        <>
                          <Eye size={12} />
                          <span>Ver</span>
                        </>
                      )}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p style={{ textAlign: 'center', padding: '40px', color: 'var(--color-text-muted)' }}>
            No hay proveedores registrados en el sistema.
          </p>
        )}
      </div>
    </div>
  );
};
