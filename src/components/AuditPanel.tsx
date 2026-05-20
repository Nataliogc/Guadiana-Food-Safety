import React, { useState, useEffect } from 'react';
import { supabase } from '../utils/supabase';
import { 
  ShieldCheck, 
  Printer, 
  Download, 
  FileText, 
  AlertTriangle, 
  CheckCircle, 
  Clock, 
  Users2, 
  Activity, 
  ListOrdered,
  FileSpreadsheet,
  AlertCircle,
  BookOpen,
  Calendar,
  Lock
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

interface GeneratedReportLog {
  id: string;
  generated_at: string;
  report_type: string;
  filters_used: any;
  total_items: number;
  pending_items: number;
  validated_items: number;
  notes: string | null;
  profiles?: { email: string; full_name: string } | null;
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
  const [activeSubTab, setActiveSubTab] = useState<'generator' | 'logs'>('generator');
  const [isGenerated, setIsGenerated] = useState(false);
  
  // Filter states
  const [reportFilter, setReportFilter] = useState<string>('completo');
  const [notesText, setNotesText] = useState<string>('');
  
  // Logs states
  const [reportLogs, setReportLogs] = useState<any[]>([]);
  const [auditLogs, setAuditLogs] = useState<any[]>([]);
  const [profilesMap, setProfilesMap] = useState<Record<string, string>>({});
  const [loadingHistory, setLoadingHistory] = useState(false);

  const isAdmin = userRole === 'admin';
  const canGenerateFull = userRole === 'admin' || userRole === 'cocina';

  // Load audit logs and generated reports logs
  const loadHistoryData = async () => {
    setLoadingHistory(true);
    try {
      // 1. Fetch profiles to map user IDs to names/emails
      const { data: profiles } = await supabase
        .from('profiles')
        .select('id, email, full_name');
      
      const map: Record<string, string> = {};
      if (profiles) {
        profiles.forEach(p => {
          map[p.id] = p.full_name || p.email || 'Usuario';
        });
        setProfilesMap(map);
      }

      // 2. Fetch generated reports
      const { data: reports } = await supabase
        .from('generated_reports')
        .select('*')
        .order('generated_at', { ascending: false });
      
      setReportLogs(reports || []);

      // 3. Fetch audit logs if admin
      if (isAdmin) {
        const { data: audits } = await supabase
          .from('audit_log')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(20);
        
        setAuditLogs(audits || []);
      }
    } catch (err) {
      console.error("Error loading report logs:", err);
    } finally {
      setLoadingHistory(false);
    }
  };

  useEffect(() => {
    loadHistoryData();
  }, [userRole]);

  // Calculations for gaps and items based on filter
  const getFilteredItems = () => {
    switch (reportFilter) {
      case 'completo': return items;
      case 'cafeteria': return items.filter(x => x.area === 'Cafetería');
      case 'restaurante': return items.filter(x => x.area === 'Restaurante');
      case 'desayuno': return items.filter(x => x.area === 'Desayuno Buffet');
      case 'grupos': return items.filter(x => x.area === 'Menús de Grupo');
      case 'deportivo': return items.filter(x => x.area === 'Menú Deportivo');
      case 'cocteles': return items.filter(x => x.area === 'Cócteles');
      case 'pendientes': return items.filter(x => x.status === 'pendiente');
      case 'validados': return items.filter(x => x.status === 'validado');
      case 'trazas': return items.filter(x => x.traces && x.traces.trim() !== '');
      case 'sin_ingredientes': return items.filter(x => !x.ingredients || x.ingredients.trim() === '');
      case 'sin_alergenos': return items.filter(x => !x.allergen_codes || x.allergen_codes.trim() === '');
      default: return items;
    }
  };

  const filteredItems = getFilteredItems();

  // Audit totals for current system state (always calculated on full items list)
  const totalItemsCount = items.length;
  const validatedItems = items.filter(x => x.status === 'validado');
  const pendingItems = items.filter(x => x.status === 'pendiente');
  const revisionItems = items.filter(x => x.status === 'en_revision');
  
  const noIngredients = items.filter(item => !item.ingredients || item.ingredients.trim() === '');
  const noAllergens = items.filter(item => !item.allergen_codes || item.allergen_codes.trim() === '');
  const noPreparation = items.filter(item => !item.preparation || item.preparation.trim() === '');
  const noStatus = items.filter(item => !item.status);
  
  const incompleteBreakfast = items.filter(x => x.area === 'Desayuno Buffet' && (x.status !== 'validado' || !x.ingredients || !x.allergen_codes));
  const incompleteGroups = items.filter(x => x.area === 'Menús de Grupo' && (x.status !== 'validado' || !x.ingredients || !x.allergen_codes));
  
  const totalSuppliersCount = suppliers.length;
  const suppliersWithTech = suppliers.filter(s => s.technical_sheet_available);
  const suppliersNoTech = suppliers.filter(s => !s.technical_sheet_available);
  const suppliersNoPhone = suppliers.filter(s => !s.phone || s.phone.trim() === '');
  
  const criticalTasks = tasks.filter(t => (t.priority === 'critica' || t.priority === 'alta') && t.status !== 'completada');

  // Overall Plan Status
  const getOverallState = () => {
    const pct = totalItemsCount > 0 ? (validatedItems.length / totalItemsCount) * 100 : 0;
    if (pct === 100) return 'Validado';
    if (pct >= 90) return 'Validado parcialmente';
    if (pct > 0) return 'En revisión';
    return 'Borrador';
  };

  const getOverallBadgeClass = (state: string) => {
    switch (state) {
      case 'Validado': return 'validado';
      case 'Validado parcialmente': return 'en_revision';
      case 'En revisión': return 'pendiente';
      default: return 'pendiente';
    }
  };

  // Trigger report generation and log it in DB
  const handleGenerateReport = async () => {
    setIsGenerated(true);
    try {
      const { data: { user } } = await supabase.auth.getUser();
      const userId = user ? user.id : null;

      const { error } = await supabase
        .from('generated_reports')
        .insert({
          generated_by: userId,
          report_type: `Informe Sanidad - Filtro: ${reportFilter}`,
          filters_used: {
            filter: reportFilter,
            notes_included: !!notesText
          },
          total_items: filteredItems.length,
          pending_items: filteredItems.filter(x => x.status === 'pendiente').length,
          validated_items: filteredItems.filter(x => x.status === 'validado').length,
          notes: notesText || null
        });

      if (error) throw error;
      loadHistoryData(); // Refresh history log
    } catch (err) {
      console.error("Error logging generated report:", err);
    }
  };

  // Export to CSV
  const handleExportCSV = () => {
    const headers = [
      'Area', 'Categoria', 'Nombre del Plato', 'Ingredientes', 
      'Codigos Alergenos', 'Alergenos Declarados', 'Posibles Trazas', 
      'Elaboracion', 'Estado', 'Validado Por', 'Fecha Validacion', 'Observaciones'
    ];

    const rows = filteredItems.map(item => [
      `"${(item.area || '').replace(/"/g, '""')}"`,
      `"${(item.category || '').replace(/"/g, '""')}"`,
      `"${(item.name || '').replace(/"/g, '""')}"`,
      `"${(item.ingredients || '').replace(/"/g, '""')}"`,
      `"${(item.allergen_codes || '').replace(/"/g, '""')}"`,
      `"${(item.allergens || '').replace(/"/g, '""')}"`,
      `"${(item.traces || '').replace(/"/g, '""')}"`,
      `"${(item.preparation || '').replace(/"/g, '""')}"`,
      `"${(item.status || '').replace(/"/g, '""')}"`,
      `"${(item.validated_by || '').replace(/"/g, '""')}"`,
      `"${(item.validated_at || '').replace(/"/g, '""')}"`,
      `"${(item.supplier_notes || '').replace(/"/g, '""')}"`
    ]);

    const csvContent = "\uFEFF" + [headers.join(','), ...rows.map(e => e.join(','))].join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.setAttribute("href", url);
    link.setAttribute("download", `informe_alergenos_${reportFilter}_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Export to JSON
  const handleExportJSON = () => {
    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify({
      informe_metadata: {
        titulo: "Informe de Gestión de Alérgenos",
        establecimiento: "Hotel Guadiana",
        cif: "B13590997",
        empresa: "GLOBAL DE SERVICIOS CIUDAD REAL, S.L.",
        fecha_emision: new Date().toLocaleDateString('es-ES'),
        filtro: reportFilter,
        estado_global: getOverallState()
      },
      platos: filteredItems,
      proveedores: suppliers,
      tareas_criticas: criticalTasks
    }, null, 2));

    const downloadAnchor = document.createElement('a');
    downloadAnchor.setAttribute("href", dataStr);
    downloadAnchor.setAttribute("download", `informe_alergenos_${reportFilter}_${new Date().toISOString().split('T')[0]}.json`);
    document.body.appendChild(downloadAnchor);
    downloadAnchor.click();
    downloadAnchor.remove();
  };

  return (
    <div className="audit-view-container">
      {/* Sub tabs navigation */}
      <div style={{ display: 'flex', gap: '12px', marginBottom: '20px', borderBottom: '1px solid var(--color-border)', paddingBottom: '10px' }} className="no-print">
        <button 
          className={`btn btn-small ${activeSubTab === 'generator' ? 'btn-primary' : 'btn-outline'}`}
          onClick={() => { setActiveSubTab('generator'); }}
          style={{ display: 'flex', alignItems: 'center', gap: '6px' }}
        >
          <FileText size={16} />
          <span>Generador de Informe</span>
        </button>
        <button 
          className={`btn btn-small ${activeSubTab === 'logs' ? 'btn-primary' : 'btn-outline'}`}
          onClick={() => { setActiveSubTab('logs'); }}
          style={{ display: 'flex', alignItems: 'center', gap: '6px' }}
        >
          <Activity size={16} />
          <span>Historial y Control de Cambios</span>
        </button>
      </div>

      {activeSubTab === 'generator' ? (
        !isGenerated ? (
          /* Report configuration view */
          <div className="panel no-print" style={{ maxWidth: '600px', margin: '0 auto' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '16px' }}>
              <ShieldCheck size={24} style={{ color: 'var(--color-primary)' }} />
              <h3>Configurar Informe de Sanidad</h3>
            </div>
            
            <p style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', marginBottom: '20px' }}>
              Genera un documento oficial estructurado del plan de alérgenos. Puedes aplicar filtros específicos para exportar secciones particulares del hotel o verificar incidencias.
            </p>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Selecciona el filtro del informe:</label>
                <select 
                  className="filter-select" 
                  value={reportFilter}
                  onChange={(e) => setReportFilter(e.target.value)}
                  style={{ width: '100%', padding: '8px 12px' }}
                >
                  <option value="completo">Informe completo (Todos los platos)</option>
                  <option value="cafeteria">Solo Cafetería</option>
                  <option value="restaurante">Solo Restaurante</option>
                  <option value="desayuno">Solo Desayuno Buffet</option>
                  <option value="grupos">Solo Menús de Grupo</option>
                  <option value="deportivo">Solo Menú Deportivo</option>
                  <option value="cocteles">Solo Cócteles</option>
                  <option value="pendientes">Solo Platos Pendientes</option>
                  <option value="validados">Solo Platos Validados</option>
                  <option value="trazas">Solo platos con Trazas</option>
                  <option value="sin_ingredientes">Solo platos sin Ingredientes</option>
                  <option value="sin_alergenos">Solo platos sin Alérgenos declarados</option>
                </select>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Notas aclaratorias adicionales (opcional):</label>
                <textarea 
                  className="filter-select"
                  placeholder="Añade aquí observaciones sobre el estado de la revisión del plan, incidencias particulares o comentarios para los inspectores de Sanidad..."
                  value={notesText}
                  onChange={(e) => setNotesText(e.target.value)}
                  style={{ width: '100%', minHeight: '80px', padding: '8px 12px', resize: 'vertical' }}
                />
              </div>

              {!canGenerateFull && (
                <div style={{ padding: '10px 14px', backgroundColor: 'rgba(239, 68, 68, 0.08)', border: '1px solid rgba(239, 68, 68, 0.2)', borderRadius: 'var(--radius-sm)', color: '#b91c1c', fontSize: '0.8rem', display: 'flex', gap: '8px', alignItems: 'center' }}>
                  <Lock size={14} />
                  <span>Tu rol no permite la descarga completa de auditoría detallada. Se generará un informe de consulta básico.</span>
                </div>
              )}

              <button 
                className="btn btn-primary" 
                onClick={handleGenerateReport}
                style={{ width: '100%', justifyContent: 'center', padding: '12px' }}
              >
                <BookOpen size={18} />
                <span>Generar Informe Oficial</span>
              </button>
            </div>
          </div>
        ) : (
          /* The generated document view */
          <div>
            {/* Toolbar controls */}
            <div className="panel no-print" style={{ marginBottom: '20px', backgroundColor: '#fcfcf9', borderLeft: '4px solid var(--color-secondary)' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: '12px', alignItems: 'center' }}>
                <div>
                  <h4 style={{ color: 'var(--color-primary)', fontWeight: 600 }}>Informe Generado Correctamente</h4>
                  <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginTop: '2px' }}>
                    Utiliza los controles de la derecha para imprimir o guardar los datos en formatos técnicos oficiales.
                  </p>
                </div>
                
                <div style={{ display: 'flex', gap: '8px' }}>
                  <button className="btn btn-outline btn-small" onClick={() => setIsGenerated(false)}>
                    Configurar otro filtro
                  </button>
                  <button className="btn btn-secondary btn-small" onClick={handleExportCSV}>
                    <FileSpreadsheet size={14} />
                    <span>CSV</span>
                  </button>
                  <button className="btn btn-secondary btn-small" onClick={handleExportJSON}>
                    <Download size={14} />
                    <span>JSON</span>
                  </button>
                  <button className="btn btn-primary btn-small" onClick={() => window.print()}>
                    <Printer size={14} />
                    <span>Imprimir / Guardar PDF</span>
                  </button>
                </div>
              </div>
            </div>

            {/* Document sheet */}
            <div className="dossier-document-sheet" style={{ backgroundColor: '#ffffff', color: '#000', padding: '50px', border: '1px solid #d1d5db', borderRadius: 'var(--radius-lg)', maxWidth: '900px', margin: '0 auto', boxShadow: 'var(--shadow-md)' }}>
              
              {/* PAGE 1: PORTADA */}
              <div className="page-break" style={{ minHeight: '800px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', borderBottom: '2px solid #e5e7eb', paddingBottom: '40px', marginBottom: '40px' }}>
                
                <div style={{ borderBottom: '1px solid #c5a059', paddingBottom: '16px' }}>
                  <p style={{ fontSize: '1rem', fontWeight: 600, color: 'var(--color-primary)', letterSpacing: '2px', textTransform: 'uppercase', margin: 0 }}>
                    Plan de Autocontrol y Seguridad Alimentaria
                  </p>
                  <p style={{ fontSize: '0.9rem', color: 'var(--color-text-muted)', margin: '4px 0 0 0' }}>
                    Reglamento (UE) Nº 1169/2011
                  </p>
                </div>

                <div style={{ margin: '100px 0' }}>
                  <h1 style={{ fontSize: '3rem', fontFamily: 'var(--font-serif)', color: '#0d3822', lineHeight: '1.1', margin: '0 0 10px 0' }}>
                    Informe de Gestión de Alérgenos
                  </h1>
                  <h2 style={{ fontSize: '1.5rem', color: '#c5a059', fontWeight: 500, margin: 0 }}>
                    Hotel Guadiana ****
                  </h2>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '30px', fontSize: '0.85rem', borderTop: '1px solid #c5a059', paddingTop: '20px' }}>
                  <div>
                    <p style={{ margin: '4px 0' }}><strong>Empresa de restauración:</strong> GLOBAL DE SERVICIOS CIUDAD REAL, S.L.</p>
                    <p style={{ margin: '4px 0' }}><strong>CIF:</strong> B13590997</p>
                    <p style={{ margin: '4px 0' }}><strong>Establecimiento:</strong> Hotel Guadiana</p>
                    <p style={{ margin: '4px 0' }}><strong>Dirección:</strong> Ciudad Real, España</p>
                  </div>
                  <div>
                    <p style={{ margin: '4px 0' }}><strong>Fecha de emisión:</strong> {new Date().toLocaleDateString('es-ES')}</p>
                    <p style={{ margin: '4px 0' }}><strong>Versión del informe:</strong> v2.0 (Supabase)</p>
                    <p style={{ margin: '4px 0' }}><strong>Filtro aplicado:</strong> {reportFilter.toUpperCase()}</p>
                    <p style={{ margin: '4px 0', display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <strong>Estado General del Plan:</strong> 
                      <span className={`badge ${getOverallBadgeClass(getOverallState())}`} style={{ display: 'inline-block', fontSize: '0.75rem', fontWeight: 'bold' }}>
                        {getOverallState().toUpperCase()}
                      </span>
                    </p>
                  </div>
                </div>

                <div style={{ fontSize: '0.8rem', color: '#6b7280', marginTop: '40px', fontStyle: 'italic', borderTop: '1px dotted #e5e7eb', paddingTop: '10px' }}>
                  Este documento contiene información interna y confidencial del Hotel Guadiana sobre alérgenos alimentarios para consulta, revisión interna y posible presentación ante inspección sanitaria.
                </div>
              </div>

              {/* SECTION 2: DATOS DEL ESTABLECIMIENTO Y SERVICIOS */}
              <div className="page-break" style={{ marginBottom: '40px', pageBreakBefore: 'always' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  1. DATOS DEL ESTABLECIMIENTO Y SERVICIOS INCLUIDOS
                </h3>
                <p style={{ fontSize: '0.85rem', lineHeight: '1.6', color: '#374151', marginBottom: '14px' }}>
                  El **Hotel Guadiana** es un establecimiento hotelero de cuatro estrellas que dispone de diversos puntos de venta y servicios gastronómicos para huéspedes y eventos privados. El Plan de Alérgenos abarca la totalidad de estos servicios:
                </p>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px', fontSize: '0.82rem', marginBottom: '24px' }}>
                  <ul style={{ paddingLeft: '20px', margin: 0 }}>
                    <li style={{ marginBottom: '6px' }}><strong>Restaurante Principal:</strong> Menú a la carta y especialidades de temporada.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Cafetería del Hotel:</strong> Sándwiches, hamburguesas, tostas y bocadillos.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Desayuno Buffet:</strong> Selección de embutidos, panes, bollería y calientes.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Tapas de Barra:</strong> Raciones tradicionales e innovadoras de bar.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Menú del Día:</strong> Oferta culinaria diaria equilibrada.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Menús Deportivos:</strong> Elaboraciones bajas en grasa para atletas concentrados.</li>
                  </ul>
                  <ul style={{ paddingLeft: '20px', margin: 0 }}>
                    <li style={{ marginBottom: '6px' }}><strong>Eventos y Banquetes:</strong> Menús concertados de gala y bodas.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Menús de Grupo:</strong> Almuerzos corporativos o de ocio.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Coffee Breaks:</strong> Servicio rápido para congresos y reuniones.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Cócteles:</strong> Aperitivos y finger food servidos en bandeja.</li>
                    <li style={{ marginBottom: '6px' }}><strong>Postres y Sugerencias:</strong> Repostería variable del chef.</li>
                  </ul>
                </div>
              </div>

              {/* SECTION 3: OBJETO DEL INFORME */}
              <div style={{ marginBottom: '40px' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  2. OBJETO DEL INFORME
                </h3>
                <p style={{ fontSize: '0.85rem', lineHeight: '1.6', color: '#374151', marginBottom: '14px' }}>
                  Este informe recoge el estado actual de la información sobre alérgenos, trazas e ingredientes declarados en las elaboraciones gastronómicas preparadas o comercializadas en el Hotel Guadiana. 
                </p>
                <div style={{ fontSize: '0.85rem', lineHeight: '1.5', color: '#b91c1c', border: '1px solid rgba(239, 68, 68, 0.3)', padding: '12px 16px', backgroundColor: 'rgba(239, 68, 68, 0.04)', borderRadius: 'var(--radius-sm)', marginBottom: '14px', fontWeight: 500 }}>
                  <strong>IMPORTANTE - AVISO DE VALIDACIÓN DE COCINA:</strong><br />
                  La aplicación Food Safety sirve como soporte informático y de registro para facilitar la compilación y seguimiento del plan. No obstante, la validación definitiva de los alérgenos, ingredientes y trazas corresponde única y exclusivamente al equipo de cocina y responsables de restauración a través de la supervisión de fichas técnicas de proveedores y manipulación de alimentos.
                </div>
              </div>

              {/* SECTION 4: LEYENDA DE ALÉRGENOS */}
              <div className="page-break" style={{ marginBottom: '40px', pageBreakBefore: 'always' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  3. LEYENDA DE LOS 14 ALÉRGENOS OBLIGATORIOS
                </h3>
                <p style={{ fontSize: '0.85rem', color: '#374151', marginBottom: '12px' }}>
                  A continuación se detalla el código identificativo establecido para la gestión documental de alérgenos según el Reglamento (UE) Nº 1169/2011:
                </p>
                
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.8rem', textAlign: 'left', marginBottom: '20px' }}>
                  <thead>
                    <tr style={{ borderBottom: '2px solid #000000', backgroundColor: '#f9fafb' }}>
                      <th style={{ padding: '8px', border: '1px solid #d1d5db' }}>Cód</th>
                      <th style={{ padding: '8px', border: '1px solid #d1d5db' }}>Alérgeno</th>
                      <th style={{ padding: '8px', border: '1px solid #d1d5db' }}>Cód</th>
                      <th style={{ padding: '8px', border: '1px solid #d1d5db' }}>Alérgeno</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>1</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Pescado</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>8</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Cacahuetes</td>
                    </tr>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>2</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Frutos secos (almendra, avellana, nuez, etc.)</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>9</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Soja</td>
                    </tr>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>3</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Lácteos (incluye lactosa)</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>10</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Apio</td>
                    </tr>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>4</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Moluscos</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>11</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Mostaza</td>
                    </tr>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>5</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Gluten (trigo, centeno, cebada, avena)</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>12</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Sésamo</td>
                    </tr>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>6</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Crustáceos</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>13</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Altramuz</td>
                    </tr>
                    <tr>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>7</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Huevos</td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>14</strong></td>
                      <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>Sulfitos y dióxido de azufre (&gt;10mg/kg)</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              {/* SECTION 5: RESUMEN EJECUTIVO */}
              <div style={{ marginBottom: '40px' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  4. RESUMEN EJECUTIVO DE ESTADO
                </h3>
                <p style={{ fontSize: '0.85rem', color: '#374151', marginBottom: '14px' }}>
                  Los siguientes indicadores cuantitativos resumen el estado actual del Plan de Gestión de Alérgenos a fecha de este informe:
                </p>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px', fontSize: '0.82rem', marginBottom: '14px' }}>
                  <div style={{ padding: '12px', border: '1px solid #e5e7eb', borderRadius: '4px' }}>
                    <p style={{ margin: '4px 0', fontSize: '0.9rem' }}><strong>Platos y Elaboraciones:</strong></p>
                    <p style={{ margin: '4px 0' }}>• Total Registrados: <strong>{totalItemsCount}</strong></p>
                    <p style={{ margin: '4px 0', color: '#047857' }}>• Validados por Cocina: <strong>{validatedItems.length}</strong></p>
                    <p style={{ margin: '4px 0', color: '#c2410c' }}>• En Revisión: <strong>{revisionItems.length}</strong></p>
                    <p style={{ margin: '4px 0', color: '#b91c1c' }}>• Pendientes: <strong>{pendingItems.length}</strong></p>
                  </div>
                  <div style={{ padding: '12px', border: '1px solid #e5e7eb', borderRadius: '4px' }}>
                    <p style={{ margin: '4px 0', fontSize: '0.9rem' }}><strong>Proveedores y Tareas:</strong></p>
                    <p style={{ margin: '4px 0' }}>• Proveedores Registrados: <strong>{totalSuppliersCount}</strong></p>
                    <p style={{ margin: '4px 0', color: '#047857' }}>• Ficha Técnica Disponible: <strong>{suppliersWithTech.length}</strong></p>
                    <p style={{ margin: '4px 0', color: '#b91c1c' }}>• Ficha Técnica Pendiente: <strong>{suppliersNoTech.length}</strong></p>
                    <p style={{ margin: '4px 0', color: '#b91c1c' }}>• Tareas Críticas Pendientes: <strong>{criticalTasks.length}</strong></p>
                  </div>
                </div>

                {/* Warning box if there are pending items */}
                {pendingItems.length > 0 && (
                  <div style={{ padding: '10px 14px', backgroundColor: 'rgba(197, 160, 89, 0.08)', border: '1px solid rgba(197, 160, 89, 0.3)', borderRadius: 'var(--radius-sm)', color: '#855d0c', fontSize: '0.8rem', display: 'flex', gap: '8px', alignItems: 'center' }}>
                    <AlertTriangle size={16} />
                    <span>Hay un total de {pendingItems.length} platos catalogados como <strong>Pendientes</strong>. Los datos correspondientes a estos platos son provisionales.</span>
                  </div>
                )}
              </div>

              {/* SECTION 6: MATRIZ DE PLATOS, INGREDIENTES Y ALÉRGENOS */}
              <div className="page-break" style={{ marginBottom: '40px', pageBreakBefore: 'always' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  5. MATRIZ DE PLATOS, INGREDIENTES Y ALÉRGENOS
                </h3>
                <p style={{ fontSize: '0.85rem', color: '#374151', marginBottom: '12px' }}>
                  Listado de elaboraciones filtradas ({filteredItems.length} registros incluidos):
                </p>

                {filteredItems.length > 0 ? (
                  <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.75rem', textAlign: 'left' }}>
                    <thead>
                      <tr style={{ borderBottom: '2px solid #000000', backgroundColor: '#f3f4f6' }}>
                        <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Área / Categoría</th>
                        <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Plato / Producto</th>
                        <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Ingredientes</th>
                        <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Alérgenos (Trazas)</th>
                        <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Estado</th>
                        <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Verificó</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredItems.map(item => (
                        <tr key={item.id} style={{ borderBottom: '1px solid #e5e7eb' }}>
                          <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>
                            <span style={{ fontSize: '0.7rem', color: '#6b7280', display: 'block' }}>{item.area}</span>
                            <strong>{item.category}</strong>
                          </td>
                          <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>{item.name}</strong></td>
                          <td style={{ padding: '6px', border: '1px solid #d1d5db', color: '#4b5563', fontSize: '0.7rem' }}>
                            {item.ingredients || '—'}
                          </td>
                          <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>
                            <span style={{ color: '#b91c1c', fontWeight: 600 }}>{item.allergens || 'Ninguno'}</span>
                            {item.traces && (
                              <span style={{ display: 'block', fontSize: '0.65rem', color: '#6b7280' }}>
                                (Trazas: {item.traces})
                              </span>
                            )}
                          </td>
                          <td style={{ padding: '6px', border: '1px solid #d1d5db', textAlign: 'center' }}>
                            <span className={`badge ${item.status}`} style={{ fontSize: '0.65rem', padding: '2px 4px' }}>
                              {item.status}
                            </span>
                          </td>
                          <td style={{ padding: '6px', border: '1px solid #d1d5db', fontSize: '0.7rem', color: '#4b5563' }}>
                            {item.validated_by || '—'}
                            {item.validated_at && <span style={{ display: 'block', fontSize: '0.6rem', color: '#9ca3af' }}>{new Date(item.validated_at).toLocaleDateString('es-ES')}</span>}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : (
                  <p style={{ fontStyle: 'italic', padding: '20px', color: 'var(--color-text-muted)', textAlign: 'center' }}>
                    No se encontraron registros para el filtro seleccionado.
                  </p>
                )}
              </div>

              {/* SECTION 7: APARTADO DE INCIDENCIAS Y PUNTOS PENDIENTES */}
              <div className="page-break" style={{ marginBottom: '40px', pageBreakBefore: 'always' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  6. PUNTOS PENDIENTES E INCIDENCIAS OPERATIVAS DETECTADAS
                </h3>
                <p style={{ fontSize: '0.85rem', color: '#374151', marginBottom: '14px' }}>
                  Esta sección muestra de forma transparente los vacíos documentales pendientes de subsanar por el equipo. Este listado demuestra control interno y mejora continua:
                </p>

                <div style={{ fontSize: '0.8rem', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                  {noIngredients.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #b91c1c', backgroundColor: '#fef2f2' }}>
                      <strong>Platos sin ingredientes registrados ({noIngredients.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {noIngredients.slice(0, 10).map(x => x.name).join(', ')}{noIngredients.length > 10 ? '...' : ''}
                      </span>
                    </div>
                  )}
                  {noAllergens.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #b91c1c', backgroundColor: '#fef2f2' }}>
                      <strong>Platos sin código de alérgenos declarado ({noAllergens.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {noAllergens.slice(0, 10).map(x => x.name).join(', ')}{noAllergens.length > 10 ? '...' : ''}
                      </span>
                    </div>
                  )}
                  {noPreparation.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #f97316', backgroundColor: '#fff7ed' }}>
                      <strong>Platos sin método de elaboración registrado ({noPreparation.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {noPreparation.slice(0, 10).map(x => x.name).join(', ')}{noPreparation.length > 10 ? '...' : ''}
                      </span>
                    </div>
                  )}
                  {incompleteBreakfast.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #c5a059', backgroundColor: '#fcfcf9' }}>
                      <strong>Productos de Desayuno Buffet incompletos o sin validar ({incompleteBreakfast.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {incompleteBreakfast.slice(0, 10).map(x => x.name).join(', ')}{incompleteBreakfast.length > 10 ? '...' : ''}
                      </span>
                    </div>
                  )}
                  {suppliersNoTech.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #b91c1c', backgroundColor: '#fef2f2' }}>
                      <strong>Proveedores con Ficha Técnica pendiente ({suppliersNoTech.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {suppliersNoTech.map(x => x.name).join(', ')}
                      </span>
                    </div>
                  )}
                  {suppliersNoPhone.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #9ca3af', backgroundColor: '#f9fafb' }}>
                      <strong>Proveedores sin teléfono registrado ({suppliersNoPhone.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {suppliersNoPhone.map(x => x.name).join(', ')}
                      </span>
                    </div>
                  )}
                  {criticalTasks.length > 0 && (
                    <div style={{ padding: '8px 12px', borderLeft: '3px solid #b91c1c', backgroundColor: '#fef2f2' }}>
                      <strong>Tareas de Seguridad Alimentaria críticas pendientes ({criticalTasks.length}):</strong>
                      <span style={{ color: '#4b5563', display: 'block', marginTop: '2px' }}>
                        {criticalTasks.map(x => `${x.area}: ${x.title}`).join(' | ')}
                      </span>
                    </div>
                  )}
                  {noIngredients.length === 0 && noAllergens.length === 0 && suppliersNoTech.length === 0 && criticalTasks.length === 0 && (
                    <p style={{ color: 'var(--color-success)', fontWeight: 600 }}>
                      ✓ No se han detectado incidencias críticas pendientes de revisión.
                    </p>
                  )}
                </div>
              </div>

              {/* SECTION 8: RELACIÓN DE PROVEEDORES */}
              <div style={{ marginBottom: '40px' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  7. RELACIÓN DE PROVEEDORES ALIMENTICIOS
                </h3>
                <p style={{ fontSize: '0.85rem', color: '#374151', marginBottom: '12px' }}>
                  Proveedores que suministran materias primas al Hotel Guadiana:
                </p>

                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.75rem', textAlign: 'left' }}>
                  <thead>
                    <tr style={{ borderBottom: '2px solid #000000', backgroundColor: '#f3f4f6' }}>
                      <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Proveedor</th>
                      <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Contacto</th>
                      <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Productos</th>
                      <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Ficha Técnica</th>
                      <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Observaciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    {suppliers.map(sup => (
                      <tr key={sup.id} style={{ borderBottom: '1px solid #e5e7eb' }}>
                        <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>{sup.name}</strong></td>
                        <td style={{ padding: '6px', border: '1px solid #d1d5db', fontSize: '0.7rem' }}>
                          {sup.phone && <span style={{ display: 'block' }}>Tel: {sup.phone}</span>}
                          {sup.email && <span style={{ display: 'block' }}>Email: {sup.email}</span>}
                          {!sup.phone && !sup.email && <span style={{ color: '#9ca3af' }}>Sin contacto</span>}
                        </td>
                        <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>{sup.products || '—'}</td>
                        <td style={{ padding: '6px', border: '1px solid #d1d5db', textAlign: 'center' }}>
                          {sup.technical_sheet_available ? (
                            <span style={{ color: '#047857', fontWeight: 600 }}>SÍ</span>
                          ) : (
                            <span style={{ color: '#b91c1c', fontWeight: 600 }}>NO</span>
                          )}
                        </td>
                        <td style={{ padding: '6px', border: '1px solid #d1d5db', color: '#6b7280', fontSize: '0.7rem' }}>
                          {sup.notes || '—'}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* SECTION 9: CONTAMINACIÓN CRUZADA */}
              <div className="page-break" style={{ marginBottom: '40px', pageBreakBefore: 'always' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  8. GESTIÓN Y CONTROL DE LA CONTAMINACIÓN CRUZADA
                </h3>
                <p style={{ fontSize: '0.85rem', lineHeight: '1.6', color: '#374151', marginBottom: '14px' }}>
                  En las cocinas de hostelería colectiva se identifican y controlan los siguientes puntos críticos para reducir el riesgo de transferencia cruzada de alérgenos:
                </p>
                <div style={{ fontSize: '0.8rem', color: '#374151', paddingLeft: '20px' }}>
                  <p>• <strong>Freidoras compartidas:</strong> Se limita el uso de freidoras para alérgenos específicos o se declara la presencia de trazas por aceite compartido.</p>
                  <p>• <strong>Planchas y parrillas:</strong> Limpieza exhaustiva entre elaboraciones de distinta naturaleza.</p>
                  <p>• <strong>Utensilios y tablas de corte:</strong> Codificación por colores para separar manipulación de carnes, pescados, lácteos, pan y vegetales.</p>
                  <p>• <strong>Buffet y salas de servicio:</strong> Riesgo de contaminación cruzada por parte de los clientes mediante pinzas o cucharas compartidas.</p>
                  <p>• <strong>Salsas y repostería:</strong> Manipulación y envasado en áreas limpias específicas.</p>
                </div>
                <div style={{ fontSize: '0.85rem', lineHeight: '1.5', color: '#b91c1c', borderLeft: '4px solid #b91c1c', padding: '8px 12px', backgroundColor: '#fef2f2', marginTop: '14px', fontWeight: 600 }}>
                  “No se garantizará la ausencia absoluta de trazas cuando no exista circuito separado de elaboración o manipulación.”
                </div>
              </div>

              {/* SECTION 10: PROCEDIMIENTO DE INFORMACIÓN AL CLIENTE */}
              <div style={{ marginBottom: '40px' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  9. PROCEDIMIENTO DE INFORMACIÓN AL CLIENTE
                </h3>
                <div style={{ fontSize: '0.85rem', lineHeight: '1.6', color: '#374151', border: '1px solid #d1d5db', padding: '12px 16px', borderRadius: '4px', backgroundColor: '#f9fafb' }}>
                  <strong>INSTRUCCIÓN OBLIGATORIA PARA EL PERSONAL:</strong><br />
                  “El personal de sala, cafetería, eventos y recepción no debe informar de memoria sobre alérgenos. Ante cualquier consulta del cliente, deberá consultar la información actualizada en Food Safety o confirmar con cocina/restauración. En caso de duda, no se garantizará la ausencia de alérgenos o trazas.”
                </div>
              </div>

              {/* SECTION 11: CONTROL DE CAMBIOS */}
              <div className="page-break" style={{ marginBottom: '40px', pageBreakBefore: 'always' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '14px' }}>
                  10. REGISTRO OPERATIVO Y CONTROL DE CAMBIOS (TRAZABILIDAD)
                </h3>
                <p style={{ fontSize: '0.85rem', color: '#374151', marginBottom: '12px' }}>
                  Registro de auditoría interna de los últimos cambios de datos en el sistema (trazabilidad):
                </p>

                {isAdmin ? (
                  auditLogs.length > 0 ? (
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.7rem', textAlign: 'left' }}>
                      <thead>
                        <tr style={{ borderBottom: '2px solid #000000', backgroundColor: '#f3f4f6' }}>
                          <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Fecha</th>
                          <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Usuario</th>
                          <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Tabla</th>
                          <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Acción</th>
                          <th style={{ padding: '6px', border: '1px solid #d1d5db' }}>Detalle</th>
                        </tr>
                      </thead>
                      <tbody>
                        {auditLogs.map(log => {
                          const userText = profilesMap[log.changed_by] || log.changed_by || 'Sistema';
                          const details = log.action === 'UPDATE' 
                            ? `Editó registro ID: ${log.record_id.slice(0,8)}...`
                            : log.action === 'INSERT'
                            ? `Creó nuevo registro`
                            : `Eliminó registro`;

                          return (
                            <tr key={log.id} style={{ borderBottom: '1px solid #e5e7eb' }}>
                              <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>
                                {new Date(log.created_at).toLocaleString('es-ES')}
                              </td>
                              <td style={{ padding: '6px', border: '1px solid #d1d5db' }}><strong>{userText}</strong></td>
                              <td style={{ padding: '6px', border: '1px solid #d1d5db' }}>{log.table_name}</td>
                              <td style={{ padding: '6px', border: '1px solid #d1d5db', fontWeight: 'bold' }}>{log.action}</td>
                              <td style={{ padding: '6px', border: '1px solid #d1d5db', color: '#4b5563' }}>{details}</td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  ) : (
                    <p style={{ fontStyle: 'italic', fontSize: '0.8rem', color: '#6b7280' }}>
                      No se dispone de registros de cambios recientes en la base de datos.
                    </p>
                  )
                ) : (
                  <div style={{ padding: '10px 14px', backgroundColor: '#f9fafb', border: '1px solid #e5e7eb', borderRadius: '4px', fontSize: '0.8rem', color: '#6b7280', display: 'flex', gap: '8px', alignItems: 'center' }}>
                    <Lock size={14} />
                    <span>Sección confidencial. Solo visible para el rol Administrador.</span>
                  </div>
                )}
              </div>

              {/* SECTION 12: VALIDACIÓN INTERNA / FIRMAS */}
              <div style={{ marginTop: '50px', pageBreakInside: 'avoid' }}>
                <h3 style={{ fontSize: '1.3rem', borderBottom: '2px solid #000000', paddingBottom: '6px', color: '#0d3822', marginBottom: '30px' }}>
                  11. VALIDACIÓN Y FIRMAS DE AUTOCONTROL
                </h3>
                
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '40px', marginTop: '20px' }}>
                  <div style={{ textAlign: 'center', borderTop: '1px solid #9ca3af', paddingTop: '10px', fontSize: '0.8rem' }}>
                    <p><strong>Firma Responsable de Cocina:</strong></p>
                    <p style={{ marginTop: '55px', color: '#9ca3af' }}>[Firma del Chef Principal]</p>
                  </div>
                  <div style={{ textAlign: 'center', borderTop: '1px solid #9ca3af', paddingTop: '10px', fontSize: '0.8rem' }}>
                    <p><strong>Firma Responsable de Restauración / Sala:</strong></p>
                    <p style={{ marginTop: '55px', color: '#9ca3af' }}>[Firma del Maître / Responsable]</p>
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr', gap: '40px', marginTop: '50px', maxWidth: '350px', margin: '50px auto 0 auto' }}>
                  <div style={{ textAlign: 'center', borderTop: '1px solid #9ca3af', paddingTop: '10px', fontSize: '0.8rem' }}>
                    <p><strong>Firma y Sello de Dirección del Hotel:</strong></p>
                    <p style={{ marginTop: '55px', color: '#9ca3af' }}>[Sello y Firma Dirección]</p>
                  </div>
                </div>

                <div style={{ marginTop: '30px', fontSize: '0.8rem', color: '#374151' }}>
                  <p><strong>Fecha de la última revisión del plan completo:</strong> _____ / _____ / 2026</p>
                  <p><strong>Observaciones de la revisión:</strong> ____________________________________________________________________________________________________________________________________</p>
                </div>
              </div>

            </div>
          </div>
        )
      ) : (
        /* Historial y control de trazabilidad view */
        <div className="panel">
          <div className="panel-header" style={{ marginBottom: '16px' }}>
            <h3 style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <ListOrdered size={20} />
              Registro de Informes Generados (Trazabilidad)
            </h3>
          </div>

          <p style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', marginBottom: '16px' }}>
            Cada vez que un usuario autorizado genera o descarga un informe formal, se registra de manera inmutable en esta tabla para cumplir con las exigencias de trazabilidad de Sanidad.
          </p>

          <div className="table-responsive">
            {loadingHistory ? (
              <p style={{ textAlign: 'center', padding: '20px', color: 'var(--color-text-muted)' }}>Cargando historial...</p>
            ) : reportLogs.length > 0 ? (
              <table>
                <thead>
                  <tr>
                    <th>Fecha y Hora</th>
                    <th>Generado por</th>
                    <th>Tipo de Informe</th>
                    <th>Filtro</th>
                    <th style={{ textAlign: 'center' }}>Total Platos</th>
                    <th style={{ textAlign: 'center' }}>Validados</th>
                    <th>Notas</th>
                  </tr>
                </thead>
                <tbody>
                  {reportLogs.map(log => {
                    const userText = profilesMap[log.generated_by] || log.generated_by || 'Sistema / API';
                    return (
                      <tr key={log.id}>
                        <td>
                          <span style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '0.8rem' }}>
                            <Calendar size={12} />
                            {new Date(log.generated_at).toLocaleString('es-ES')}
                          </span>
                        </td>
                        <td><strong>{userText}</strong></td>
                        <td>{log.report_type}</td>
                        <td>
                          <span className="badge" style={{ backgroundColor: 'var(--color-primary)', color: '#fff', fontSize: '0.75rem' }}>
                            {log.filters_used?.filter || 'completo'}
                          </span>
                        </td>
                        <td style={{ textAlign: 'center' }}><strong>{log.total_items}</strong></td>
                        <td style={{ textAlign: 'center', color: 'var(--color-success)', fontWeight: 600 }}>{log.validated_items}</td>
                        <td style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', maxWidth: '200px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }} title={log.notes || ''}>
                          {log.notes || '—'}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            ) : (
              <p style={{ textAlign: 'center', padding: '30px', color: 'var(--color-text-muted)' }}>
                No se han registrado generaciones de informes todavía.
              </p>
            )}
          </div>
        </div>
      )}
    </div>
  );
};
