import React, { useState, useMemo } from 'react';
import { Search, Plus, Filter, FileText, CheckCircle2, AlertTriangle, Eye } from 'lucide-react';

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
  created_at: string;
  updated_at: string;
}

interface FoodItemsTableProps {
  items: FoodItem[];
  userRole: string;
  onEditItem: (item: FoodItem) => void;
  onNewItem: () => void;
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

const STATUSES = [
  { id: 'pendiente', label: 'Pendiente' },
  { id: 'en_revision', label: 'En revisión' },
  { id: 'validado', label: 'Validado' }
];

const ALLERGEN_NAMES: Record<number, { name: string; letter: string }> = {
  1: { name: 'Pescado', letter: 'PE' },
  2: { name: 'Frutos secos', letter: 'FS' },
  3: { name: 'Lácteos', letter: 'LA' },
  4: { name: 'Moluscos', letter: 'MO' },
  5: { name: 'Gluten', letter: 'GL' },
  6: { name: 'Crustáceos', letter: 'CR' },
  7: { name: 'Huevos', letter: 'HU' },
  8: { name: 'Cacahuetes', letter: 'CA' },
  9: { name: 'Soja', letter: 'SO' },
  10: { name: 'Apio', letter: 'AP' },
  11: { name: 'Mostaza', letter: 'MS' },
  12: { name: 'Sésamo', letter: 'SE' },
  13: { name: 'Altramuz', letter: 'AL' },
  14: { name: 'Sulfitos', letter: 'SU' }
};

export const FoodItemsTable: React.FC<FoodItemsTableProps> = ({
  items,
  userRole,
  onEditItem,
  onNewItem
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [areaFilter, setAreaFilter] = useState('');
  const [statusFilter, setStatusFilter] = useState('');

  const parseAllergenCodes = (codesStr: string | null): number[] => {
    if (!codesStr) return [];
    return codesStr
      .split(/[,/;\s]+/)
      .map(code => parseInt(code.trim(), 10))
      .filter(num => !isNaN(num) && num >= 1 && num <= 14);
  };

  const filteredItems = useMemo(() => {
    return items.filter(item => {
      const matchSearch = 
        item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (item.ingredients || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (item.allergens || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (item.category || '').toLowerCase().includes(searchTerm.toLowerCase());

      const matchArea = !areaFilter || item.area === areaFilter;
      const matchStatus = !statusFilter || item.status === statusFilter;

      return matchSearch && matchArea && matchStatus;
    });
  }, [items, searchTerm, areaFilter, statusFilter]);

  const canEdit = userRole === 'admin' || userRole === 'cocina';

  return (
    <div className="panel">
      <div className="panel-header">
        <h3>Catálogo de Platos e Ingredientes</h3>
        {canEdit && (
          <button className="btn btn-primary" onClick={onNewItem}>
            <Plus size={16} />
            <span>Nuevo Plato</span>
          </button>
        )}
      </div>

      {/* Filter Toolbar */}
      <div className="toolbar">
        <div className="search-input-wrap">
          <Search size={18} />
          <input 
            type="text" 
            placeholder="Buscar por plato, ingrediente, alérgeno..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="search-input"
          />
        </div>

        <select 
          value={areaFilter}
          onChange={(e) => setAreaFilter(e.target.value)}
          className="filter-select"
        >
          <option value="">Todas las áreas</option>
          {AREAS.map(area => (
            <option key={area} value={area}>{area}</option>
          ))}
        </select>

        <select 
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="filter-select"
        >
          <option value="">Todos los estados</option>
          {STATUSES.map(st => (
            <option key={st.id} value={st.id}>{st.label}</option>
          ))}
        </select>

        <div style={{ marginLeft: 'auto', display: 'flex', gap: '8px' }}>
          <button 
            className="btn btn-outline" 
            onClick={() => window.print()}
            title="Imprimir catálogo filtrado"
          >
            <FileText size={16} />
            <span>Imprimir</span>
          </button>
        </div>
      </div>

      {/* Data Table */}
      <div className="table-responsive">
        {filteredItems.length > 0 ? (
          <table>
            <thead>
              <tr>
                <th>Área</th>
                <th>Categoría</th>
                <th>Plato / Producto</th>
                <th>Alérgenos (Códigos)</th>
                <th>Ingredientes</th>
                <th>Trazas / Alertas</th>
                <th>Estado</th>
                <th style={{ width: '100px' }}>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filteredItems.map(item => {
                const codes = parseAllergenCodes(item.allergen_codes);
                return (
                  <tr key={item.id}>
                    <td><strong>{item.area || 'General'}</strong></td>
                    <td><span style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>{item.category}</span></td>
                    <td>
                      <div style={{ fontWeight: '600', color: 'var(--color-primary)' }}>{item.name}</div>
                    </td>
                    <td>
                      <div className="allergens-tags-list">
                        {Array.from({ length: 14 }, (_, idx) => {
                          const num = idx + 1;
                          const isActive = codes.includes(num);
                          const allergenInfo = ALLERGEN_NAMES[num];
                          return (
                            <span 
                              key={num} 
                              className={`allergen-tag ${isActive ? 'active' : ''}`}
                              title={`${num}: ${allergenInfo.name}`}
                            >
                              {allergenInfo.letter}
                            </span>
                          );
                        })}
                      </div>
                    </td>
                    <td>
                      <p style={{ 
                        fontSize: '0.82rem', 
                        color: 'var(--color-text-main)',
                        maxWidth: '240px',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        display: '-webkit-box',
                        WebkitLineClamp: 3,
                        WebkitBoxOrient: 'vertical'
                      }}>
                        {item.ingredients || '—'}
                      </p>
                    </td>
                    <td>
                      <span style={{ fontSize: '0.8rem', color: '#b91c1c', fontWeight: '500' }}>
                        {item.traces ? `Trazas: ${item.traces}` : 'Sin trazas declaradas'}
                      </span>
                    </td>
                    <td>
                      <span className={`badge ${item.status || 'pendiente'}`}>
                        {item.status === 'validado' ? 'Validado' : item.status === 'en_revision' ? 'En revisión' : 'Pendiente'}
                      </span>
                    </td>
                    <td>
                      <button 
                        onClick={() => onEditItem(item)}
                        className={`btn btn-outline btn-small ${canEdit ? 'btn-secondary' : ''}`}
                        style={{ display: 'flex', alignItems: 'center', gap: '4px' }}
                      >
                        {canEdit ? (
                          <><span>Editar</span></>
                        ) : (
                          <>
                            <Eye size={12} />
                            <span>Ver</span>
                          </>
                        )}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        ) : (
          <p style={{ textAlign: 'center', padding: '40px', color: 'var(--color-text-muted)' }}>
            No se encontraron platos que coincidan con los filtros de búsqueda.
          </p>
        )}
      </div>
    </div>
  );
};
