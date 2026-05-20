import React, { useState, useMemo } from 'react';
import { Plus, Check, Calendar, AlertCircle, Trash2, Edit2, User } from 'lucide-react';

interface Task {
  id: string;
  title: string;
  description: string | null;
  area: string | null;
  priority: string;
  status: string;
  assigned_to: string | null;
  due_date: string | null;
  created_at: string;
}

interface TasksPanelProps {
  tasks: Task[];
  userRole: string;
  onSaveTask: (task: Partial<Task> & { id?: string }) => Promise<void>;
  onDeleteTask: (id: string) => Promise<void>;
}

const PRIORITIES = [
  { id: 'baja', label: 'Baja' },
  { id: 'media', label: 'Media' },
  { id: 'alta', label: 'Alta' },
  { id: 'critica', label: 'Crítica' }
];

const STATUSES = [
  { id: 'pendiente', label: 'Pendiente' },
  { id: 'en_proceso', label: 'En proceso' },
  { id: 'completada', label: 'Completada' }
];

const AREAS = [
  'Cafetería',
  'Restaurante',
  'Desayuno Buffet',
  'Menú Deportivo',
  'Menús de Grupo',
  'Coffee Break',
  'Eventos',
  'Cócteles',
  'General',
  'Compras'
];

export const TasksPanel: React.FC<TasksPanelProps> = ({
  tasks,
  userRole,
  onSaveTask,
  onDeleteTask
}) => {
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  
  // Form states
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [area, setArea] = useState('General');
  const [priority, setPriority] = useState('media');
  const [status, setStatus] = useState('pendiente');
  const [assignedTo, setAssignedTo] = useState('');
  const [dueDate, setDueDate] = useState('');
  
  // Filters
  const [filterPriority, setFilterPriority] = useState('');
  const [filterStatus, setFilterStatus] = useState('');

  const isAdmin = userRole === 'admin';

  const filteredTasks = useMemo(() => {
    return tasks.filter(task => {
      const matchPriority = !filterPriority || task.priority === filterPriority;
      const matchStatus = !filterStatus || task.status === filterStatus;
      return matchPriority && matchStatus;
    });
  }, [tasks, filterPriority, filterStatus]);

  const openNewTaskModal = () => {
    setEditingTask(null);
    setTitle('');
    setDescription('');
    setArea('General');
    setPriority('media');
    setStatus('pendiente');
    setAssignedTo('');
    setDueDate('');
    setIsModalOpen(true);
  };

  const openEditTaskModal = (task: Task) => {
    setEditingTask(task);
    setTitle(task.title || '');
    setDescription(task.description || '');
    setArea(task.area || 'General');
    setPriority(task.priority || 'media');
    setStatus(task.status || 'pendiente');
    setAssignedTo(task.assigned_to || '');
    setDueDate(task.due_date || '');
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) {
      alert('El título de la tarea es obligatorio.');
      return;
    }

    try {
      const payload: Partial<Task> = {
        title: title.trim(),
        description: description.trim() || null,
        area: area || null,
        priority,
        status,
        assigned_to: assignedTo.trim() || null,
        due_date: dueDate || null
      };

      if (editingTask) {
        await onSaveTask({ ...payload, id: editingTask.id });
      } else {
        await onSaveTask(payload);
      }
      setIsModalOpen(false);
    } catch (err) {
      console.error(err);
      alert('Error al guardar la tarea.');
    }
  };

  const handleDelete = async (id: string) => {
    if (!isAdmin) return;
    if (window.confirm('¿Seguro que deseas eliminar esta tarea?')) {
      try {
        await onDeleteTask(id);
      } catch (err) {
        console.error(err);
        alert('Error al eliminar la tarea.');
      }
    }
  };

  const handleToggleComplete = async (task: Task) => {
    const nextStatus = task.status === 'completada' ? 'pendiente' : 'completada';
    try {
      await onSaveTask({
        id: task.id,
        status: nextStatus
      });
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="panel">
      <div className="panel-header">
        <h3>Gestión de Tareas Pendientes</h3>
        <button className="btn btn-primary" onClick={openNewTaskModal}>
          <Plus size={16} />
          <span>Nueva Tarea</span>
        </button>
      </div>

      {/* Task Filters */}
      <div className="toolbar">
        <select 
          value={filterStatus}
          onChange={(e) => setFilterStatus(e.target.value)}
          className="filter-select"
        >
          <option value="">Todos los estados</option>
          {STATUSES.map(st => (
            <option key={st.id} value={st.id}>{st.label}</option>
          ))}
        </select>

        <select 
          value={filterPriority}
          onChange={(e) => setFilterPriority(e.target.value)}
          className="filter-select"
        >
          <option value="">Todas las prioridades</option>
          {PRIORITIES.map(pr => (
            <option key={pr.id} value={pr.id}>{pr.label}</option>
          ))}
        </select>
      </div>

      {/* Tasks Table */}
      <div className="table-responsive">
        {filteredTasks.length > 0 ? (
          <table>
            <thead>
              <tr>
                <th style={{ width: '40px' }}></th>
                <th>Área / Tarea</th>
                <th>Responsable</th>
                <th>Vencimiento</th>
                <th>Prioridad</th>
                <th>Estado</th>
                <th style={{ width: '120px' }}>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filteredTasks.map(task => (
                <tr key={task.id} style={{ opacity: task.status === 'completada' ? 0.6 : 1 }}>
                  <td>
                    <button 
                      onClick={() => handleToggleComplete(task)}
                      className={`btn btn-outline btn-small`}
                      style={{ 
                        borderRadius: '50%', 
                        width: '28px', 
                        height: '28px', 
                        padding: 0, 
                        display: 'flex', 
                        alignItems: 'center', 
                        justifyContent: 'center',
                        borderColor: task.status === 'completada' ? 'var(--color-success)' : 'var(--color-border)',
                        color: task.status === 'completada' ? 'white' : 'transparent',
                        backgroundColor: task.status === 'completada' ? 'var(--color-success)' : 'transparent'
                      }}
                    >
                      <Check size={14} style={{ strokeWidth: 3 }} />
                    </button>
                  </td>
                  <td>
                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                      <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', color: 'var(--color-text-muted)', fontWeight: '600' }}>
                        {task.area || 'General'}
                      </span>
                      <strong style={{ 
                        color: 'var(--color-primary)', 
                        textDecoration: task.status === 'completada' ? 'line-through' : 'none' 
                      }}>
                        {task.title}
                      </strong>
                      {task.description && (
                        <p style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                          {task.description}
                        </p>
                      )}
                    </div>
                  </td>
                  <td>
                    {task.assigned_to ? (
                      <span style={{ display: 'inline-flex', alignItems: 'center', gap: '6px', fontSize: '0.85rem' }}>
                        <User size={12} />
                        {task.assigned_to}
                      </span>
                    ) : (
                      <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Sin asignar</span>
                    )}
                  </td>
                  <td>
                    {task.due_date ? (
                      <span style={{ 
                        display: 'inline-flex', 
                        alignItems: 'center', 
                        gap: '6px', 
                        fontSize: '0.85rem',
                        color: new Date(task.due_date) < new Date() && task.status !== 'completada' ? 'var(--color-danger)' : 'inherit',
                        fontWeight: new Date(task.due_date) < new Date() && task.status !== 'completada' ? 'bold' : 'normal'
                      }}>
                        <Calendar size={12} />
                        {new Date(task.due_date).toLocaleDateString('es-ES')}
                      </span>
                    ) : (
                      <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>—</span>
                    )}
                  </td>
                  <td>
                    <span className={`badge prioridad-${task.priority}`}>
                      {task.priority === 'critica' ? 'Crítica' : task.priority === 'alta' ? 'Alta' : task.priority === 'media' ? 'Media' : 'Baja'}
                    </span>
                  </td>
                  <td>
                    <span className={`badge ${task.status === 'completada' ? 'validado' : task.status === 'en_proceso' ? 'en_revision' : 'pendiente'}`}>
                      {task.status === 'completada' ? 'Completada' : task.status === 'en_proceso' ? 'En proceso' : 'Pendiente'}
                    </span>
                  </td>
                  <td>
                    <div style={{ display: 'flex', gap: '6px' }}>
                      <button 
                        onClick={() => openEditTaskModal(task)}
                        className="btn btn-outline btn-small"
                        title="Editar tarea"
                      >
                        <Edit2 size={12} />
                      </button>
                      {isAdmin && (
                        <button 
                          onClick={() => handleDelete(task.id)}
                          className="btn btn-danger btn-small"
                          title="Eliminar tarea"
                        >
                          <Trash2 size={12} />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p style={{ textAlign: 'center', padding: '40px', color: 'var(--color-text-muted)' }}>
            No hay tareas pendientes en esta categoría.
          </p>
        )}
      </div>

      {/* Task Creation / Edit Modal */}
      {isModalOpen && (
        <div className="modal-backdrop">
          <div className="modal-container" style={{ maxWidth: '550px' }}>
            <div className="modal-header">
              <h3>{editingTask ? 'Editar Tarea' : 'Nueva Tarea'}</h3>
              <button className="modal-close-btn" onClick={() => setIsModalOpen(false)}>
                <Plus size={20} style={{ transform: 'rotate(45deg)' }} />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} style={{ display: 'contents' }}>
              <div className="modal-body">
                <div className="form-grid" style={{ gridTemplateColumns: '1fr' }}>
                  
                  <div className="form-group">
                    <label className="form-label">Área del Hotel</label>
                    <select 
                      value={area}
                      onChange={(e) => setArea(e.target.value)}
                      className="form-select"
                    >
                      {AREAS.map(a => (
                        <option key={a} value={a}>{a}</option>
                      ))}
                    </select>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Título de la Tarea *</label>
                    <input 
                      type="text"
                      value={title}
                      onChange={(e) => setTitle(e.target.value)}
                      placeholder="Ej. Revisar alérgenos de fiambres en buffet"
                      required
                      className="form-input"
                    />
                  </div>

                  <div className="form-group">
                    <label className="form-label">Descripción</label>
                    <textarea 
                      value={description}
                      onChange={(e) => setDescription(e.target.value)}
                      placeholder="Detalles sobre la labor a realizar..."
                      rows={3}
                      className="form-textarea"
                    />
                  </div>

                  <div className="form-grid" style={{ gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                    <div className="form-group">
                      <label className="form-label">Responsable</label>
                      <input 
                        type="text"
                        value={assignedTo}
                        onChange={(e) => setAssignedTo(e.target.value)}
                        placeholder="Nombre de la persona"
                        className="form-input"
                      />
                    </div>

                    <div className="form-group">
                      <label className="form-label">Fecha Límite</label>
                      <input 
                        type="date"
                        value={dueDate}
                        onChange={(e) => setDueDate(e.target.value)}
                        className="form-input"
                      />
                    </div>
                  </div>

                  <div className="form-grid" style={{ gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                    <div className="form-group">
                      <label className="form-label">Prioridad</label>
                      <select 
                        value={priority}
                        onChange={(e) => setPriority(e.target.value)}
                        className="form-select"
                      >
                        {PRIORITIES.map(pr => (
                          <option key={pr.id} value={pr.id}>{pr.label}</option>
                        ))}
                      </select>
                    </div>

                    <div className="form-group">
                      <label className="form-label">Estado</label>
                      <select 
                        value={status}
                        onChange={(e) => setStatus(e.target.value)}
                        className="form-select"
                      >
                        {STATUSES.map(st => (
                          <option key={st.id} value={st.id}>{st.label}</option>
                        ))}
                      </select>
                    </div>
                  </div>

                </div>
              </div>

              <div className="modal-footer">
                <button 
                  type="button" 
                  onClick={() => setIsModalOpen(false)} 
                  className="btn btn-outline"
                >
                  Cancelar
                </button>
                <button 
                  type="submit" 
                  className="btn btn-primary"
                >
                  Guardar Tarea
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
