import React from 'react';
import { 
  ClipboardList, 
  AlertTriangle, 
  CheckCircle2, 
  Users,
  AlertOctagon
} from 'lucide-react';

interface DashboardProps {
  totalItems: number;
  pendingItems: number;
  validatedItems: number;
  totalSuppliers: number;
  criticalTasks: Array<{ id: string; title: string; area: string; priority: string; status: string }>;
  recentPendingItems: Array<{ id: string; name: string; area: string; category: string; status: string }>;
  onViewItems: () => void;
  onViewTasks: () => void;
}

export const Dashboard: React.FC<DashboardProps> = ({
  totalItems,
  pendingItems,
  validatedItems,
  totalSuppliers,
  criticalTasks,
  recentPendingItems,
  onViewItems,
  onViewTasks
}) => {
  return (
    <div>
      {/* Statistics Counters */}
      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-icon total">
            <ClipboardList size={24} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Total Platos / Productos</span>
            <span className="stat-value">{totalItems}</span>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon pending">
            <AlertTriangle size={24} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Pendientes Validar</span>
            <span className="stat-value">{pendingItems}</span>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon validated">
            <CheckCircle2 size={24} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Validados Cocina</span>
            <span className="stat-value">{validatedItems}</span>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon suppliers">
            <Users size={24} />
          </div>
          <div className="stat-info">
            <span className="stat-label">Proveedores Activos</span>
            <span className="stat-value">{totalSuppliers}</span>
          </div>
        </div>
      </div>

      <div className="dashboard-sections">
        {/* Main Info Columns */}
        <div>
          {/* Critical Tasks Alert Panel */}
          {criticalTasks.length > 0 && (
            <div className="panel" style={{ borderLeft: '4px solid var(--color-danger)' }}>
              <div className="panel-header">
                <h3 style={{ display: 'flex', alignItems: 'center', gap: '8px', color: 'var(--color-danger)' }}>
                  <AlertOctagon size={20} />
                  Tareas Críticas y de Alta Prioridad
                </h3>
                <button className="btn btn-outline btn-small" onClick={onViewTasks}>Ver todas</button>
              </div>
              <table style={{ fontSize: '0.85rem' }}>
                <thead>
                  <tr>
                    <th>Área</th>
                    <th>Tarea</th>
                    <th>Prioridad</th>
                  </tr>
                </thead>
                <tbody>
                  {criticalTasks.map(task => (
                    <tr key={task.id}>
                      <td><strong>{task.area || 'General'}</strong></td>
                      <td>{task.title}</td>
                      <td>
                        <span className={`badge prioridad-${task.priority}`}>
                          {task.priority === 'critica' ? 'Crítica' : 'Alta'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          {/* Recent Pending Dishes */}
          <div className="panel">
            <div className="panel-header">
              <h3>Platos pendientes de validar por Cocina</h3>
              <button className="btn btn-outline btn-small" onClick={onViewItems}>Ver catálogo</button>
            </div>
            {recentPendingItems.length > 0 ? (
              <div className="table-responsive">
                <table>
                  <thead>
                    <tr>
                      <th>Área</th>
                      <th>Categoría</th>
                      <th>Nombre del Plato</th>
                      <th>Estado</th>
                    </tr>
                  </thead>
                  <tbody>
                    {recentPendingItems.map(item => (
                      <tr key={item.id}>
                        <td>{item.area}</td>
                        <td>{item.category}</td>
                        <td><strong>{item.name}</strong></td>
                        <td>
                          <span className="badge pendiente">{item.status}</span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', textAlign: 'center', padding: '20px 0' }}>
                ✓ Todos los platos han sido validados por Cocina. ¡Buen trabajo!
              </p>
            )}
          </div>
        </div>

        {/* Sidebar instructions */}
        <div>
          <div className="panel">
            <div className="panel-header" style={{ marginBottom: '12px' }}>
              <h3 style={{ fontSize: '1.15rem' }}>Puntos Críticos de Control</h3>
            </div>
            <ul className="checklist">
              <li className="checklist-item">
                <span className="checklist-dot"></span>
                <span><strong>Desayuno Buffet:</strong> Completar ingredientes, proveedor y alérgenos de bollería, panes y embutidos.</span>
              </li>
              <li className="checklist-item">
                <span className="checklist-dot"></span>
                <span><strong>Tapas de Barra:</strong> Verificar contaminación cruzada en frituras comunes con el chef Luengo.</span>
              </li>
              <li className="checklist-item">
                <span className="checklist-dot"></span>
                <span><strong>Menús de Grupo y Eventos:</strong> Mantener al día la validación de fichas técnicas para banquetes.</span>
              </li>
              <li className="checklist-item">
                <span className="checklist-dot"></span>
                <span><strong>Proveedores:</strong> Comprobar que todos tengan la casilla de ficha técnica marcada y al día.</span>
              </li>
              <li className="checklist-item">
                <span className="checklist-dot"></span>
                <span><strong>Inspección Sanitaria:</strong> Mantener el catálogo impreso en PDF ante posibles inspecciones de la Consejería.</span>
              </li>
            </ul>
          </div>

          <div className="panel" style={{ backgroundColor: '#eff5f1', borderColor: 'rgba(13, 56, 34, 0.1)' }}>
            <h4 style={{ color: 'var(--color-primary)', fontWeight: '600', marginBottom: '8px' }}>Normativa de Sanidad</h4>
            <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', lineHeight: '1.4' }}>
              El Reglamento (UE) Nº 1169/2011 exige facilitar información sobre alérgenos alimentarios para todos los alimentos no envasados suministrados en restauración. Toda alteración en ingredientes de proveedores debe ser modificada de inmediato en esta herramienta.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
