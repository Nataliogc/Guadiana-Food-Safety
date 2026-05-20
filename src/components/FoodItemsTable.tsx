import React, { useState, useMemo } from 'react';
import { Search, Plus, Filter, FileText, CheckCircle2, AlertTriangle, Eye } from 'lucide-react';
import { ALLERGENS_LIST, ALLERGEN_MAP, parseAllergenCodes } from '../utils/allergens';

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

export const FoodItemsTable: React.FC<FoodItemsTableProps> = ({
  items,
  userRole,
  onEditItem,
  onNewItem
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [areaFilter, setAreaFilter] = useState('');
  const [statusFilter, setStatusFilter] = useState('');

  const filteredItems = useMemo(() => {
    return items.filter(item => {
      const searchTrimmed = searchTerm.trim();
      const searchNum = parseInt(searchTrimmed, 10);
      const isSearchNum = !isNaN(searchNum) && searchNum >= 1 && searchNum <= 14;
      const matchAllergenCode = isSearchNum && parseAllergenCodes(item.allergen_codes).includes(searchNum);

      const matchSearch = 
        item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (item.ingredients || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (item.allergens || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        (item.category || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
        matchAllergenCode;

      const matchArea = !areaFilter || item.area === areaFilter;
      const matchStatus = !statusFilter || item.status === statusFilter;

      return matchSearch && matchArea && matchStatus;
    });
  }, [items, searchTerm, areaFilter, statusFilter]);

  const canEdit = userRole === 'admin' || userRole === 'cocina' || userRole === 'gestor';

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
                        {codes.length > 0 ? (
                          codes.map(num => {
                            const name = ALLERGEN_MAP[num] || 'Alérgeno';
                            const label = `${num}. ${name}`;
                            return (
                              <span 
                                key={num} 
                                className="allergen-tag active"
                                title={label}
                                aria-label={label}
                              >
                                {num}
                              </span>
                            );
                          })
                        ) : (
                          <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>Ninguno</span>
                        )}
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

      {/* Legend Block */}
      <div style={{ marginTop: '20px', padding: '15px 20px', backgroundColor: '#f9fafb', borderRadius: 'var(--radius-md)', border: '1px solid var(--color-border)' }}>
        <h4 style={{ margin: '0 0 10px 0', fontSize: '0.9rem', color: 'var(--color-primary)', display: 'flex', alignItems: 'center', gap: '6px' }}>
          <FileText size={16} />
          <span>Numeración interna de alérgenos utilizada por el Hotel Guadiana</span>
        </h4>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))', gap: '8px', fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>
          {ALLERGENS_LIST.map(alg => (
            <div key={alg.code} style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              <span className="allergen-tag active" style={{ width: '18px', height: '18px', fontSize: '0.65rem', borderRadius: '3px', flexShrink: 0 }}>
                {alg.code}
              </span>
              <span>{alg.name}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
