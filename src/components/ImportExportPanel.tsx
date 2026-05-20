import React, { useRef, useState } from 'react';
import { Download, Upload, RefreshCw, CheckCircle, Database } from 'lucide-react';
import { supabase } from '../utils/supabase';
import initialData from '../../data/initial-data.json';

interface ImportExportPanelProps {
  items: any[];
  suppliers: any[];
  tasks: any[];
  onRefreshData: () => Promise<void>;
  userRole: string;
}

export const ImportExportPanel: React.FC<ImportExportPanelProps> = ({
  items,
  suppliers,
  tasks,
  onRefreshData,
  userRole
}) => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [loading, setLoading] = useState(false);
  const [statusMessage, setStatusMessage] = useState<string | null>(null);
  const [isError, setIsError] = useState(false);

  const isAdminOrCocina = userRole === 'admin' || userRole === 'cocina';

  const showStatus = (msg: string, err = false) => {
    setStatusMessage(msg);
    setIsError(err);
    setTimeout(() => setStatusMessage(null), 6000);
  };

  // 1. Exportar datos a JSON
  const exportToJson = () => {
    const dataToExport = {
      exportedAt: new Date().toISOString(),
      food_items: items,
      suppliers: suppliers,
      tasks: tasks
    };
    
    const jsonString = `data:text/json;charset=utf-8,${encodeURIComponent(
      JSON.stringify(dataToExport, null, 2)
    )}`;
    
    const downloadAnchor = document.createElement('a');
    downloadAnchor.setAttribute('href', jsonString);
    downloadAnchor.setAttribute('download', `food-safety-export-${new Date().toISOString().split('T')[0]}.json`);
    document.body.appendChild(downloadAnchor);
    downloadAnchor.click();
    downloadAnchor.remove();
    showStatus('Exportación JSON completada.');
  };

  // 2. Exportar catálogo de platos a CSV
  const exportToCsv = () => {
    const headers = [
      'Área',
      'Categoría',
      'Plato',
      'Códigos Alérgenos',
      'Alérgenos',
      'Ingredientes',
      'Elaboración',
      'Trazas',
      'Observaciones Proveedor',
      'Estado'
    ];

    const escapeCsv = (val: any) => {
      const text = String(val ?? '').replace(/"/g, '""');
      return `"${text}"`;
    };

    const rows = items.map(x => [
      x.area,
      x.category,
      x.name,
      x.allergen_codes,
      x.allergens,
      x.ingredients,
      x.preparation,
      x.traces,
      x.supplier_notes,
      x.status
    ]);

    const csvContent = [
      headers.join(';'),
      ...rows.map(r => r.map(escapeCsv).join(';'))
    ].join('\n');

    const blob = new Blob([new Uint8Array([0xEF, 0xBB, 0xBF]), csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    
    const downloadAnchor = document.createElement('a');
    downloadAnchor.setAttribute('href', url);
    downloadAnchor.setAttribute('download', `catalogo-alergenos-guadiana.csv`);
    document.body.appendChild(downloadAnchor);
    downloadAnchor.click();
    downloadAnchor.remove();
    URL.revokeObjectURL(url);
    showStatus('Exportación CSV completada.');
  };

  // 3. Importación inicial desde data/initial-data.json
  const handleImportInitialData = async () => {
    if (userRole !== 'admin') {
      showStatus('No tienes permisos suficientes para realizar importaciones. Debes ser Administrador.', true);
      return;
    }

    if (!window.confirm('¿Seguro que deseas importar el catálogo inicial? Se insertarán/actualizarán los platos del Hotel Guadiana en la base de datos.')) {
      return;
    }

    setLoading(true);
    try {
      const foodItemsToInsert = initialData.food_items || [];
      
      if (!foodItemsToInsert.length) {
        showStatus('El archivo JSON inicial no contiene platos válidos.', true);
        return;
      }

      // Obtener platos existentes para calcular creados vs actualizados
      const { data: existingItems, error: fetchError } = await supabase
        .from('food_items')
        .select('area, category, name');
        
      if (fetchError) throw fetchError;

      const existingKeys = new Set(
        existingItems?.map(x => `${x.area}|${x.category}|${x.name}`.toLowerCase()) || []
      );

      let createdCount = 0;
      let updatedCount = 0;

      foodItemsToInsert.forEach((item: any) => {
        const key = `${item.area}|${item.category}|${item.name}`.toLowerCase();
        if (existingKeys.has(key)) {
          updatedCount++;
        } else {
          createdCount++;
        }
      });

      // Insertar/actualizar por lotes de 100 para evitar desbordar Supabase API
      const batchSize = 100;
      
      for (let i = 0; i < foodItemsToInsert.length; i += batchSize) {
        const batch = foodItemsToInsert.slice(i, i + batchSize);
        const { error } = await supabase
          .from('food_items')
          .upsert(batch, { onConflict: 'area,category,name' });
        
        if (error) throw error;
      }

      showStatus(`Importación completada con éxito. Se han creado ${createdCount} platos y se han actualizado ${updatedCount} platos.`);
      await onRefreshData();
    } catch (err: any) {
      console.error(err);
      showStatus(`Error de importación: ${err.message || 'Error desconocido'}`, true);
    } finally {
      setLoading(false);
    }
  };

  // 4. Importar archivo JSON subido por el usuario
  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !isAdminOrCocina) return;

    setLoading(true);
    try {
      const fileText = await file.text();
      const data = JSON.parse(fileText);
      
      // Aceptar formatos que contengan food_items o items
      const importedRecords = data.food_items || data.items || [];
      
      if (!importedRecords.length) {
        showStatus('El archivo JSON subido no contiene registros válidos (debe tener clave "food_items" o "items").', true);
        return;
      }

      const foodItemsToInsert = importedRecords.map((r: any) => {
        let cleanStatus = 'pendiente';
        if (r.status === 'validado' || r.status === 'en_revision' || r.status === 'pendiente') {
          cleanStatus = r.status;
        }
        
        return {
          area: r.area || 'General',
          category: r.category || 'Otros',
          name: r.name || 'Plato sin nombre',
          ingredients: r.ingredients || null,
          allergen_codes: r.allergen_codes || null,
          allergens: r.allergens || null,
          traces: r.traces || null,
          preparation: r.preparation || null,
          supplier_notes: r.supplier_notes || null,
          status: cleanStatus
        };
      });

      // Insertar por lotes
      const batchSize = 100;
      let insertedCount = 0;
      
      for (let i = 0; i < foodItemsToInsert.length; i += batchSize) {
        const batch = foodItemsToInsert.slice(i, i + batchSize);
        const { error } = await supabase.from('food_items').insert(batch);
        
        if (error) throw error;
        insertedCount += batch.length;
      }

      showStatus(`Importación exitosa. Se añadieron ${insertedCount} platos.`);
      await onRefreshData();
    } catch (err: any) {
      console.error(err);
      showStatus(`Error en el formato del JSON: ${err.message}`, true);
    } finally {
      setLoading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const triggerFileSelect = () => {
    if (!isAdminOrCocina) {
      showStatus('No tienes permisos para importar archivos.', true);
      return;
    }
    fileInputRef.current?.click();
  };

  return (
    <div>
      {statusMessage && (
        <div className={`panel`} style={{ 
          backgroundColor: isError ? 'var(--color-danger-bg)' : 'var(--color-success-bg)',
          borderColor: isError ? 'var(--color-danger)' : 'var(--color-success)',
          color: isError ? 'var(--color-danger)' : 'var(--color-success)',
          padding: '12px 16px',
          fontWeight: '500',
          marginBottom: '20px'
        }}>
          {statusMessage}
        </div>
      )}

      <div className="import-export-grid">
        {/* Export Options */}
        <div className="panel">
          <div className="panel-header">
            <h3>Exportar Datos del Plan</h3>
          </div>
          <p style={{ fontSize: '0.9rem', color: 'var(--color-text-muted)', marginBottom: '20px' }}>
            Descarga copias de seguridad de los platos, proveedores y tareas en tu dispositivo. Puedes usar el JSON para restaurar los datos en cualquier momento.
          </p>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            <button className="btn btn-outline" onClick={exportToJson} style={{ justifyContent: 'center' }}>
              <Download size={16} />
              <span>Exportar Copia de Seguridad (JSON)</span>
            </button>
            <button className="btn btn-outline" onClick={exportToCsv} style={{ justifyContent: 'center' }}>
              <Download size={16} />
              <span>Exportar Catálogo de Alérgenos (CSV)</span>
            </button>
          </div>
        </div>

        {/* Initial seed data */}
        {userRole === 'admin' && (
          <div className="panel">
            <div className="panel-header">
              <h3>Inicialización del Catálogo</h3>
            </div>
            <p style={{ fontSize: '0.9rem', color: 'var(--color-text-muted)', marginBottom: '20px' }}>
              Carga el catálogo inicial técnico del Hotel Guadiana (Cafetería, Buffet, Deporte, Cócteles y Eventos) desde la carpeta local <code>initial-data.json</code>.
            </p>
            <button 
              className="btn btn-primary" 
              onClick={handleImportInitialData}
              disabled={loading}
              style={{ width: '100%', justifyContent: 'center' }}
            >
              {loading ? <RefreshCw size={16} className="spin" /> : <Database size={16} />}
              <span>Cargar datos iniciales</span>
            </button>
          </div>
        )}

        {/* Import JSON File */}
        {isAdminOrCocina && (
          <div className="panel" style={{ gridColumn: 'span 2' }}>
            <div className="panel-header">
              <h3>Importar Archivo de Copia de Seguridad</h3>
            </div>
            <p style={{ fontSize: '0.9rem', color: 'var(--color-text-muted)', marginBottom: '15px' }}>
              Restaura un catálogo previamente exportado subiendo su archivo JSON.
            </p>
            <div className="file-upload-zone" onClick={triggerFileSelect}>
              <Upload size={32} style={{ color: 'var(--color-secondary)' }} />
              <strong style={{ fontSize: '0.95rem' }}>Haz clic aquí para seleccionar tu archivo JSON</strong>
              <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>Formatos aceptados: .json</span>
              <input 
                type="file" 
                ref={fileInputRef} 
                onChange={handleFileUpload} 
                accept="application/json" 
                className="file-upload-input" 
              />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
