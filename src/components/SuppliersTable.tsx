import React from 'react';
import { Plus, Check, AlertCircle, Eye, Phone, Mail, FileText } from 'lucide-react';

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
  const canEdit = userRole === 'admin' || userRole === 'gestor';

  return (
    <div className="panel">
      <div className="panel-header">
        <h3>Registro de Proveedores</h3>
        {canEdit && (
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
                <th>Proveedor</th>
                <th>Contacto</th>
                <th>Ficha Técnica</th>
                <th>Estado de Ficha</th>
                <th>Observaciones / Productos</th>
                <th style={{ width: '100px' }}>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {suppliers.map(supplier => (
                <tr key={supplier.id}>
                  <td><strong>{supplier.name}</strong></td>
                  <td>
                    <div style={{ fontSize: '0.85rem' }}>{supplier.contact_person || '—'}</div>
                    <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>
                      {supplier.phone && `Tel: ${supplier.phone}`} {supplier.email && `| ${supplier.email}`}
                    </div>
                  </td>
                  <td>
                    {supplier.technical_sheet_url ? (
                      <a 
                        href={supplier.technical_sheet_url} 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="technical-sheet-link"
                        style={{ display: 'inline-flex', alignItems: 'center', gap: '4px' }}
                      >
                        <FileText size={14} />
                        <span>Ver Ficha</span>
                      </a>
                    ) : (
                      <span style={{ fontSize: '0.8rem', color: 'var(--color-danger)', fontWeight: '500' }}>
                        Sin Ficha Cargada
                      </span>
                    )}
                  </td>
                  <td>
                    <span className={`badge ${supplier.technical_sheet_status || 'pendiente'}`}>
                      {supplier.technical_sheet_status === 'validada' 
                        ? 'Validada' 
                        : supplier.technical_sheet_status === 'en_revision' 
                          ? 'En revisión' 
                          : 'Pendiente'}
                    </span>
                  </td>
                  <td>
                    <p style={{ 
                      fontSize: '0.82rem', 
                      color: 'var(--color-text-main)',
                      maxWidth: '300px',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                      whiteSpace: 'nowrap'
                    }}>
                      {supplier.notes || '—'}
                    </p>
                  </td>
                  <td>
                    <button 
                      onClick={() => onEditSupplier(supplier)}
                      className={`btn btn-outline btn-small ${canEdit ? 'btn-secondary' : ''}`}
                      style={{ display: 'flex', alignItems: 'center', gap: '4px' }}
                    >
                      {canEdit ? (
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
