import React, { useState, useEffect } from 'react';
import { X, Trash2, ShieldCheck } from 'lucide-react';

interface FoodItem {
  id: string;
  area: string | null;
  category: string | null;
  name: string;
  ingredients: string | null;
  allergen_codes: string | null;
  allergens: string | null;
  traces: string | null;
  preparation: string | null;
  supplier_notes: string | null;
  status: string | null;
  validated_by: string | null;
  validated_at: string | null;
}

interface FoodItemFormProps {
  item: FoodItem | null;
  userRole: string;
  currentUserEmail: string | undefined;
  onSave: (data: Partial<FoodItem>) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
  onClose: () => void;
}

const AREAS = [
  'Cafetería',
  'Restaurante',
  'Desayuno Buffet',
  'Menú Deportivo',
  'Menús de Grupo',
  'Coffee Break',
  'Eventos',
  'Cócteles'
];

const ALLERGENS_LIST = [
  { code: 1, name: 'Pescado' },
  { code: 2, name: 'Frutos secos' },
  { code: 3, name: 'Lácteos' },
  { code: 4, name: 'Moluscos' },
  { code: 5, name: 'Gluten' },
  { code: 6, name: 'Crustáceos' },
  { code: 7, name: 'Huevos' },
  { code: 8, name: 'Cacahuetes' },
  { code: 9, name: 'Soja' },
  { code: 10, name: 'Apio' },
  { code: 11, name: 'Mostaza' },
  { code: 12, name: 'Sésamo' },
  { code: 13, name: 'Altramuz' },
  { code: 14, name: 'Sulfitos' }
];

export const FoodItemForm: React.FC<FoodItemFormProps> = ({
  item,
  userRole,
  currentUserEmail,
  onSave,
  onDelete,
  onClose
}) => {
  const [area, setArea] = useState('');
  const [category, setCategory] = useState('');
  const [name, setName] = useState('');
  const [ingredients, setIngredients] = useState('');
  const [allergenText, setAllergenText] = useState('');
  const [traces, setTraces] = useState('');
  const [preparation, setPreparation] = useState('');
  const [supplierNotes, setSupplierNotes] = useState('');
  const [status, setStatus] = useState('pendiente');
  const [selectedAllergens, setSelectedAllergens] = useState<number[]>([]);
  const [loading, setLoading] = useState(false);

  const isReadOnly = userRole !== 'admin' && userRole !== 'cocina';
  const canDelete = item && userRole === 'admin'; // Solo admin puede eliminar físicamente de la base de datos

  useEffect(() => {
    if (item) {
      setArea(item.area || '');
      setCategory(item.category || '');
      setName(item.name || '');
      setIngredients(item.ingredients || '');
      setAllergenText(item.allergens || '');
      setTraces(item.traces || '');
      setPreparation(item.preparation || '');
      setSupplierNotes(item.supplier_notes || '');
      setStatus(item.status || 'pendiente');

      // Parse allergen codes
      if (item.allergen_codes) {
        const codes = item.allergen_codes
          .split(/[,/;\s]+/)
          .map(c => parseInt(c.trim(), 10))
          .filter(num => !isNaN(num));
        setSelectedAllergens(codes);
      } else {
        setSelectedAllergens([]);
      }
    } else {
      setArea(AREAS[0]);
      setCategory('');
      setName('');
      setIngredients('');
      setAllergenText('');
      setTraces('');
      setPreparation('');
      setSupplierNotes('');
      setStatus('pendiente');
      setSelectedAllergens([]);
    }
  }, [item]);

  // Manejar el cambio en los checkboxes de alérgenos
  const handleAllergenChange = (code: number) => {
    if (isReadOnly) return;
    
    let updated: number[];
    if (selectedAllergens.includes(code)) {
      updated = selectedAllergens.filter(c => c !== code);
    } else {
      updated = [...selectedAllergens, code].sort((a, b) => a - b);
    }
    setSelectedAllergens(updated);
    
    // Auto-generar lista de textos de alérgenos
    const names = updated.map(c => ALLERGENS_LIST.find(a => a.code === c)?.name || '').filter(Boolean);
    setAllergenText(names.join(', '));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isReadOnly) return;

    if (!name.trim()) {
      alert('El nombre del plato es obligatorio.');
      return;
    }

    setLoading(true);
    try {
      const allergenCodesStr = selectedAllergens.join(', ');
      
      const payload: Partial<FoodItem> = {
        area,
        category: category.trim() || null,
        name: name.trim(),
        ingredients: ingredients.trim() || null,
        allergen_codes: allergenCodesStr || null,
        allergens: allergenText.trim() || null,
        traces: traces.trim() || null,
        preparation: preparation.trim() || null,
        supplier_notes: supplierNotes.trim() || null,
        status,
      };

      if (status === 'validado' && item?.status !== 'validado') {
        payload.validated_by = currentUserEmail || 'Cocina';
        payload.validated_at = new Date().toISOString();
      } else if (status !== 'validado') {
        payload.validated_by = null;
        payload.validated_at = null;
      }

      await onSave(payload);
      onClose();
    } catch (err) {
      console.error(err);
      alert('Error al guardar el plato.');
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteClick = async () => {
    if (!item || !canDelete) return;
    if (window.confirm(`¿Seguro que deseas eliminar el plato "${name}"? Esta acción no se puede deshacer.`)) {
      setLoading(true);
      try {
        await onDelete(item.id);
        onClose();
      } catch (err) {
        console.error(err);
        alert('Error al eliminar el plato.');
      } finally {
        setLoading(false);
      }
    }
  };

  return (
    <div className="modal-backdrop">
      <div className="modal-container">
        <div className="modal-header">
          <h3>{item ? (isReadOnly ? 'Detalles de Plato' : 'Editar Plato') : 'Nuevo Plato'}</h3>
          <button className="modal-close-btn" onClick={onClose}>
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit} style={{ display: 'contents' }}>
          <div className="modal-body">
            <div className="form-grid">
              
              <div className="form-group">
                <label className="form-label">Área del Hotel</label>
                <select 
                  value={area}
                  onChange={(e) => setArea(e.target.value)}
                  disabled={isReadOnly}
                  className="form-select"
                >
                  {AREAS.map(a => (
                    <option key={a} value={a}>{a}</option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label className="form-label">Categoría (p.ej. Ensaladas, Carnes)</label>
                <input 
                  type="text"
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Categoría del plato"
                  className="form-input"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Nombre del Plato / Producto *</label>
                <input 
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Nombre oficial del plato"
                  required
                  className="form-input"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Ingredientes</label>
                <textarea 
                  value={ingredients}
                  onChange={(e) => setIngredients(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Detalla todos los ingredientes que componen la receta..."
                  rows={3}
                  className="form-textarea"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Seleccionar Alérgenos Presentes (Normativa 14 Alérgenos)</label>
                <div className="allergen-selection-grid">
                  {ALLERGENS_LIST.map(alg => (
                    <label key={alg.code} className="allergen-checkbox-label">
                      <input 
                        type="checkbox"
                        checked={selectedAllergens.includes(alg.code)}
                        onChange={() => handleAllergenChange(alg.code)}
                        disabled={isReadOnly}
                      />
                      <span>{alg.code}. {alg.name}</span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="form-group full-width">
                <label className="form-label">Alérgenos Declarados (Traducción textual)</label>
                <input 
                  type="text"
                  value={allergenText}
                  onChange={(e) => setAllergenText(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Alérgenos en formato de texto libre (p.ej. contiene lácteos y gluten)"
                  className="form-input"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Trazas / Contaminación Cruzada Posible</label>
                <input 
                  type="text"
                  value={traces}
                  onChange={(e) => setTraces(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Posibles trazas por fritura u otros procesos comunes"
                  className="form-input"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Método de Elaboración / Puntos de Control</label>
                <textarea 
                  value={preparation}
                  onChange={(e) => setPreparation(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Instrucciones para cocina y temperaturas de control..."
                  rows={2}
                  className="form-textarea"
                />
              </div>

              <div className="form-group full-width">
                <label className="form-label">Notas del Proveedor / Observaciones técnicas</label>
                <input 
                  type="text"
                  value={supplierNotes}
                  onChange={(e) => setSupplierNotes(e.target.value)}
                  disabled={isReadOnly}
                  placeholder="Notas adicionales o información de marcas de ingredientes"
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label className="form-label">Estado de Validación</label>
                <select 
                  value={status}
                  onChange={(e) => setStatus(e.target.value)}
                  disabled={isReadOnly}
                  className="form-select"
                >
                  <option value="pendiente">Pendiente de validar</option>
                  <option value="en_revision">En revisión</option>
                  <option value="validado">✓ Validado por Cocina</option>
                </select>
              </div>

              {item && item.validated_by && (
                <div className="form-group" style={{ justifyContent: 'center' }}>
                  <span style={{ 
                    fontSize: '0.8rem', 
                    color: 'var(--color-success)', 
                    display: 'flex', 
                    alignItems: 'center', 
                    gap: '4px',
                    fontWeight: '600'
                  }}>
                    <ShieldCheck size={16} />
                    Validado por {item.validated_by}
                  </span>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {new Date(item.validated_at!).toLocaleDateString('es-ES')}
                  </span>
                </div>
              )}

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
                <span>Eliminar Plato</span>
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
