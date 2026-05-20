import React, { useState, useEffect } from 'react';
import { X, Trash2 } from 'lucide-react';

interface Supplier {
  id: string;
  name: string;
  phone: string | null;
  email: string | null;
  products: string | null;
  technical_sheet_available: boolean;
  notes: string | null;
}

interface SupplierFormProps {
  supplier: Supplier | null;
  userRole: string;
  onSave: (data: Partial<Supplier>) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
  onClose: () => void;
}

export const SupplierForm: React.FC<SupplierFormProps> = ({
  supplier,
  userRole,
  onSave,
  onDelete,
  onClose
}) => {
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [products, setProducts] = useState('');
  const [technicalSheetAvailable, setTechnicalSheetAvailable] = useState(false);
  const [notes, setNotes] = useState('');
  const [loading, setLoading] = useState(false);

  const isAdmin = userRole === 'admin';
  const isReadOnly = !isAdmin;
  const canDelete = supplier && isAdmin;

  useEffect(() => {
    if (supplier) {
      setName(supplier.name || '');
      setPhone(supplier.phone || '');
      setEmail(supplier.email || '');
      setProducts(supplier.products || '');
      setTechnicalSheetAvailable(!!supplier.technical_sheet_available);
      setNotes(supplier.notes || '');
    } else {
      setName('');
      setPhone('');
      setEmail('');
      setProducts('');
      setTechnicalSheetAvailable(false);
      setNotes('');
    }
  }, [supplier]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isReadOnly) return;

    if (!name.trim()) {
      alert('El nombre del proveedor es obligatorio.');
      return;
    }

    setLoading(true);
    try {
      const payload: Partial<Supplier> = {
        name: name.trim(),
        phone: phone.trim() || null,
        email: email.trim() || null,
        products: products.trim() || null,
        technical_sheet_available: technicalSheetAvailable,
        notes: notes.trim() || null
      };

      await onSave(payload);
      onClose();
    } catch (err) {
      console.error(err);
      alert('Error al guardar el proveedor.');
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteClick = async () => {
    if (!supplier || !canDelete) return;
    if (window.confirm(`¿Seguro que deseas eliminar al proveedor "${name}"? Esta acción no se puede deshacer.`)) {
      setLoading(true);
      try {
        await onDelete(supplier.id);
        onClose();
      } catch (err) {
        console.error(err);
        alert('Error al eliminar el proveedor.');
      } finally {
        setLoading(false);
      }
    }
  };

  return (
    <div className="modal-backdrop">
      <div className="modal-container">
        <div className="modal-header">
          <h3>{supplier ? (isReadOnly ? 'Detalles del Proveedor' : 'Editar Proveedor') : 'Nuevo Proveedor'}</h3>
          <button className="modal-close-btn" onClick={onClose}>
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit} style={{ display: 'contents' }}>
          <div className="modal-body">
            <div className="form-grid">
              
              <div className="form-group full-width">
                <label className="form-label">Nombre del Proveedor / Razón Social *</label>
                <input 
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Nombre de la empresa o distribuidor"
                  required
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label className="form-label">Teléfono de Contacto</label>
                <input 
                  type="text"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Ej. 926 22 33 13"
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label className="form-label">Email de Pedidos / Comercial</label>
                <input 
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Ej. pedidos@proveedor.com"
                  className="form-input"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Productos que Suministra</label>
                <textarea 
                  value={products}
                  onChange={(e) => setProducts(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Listado de ingredientes o categorías suministradas (harinas, carnes, lácteos, pescados...)"
                  rows={2}
                  className="form-textarea"
                />
              </div>

              <div className="form-group">
                <label className="form-label">Ficha Técnica Sanitaria</label>
                <select 
                  value={String(technicalSheetAvailable)}
                  onChange={(e) => setTechnicalSheetAvailable(e.target.value === 'true')}
                  disabled={isReadOnly}
                  className="form-select"
                >
                  <option value="false">Pendiente de recibir / solicitar</option>
                  <option value="true">✓ Disponible y archivada</option>
                </select>
              </div>

              <div className="form-group full-width">
                <label className="form-label">Notas Adicionales</label>
                <textarea 
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Observaciones de entregas, incidencias con alérgenos o acuerdos comerciales..."
                  rows={2}
                  className="form-textarea"
                />
              </div>

            </div>
          </div>

          <div className="modal-footer">
            {canDelete && (
              <button 
                type="button" 
                onClick={handleDeleteClick} 
                className="btn btn-danger"
                style={{ marginRight: 'auto' }}
                disabled={loading}
              >
                <Trash2 size={16} />
                <span>Eliminar Proveedor</span>
              </button>
            )}
            
            <button 
              type="button" 
              onClick={onClose} 
              className="btn btn-outline"
              disabled={loading}
            >
              Cancelar
            </button>

            {!isReadOnly && (
              <button 
                type="submit" 
                className="btn btn-primary"
                disabled={loading}
              >
                {loading ? 'Guardando...' : 'Guardar Cambios'}
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
};
