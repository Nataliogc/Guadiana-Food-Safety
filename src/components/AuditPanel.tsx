import React, { useState } from 'react';
import { 
  ShieldCheck, 
  AlertTriangle, 
  FileCheck2, 
  Users2, 
  ClipboardCheck, 
  Printer, 
  AlertCircle,
  HelpCircle,
  FileWarning,
  CheckCircle,
  Clock
} from 'lucide-react';

interface FoodItem {
  id: string;
  area: string;
  category: string;
  name: string;
  ingredients: string | null;
  allergen_codes: string | null;
  allergens: string | null;
  traces: string | null;
  status: string;
  preparation: string | null;
  supplier_notes: string | null;
  validated_by?: string | null;
  validated_at?: string | null;
}

interface Supplier {
  id: string;
  name: string;
  phone: string | null;
  email: string | null;
  products: string | null;
  technical_sheet_available: boolean;
  notes: string | null;
}

interface Task {
  id: string;
  title: string;
  area: string;
  priority: string;
  status: string;
}

interface AuditPanelProps {
  items: FoodItem[];
  suppliers: Supplier[];
  tasks: Task[];
  userRole: string;
  onEditItem?: (item: FoodItem) => void;
  onEditSupplier?: (supplier: Supplier) => void;
}

export const AuditPanel: React.FC<AuditPanelProps> = ({
  items,
  suppliers,
  tasks,
  userRole,
  onEditItem,
  onEditSupplier
}) => {
  const [activeTab, setActiveTab] = useState<'kpis' | 'inspeccion'>('kpis');
  const [filterGap, setFilterGap] = useState<'all' | 'no_ingredients' | 'no_allergens' | 'no_validated' | 'no_tech_sheet'>('all');

  const canEdit = userRole === 'admin' || userRole === 'cocina';

  // Calculations for gaps
  const noIngredients = items.filter(item => !item.ingredients || item.ingredients.trim() === '');
  const noAllergens = items.filter(item => !item.allergen_codes || item.allergen_codes.trim() === '');
  const noValidated = items.filter(item => item.status !== 'validado');
  const inRevision = items.filter(item => item.status === 'en_revision');
  const validatedItems = items.filter(item => item.status === 'validado');
  const noTechSheet = suppliers.filter(sup => !sup.technical_sheet_available);
  const criticalTasks = tasks.filter(t => (t.priority === 'critica' || t.priority === 'alta') && t.status !== 'completada');

  // Percentages
  const pctValidated = items.length > 0 ? Math.round((validatedItems.length / items.length) * 100) : 0;
  const pctWithIngredients = items.length > 0 ? Math.round(((items.length - noIngredients.length) / items.length) * 100) : 0;
  const pctWithTechSheet = suppliers.length > 0 ? Math.round(((suppliers.length - noTechSheet.length) / suppliers.length) * 100) : 0;

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="audit-view-container">
      {/* Tab Navigation */}
      <div style={{ display: 'flex', gap: '12px', marginBottom: '24px', borderBottom: '1px solid var(--color-border)', paddingBottom: '12px' }} className="no-print">
        <button 
          className={`btn ${activeTab === 'kpis' ? 'btn-primary' : 'btn-outline'}`}
          onClick={() => setActiveTab('kpis')}
          style={{ display: 'flex', alignItems: 'center', gap: '8px' }}
        >
          <ShieldCheck size={18} />
          <span>Estado del Plan y Auditoría</span>
        </button>
        <button 
          className={`btn ${activeTab === 'inspeccion' ? 'btn-primary' : 'btn-outline'}`}
          onClick={() => setActiveTab('inspeccion')}
          style={{ display: 'flex', alignItems: 'center', gap: '8px' }}
        >
          <Printer size={18} />
          <span>Dossier de Inspección Sanitaria</span>
        </button>
      </div>

      {activeTab === 'kpis' ? (
        <div className="no-print">
          {/* KPI Dashboard Cards */}
          <div className="stats-grid" style={{ marginBottom: '24px' }}>
            <div className="stat-card" style={{ flexDirection: 'column', alignItems: 'flex-start', gap: '8px' }}>
              <span className="stat-label">Validación de Platos</span>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
                <span className="stat-value" style={{ color: pctValidated === 100 ? 'var(--color-success)' : 'var(--color-primary)' }}>{pctValidated}%</span>
                <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>({validatedItems.length} de {items.length} validados)</span>
              </div>
              <div style={{ width: '100%', height: '6px', backgroundColor: 'var(--color-border)', borderRadius: '3px', overflow: 'hidden', marginTop: '4px' }}>
                <div style={{ width: `${pctValidated}%`, height: '100%', backgroundColor: pctValidated === 100 ? 'var(--color-success)' : 'var(--color-secondary)' }}></div>
              </div>
            </div>

            <div className="stat-card" style={{ flexDirection: 'column', alignItems: 'flex-start', gap: '8px' }}>
              <span className="stat-label">Ingredientes Completados</span>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
                <span className="stat-value">{pctWithIngredients}%</span>
                <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>({items.length - noIngredients.length} de {items.length})</span>
              </div>
              <div style={{ width: '100%', height: '6px', backgroundColor: 'var(--color-border)', borderRadius: '3px', overflow: 'hidden', marginTop: '4px' }}>
                <div style={{ width: `${pctWithIngredients}%`, height: '100%', backgroundColor: 'var(--color-primary)' }}></div>
              </div>
            </div>

            <div className="stat-card" style={{ flexDirection: 'column', alignItems: 'flex-start', gap: '8px' }}>
              <span className="stat-label">Fichas Técnicas Proveedor</span>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
                <span className="stat-value">{pctWithTechSheet}%</span>
                <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>({suppliers.length - noTechSheet.length} de {suppliers.length})</span>
              </div>
              <div style={{ width: '100%', height: '6px', backgroundColor: 'var(--color-border)', borderRadius: '3px', overflow: 'hidden', marginTop: '4px' }}>
                <div style={{ width: `${pctWithTechSheet}%`, height: '100%', backgroundColor: 'var(--color-secondary)' }}></div>
              </div>
            </div>
          </div>

          {/* Detailed Gaps Audit Selector */}
          <div className="panel">
            <div className="panel-header" style={{ marginBottom: '16px' }}>
              <h3>Detector de Puntos Incompletos y Gaps Operativos</h3>
            </div>
            
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px', marginBottom: '16px' }}>
              <button 
                onClick={() => setFilterGap('all')} 
                className={`btn btn-small ${filterGap === 'all' ? 'btn-secondary' : 'btn-outline'}`}
              >
                Todos los platos ({items.length})
              </button>
              <button 
                onClick={() => setFilterGap('no_ingredients')} 
                className={`btn btn-small ${filterGap === 'no_ingredients' ? 'btn-danger' : 'btn-outline'}`}
                style={{ color: noIngredients.length > 0 ? '#b91c1c' : undefined }}
              >
                <FileWarning size={12} />
                Sin ingredientes ({noIngredients.length})
              </button>
              <button 
                onClick={() => setFilterGap('no_allergens')} 
                className={`btn btn-small ${filterGap === 'no_allergens' ? 'btn-danger' : 'btn-outline'}`}
                style={{ color: noAllergens.length > 0 ? '#b91c1c' : undefined }}
              >
                <AlertTriangle size={12} />
                Sin alérgenos ({noAllergens.length})
              </button>
              <button 
                onClick={() => setFilterGap('no_validated')} 
                className={`btn btn-small ${filterGap === 'no_validated' ? 'btn-danger' : 'btn-outline'}`}
                style={{ color: noValidated.length > 0 ? '#c2410c' : undefined }}
              >
                <Clock size={12} />
                Pendientes Validar ({noValidated.length})
              </button>
              <button 
                onClick={() => setFilterGap('no_tech_sheet')} 
                className={`btn btn-small ${filterGap === 'no_tech_sheet' ? 'btn-danger' : 'btn-outline'}`}
                style={{ color: noTechSheet.length > 0 ? '#c2410c' : undefined }}
              >
                <Users2 size={12} />
                Proveedores sin Ficha ({noTechSheet.length})
              </button>
            </div>

            {/* Gap List Display */}
            {filterGap === 'no_tech_sheet' ? (
              <div className="table-responsive">
                {noTechSheet.length > 0 ? (
                  <table>
                    <thead>
                      <tr>
                        <th>Nombre del Proveedor</th>
                        <th>Productos</th>
                        <th>Observaciones</th>
                        {canEdit && <th>Acciones</th>}
                      </tr>
                    </thead>
                    <tbody>
                      {noTechSheet.map(sup => (
                        <tr key={sup.id}>
                          <td><strong>{sup.name}</strong></td>
                          <td>{sup.products || '—'}</td>
                          <td><span style={{ color: 'var(--color-danger)', fontWeight: 500 }}><AlertCircle size={12} style={{ marginRight: '4px', verticalAlign: 'middle' }} />Ficha técnica pendiente</span></td>
                          {canEdit && onEditSupplier && (
                            <td>
                              <button className="btn btn-outline btn-small" onClick={() => onEditSupplier(sup)}>Editar</button>
                            </td>
                          )}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : (
                  <p style={{ textAlign: 'center', padding: '24px', color: 'var(--color-success)', fontWeight: 600 }}>
                    ✓ Todos los proveedores tienen su ficha técnica registrada y al día.
                  </p>
                )}
              </div>
            ) : (
              <div className="table-responsive">
                {(() => {
                  let filteredList = items;
                  if (filterGap === 'no_ingredients') filteredList = noIngredients;
                  if (filterGap === 'no_allergens') filteredList = noAllergens;
                  if (filterGap === 'no_validated') filteredList = noValidated;

                  if (filteredList.length > 0) {
                    return (
                      <table>
                        <thead>
                          <tr>
                            <th>Área</th>
                            <th>Categoría</th>
                            <th>Nombre del Plato</th>
                            <th>Ingredientes</th>
                            <th>Alérgenos</th>
                            <th>Estado</th>
                            {canEdit && onEditItem && <th>Acciones</th>}
                          </tr>
                        </thead>
                        <tbody>
                          {filteredList.map(item => (
                            <tr key={item.id}>
                              <td><strong>{item.area}</strong></td>
                              <td>{item.category}</td>
                              <td>{item.name}</td>
                              <td>
                                {!item.ingredients || item.ingredients.trim() === '' ? (
                                  <span style={{ color: 'var(--color-danger)', fontWeight: 500, fontSize: '0.8rem' }}>
                                    <AlertCircle size={12} style={{ marginRight: '4px', verticalAlign: 'middle' }} /> Sin ingredientes
                                  </span>
                                ) : (
                                  <span style={{ fontSize: '0.8rem', display: 'block', maxWidth: '200px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                                    {item.ingredients}
                                  </span>
                                )}
                              </td>
                              <td>
                                {!item.allergen_codes || item.allergen_codes.trim() === '' ? (
                                  <span style={{ color: 'var(--color-danger)', fontWeight: 500, fontSize: '0.8rem' }}>
                                    <AlertCircle size={12} style={{ marginRight: '4px', verticalAlign: 'middle' }} /> Declarar alérgenos
                                  </span>
                                ) : (
                                  <span className="badge" style={{ backgroundColor: 'var(--color-primary)', color: '#fff', fontSize: '0.75rem' }}>
                                    Cod. {item.allergen_codes}
                                  </span>
                                )}
                              </td>
                              <td>
                                <span className={`badge ${item.status}`}>
                                  {item.status === 'validado' ? 'Validado' : item.status === 'en_revision' ? 'En Revisión' : 'Pendiente'}
                                </span>
                              </td>
                              {canEdit && onEditItem && (
                                <td>
                                  <button className="btn btn-outline btn-small" onClick={() => onEditItem(item)}>Editar</button>
                                </td>
                              )}
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    );
                  } else {
                    return (
                      <p style={{ textAlign: 'center', padding: '24px', color: 'var(--color-success)', fontWeight: 600 }}>
                        ✓ No se detectaron platos con esta incidencia.
                      </p>
                    );
                  }
                })()}
              </div>
            )}
          </div>
        </div>
      ) : (
        /* Printable inspection dossier */
        <div className="printable-dossier-panel">
          <div className="panel no-print" style={{ marginBottom: '20px', backgroundColor: '#fcfcf9', borderLeft: '4px solid var(--color-secondary)' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <h4 style={{ color: 'var(--color-primary)', fontWeight: 600 }}>Dossier de Inspección y Sanidad listo para Imprimir</h4>
                <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                  Este documento genera un informe formal que contiene únicamente los platos y productos **validados** por el departamento de cocina del Hotel Guadiana, ordenados por área de servicio, junto con sus alérgenos y trazas declaradas. Cumple con la normativa europea Reglamento (UE) Nº 1169/2011.
                </p>
              </div>
              <button className="btn btn-primary" onClick={handlePrint} style={{ flexShrink: 0 }}>
                <Printer size={16} />
                <span>Imprimir Dossier</span>
              </button>
            </div>
          </div>

          {/* Dossier Document Sheet */}
          <div className="dossier-document-sheet" style={{ backgroundColor: '#ffffff', padding: '40px', border: '1px solid #d1d5db', borderRadius: 'var(--radius-lg)' }}>
            
            {/* Header Document */}
            <div style={{ borderBottom: '2px solid #000000', paddingBottom: '20px', marginBottom: '30px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <div>
                <h1 style={{ fontSize: '2rem', fontFamily: 'var(--font-serif)', color: '#0d3822', margin: 0 }}>FOOD SAFETY</h1>
                <p style={{ fontSize: '0.9rem', color: '#c5a059', fontWeight: 600, letterSpacing: '1px', textTransform: 'uppercase', margin: '4px 0 0 0' }}>
                  Plan de Gestión de Alérgenos alimentarios
                </p>
                <p style={{ fontSize: '0.85rem', color: '#4b5563', margin: '4px 0 0 0' }}>
                  Hotel Guadiana **** · Ciudad Real, España
                </p>
              </div>
              <div style={{ textAlign: 'right', fontSize: '0.85rem', color: '#4b5563' }}>
                <p><strong>Fecha de Generación:</strong> {new Date().toLocaleDateString('es-ES')}</p>
                <p><strong>Estado del Plan:</strong> {pctValidated}% Validado</p>
                <p><strong>Documentación Oficial para:</strong> Inspección Sanitaria</p>
              </div>
            </div>

            {/* Official Introduction */}
            <div style={{ marginBottom: '30px', fontSize: '0.85rem', lineHeight: '1.5', color: '#374151', padding: '12px 16px', border: '1px solid #e5e7eb', backgroundColor: '#f9fafb', borderRadius: 'var(--radius-sm)' }}>
              <strong>DECLARACIÓN DE CUMPLIMIENTO REGLAMENTO (UE) Nº 1169/2011:</strong><br />
              El presente registro contiene la recopilación sistemática de ingredientes, alérgenos y trazas declaradas en las elaboraciones servidas en el Hotel Guadiana. Este plan de control ha sido supervisado y firmado por el departamento de cocina del establecimiento. Toda modificación de ingredientes de proveedores exige la actualización inmediata del presente registro.
            </div>

            {/* Grouped Validated Dishes */}
            <h3 style={{ fontSize: '1.25rem', borderBottom: '1px solid #000000', paddingBottom: '6px', marginBottom: '16px', color: '#0d3822' }}>
              1. REGISTRO DE ELABORACIONES Y PLATOS VALIDADOS
            </h3>

            {validatedItems.length > 0 ? (
              <div>
                {/* Group by Area */}
                {Array.from(new Set(validatedItems.map(x => x.area))).map(area => {
                  const areaDishes = validatedItems.filter(d => d.area === area);
                  return (
                    <div key={area} style={{ marginBottom: '30px', pageBreakInside: 'avoid' }}>
                      <h4 style={{ fontSize: '1.05rem', backgroundColor: '#f3f4f6', padding: '6px 12px', borderLeft: '3px solid #c5a059', color: '#0d3822', margin: '0 0 10px 0' }}>
                        Área: {area}
                      </h4>

                      <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.8rem', textAlign: 'left', marginBottom: '10px' }}>
                        <thead>
                          <tr style={{ borderBottom: '1px solid #000000' }}>
                            <th style={{ padding: '8px', width: '20%' }}>Categoría</th>
                            <th style={{ padding: '8px', width: '25%' }}>Nombre del Plato</th>
                            <th style={{ padding: '8px', width: '35%' }}>Ingredientes declarados</th>
                            <th style={{ padding: '8px', width: '20%' }}>Alérgenos (Trazas)</th>
                          </tr>
                        </thead>
                        <tbody>
                          {areaDishes.map(dish => (
                            <tr key={dish.id} style={{ borderBottom: '1px dotted #d1d5db' }}>
                              <td style={{ padding: '8px' }}>{dish.category}</td>
                              <td style={{ padding: '8px' }}><strong>{dish.name}</strong></td>
                              <td style={{ padding: '8px', color: '#4b5563', fontSize: '0.75rem' }}>{dish.ingredients || '—'}</td>
                              <td style={{ padding: '8px' }}>
                                <span style={{ fontWeight: 'bold', color: '#b91c1c' }}>
                                  {dish.allergens || 'Ninguno'}
                                </span>
                                {dish.traces && (
                                  <span style={{ fontSize: '0.75rem', color: '#6b7280', display: 'block' }}>
                                    (Trazas: {dish.traces})
                                  </span>
                                )}
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  );
                })}
              </div>
            ) : (
              <p style={{ fontStyle: 'italic', color: 'var(--color-danger)', padding: '12px' }}>
                Atención: No hay ningún plato con el estado "Validado" todavía en el sistema. Asegúrate de que cocina valide los platos correspondientes.
              </p>
            )}

            {/* Validated Suppliers List */}
            <h3 style={{ fontSize: '1.25rem', borderBottom: '1px solid #000000', paddingBottom: '6px', marginTop: '40px', marginBottom: '16px', color: '#0d3822', pageBreakBefore: 'always' }}>
              2. REGISTRO DE PROVEEDORES Y VERIFICACIÓN DE FICHAS TÉCNICAS
            </h3>
            
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.8rem', textAlign: 'left' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid #000000' }}>
                  <th style={{ padding: '8px', width: '30%' }}>Proveedor</th>
                  <th style={{ padding: '8px', width: '40%' }}>Productos Suministrados</th>
                  <th style={{ padding: '8px', width: '30%' }}>Estado Ficha Técnica</th>
                </tr>
              </thead>
              <tbody>
                {suppliers.map(sup => (
                  <tr key={sup.id} style={{ borderBottom: '1px dotted #d1d5db' }}>
                    <td style={{ padding: '8px' }}><strong>{sup.name}</strong></td>
                    <td style={{ padding: '8px', color: '#4b5563' }}>{sup.products || '—'}</td>
                    <td style={{ padding: '8px' }}>
                      {sup.technical_sheet_available ? (
                        <span style={{ color: '#047857', fontWeight: 600 }}>✓ Verificada y Archivada</span>
                      ) : (
                        <span style={{ color: '#b91c1c', fontWeight: 600 }}>⚠ PENDIENTE</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            {/* Signatures */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '40px', marginTop: '60px', pageBreakInside: 'avoid' }}>
              <div style={{ textAlign: 'center', borderTop: '1px solid #9ca3af', paddingTop: '10px', fontSize: '0.8rem' }}>
                <p><strong>Firma Responsable Cocina:</strong></p>
                <p style={{ marginTop: '40px', color: '#9ca3af' }}>[Firma del Chef / Validador]</p>
              </div>
              <div style={{ textAlign: 'center', borderTop: '1px solid #9ca3af', paddingTop: '10px', fontSize: '0.8rem' }}>
                <p><strong>Firma Dirección Hotel Guadiana:</strong></p>
                <p style={{ marginTop: '40px', color: '#9ca3af' }}>[Sello y Firma Dirección]</p>
              </div>
            </div>

          </div>
        </div>
      )}
    </div>
  );
};
