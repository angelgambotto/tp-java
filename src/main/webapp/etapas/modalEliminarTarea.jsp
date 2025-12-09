<%@page import="etapas.Etapa"%>
<%@page import="tareas.Tarea"%>
<% Tarea t = (Tarea) request.getAttribute("tarea");
	Etapa e = (Etapa) request.getAttribute("etapa");
	String nombre = (t != null && t.getNombre() != null) ? t.getNombre()  : "Desconocido" ;
	String descripcion = (t != null && t.getDescripcion() != null) ? t.getDescripcion()  : "Desconocido" ;
%>

<div id="delete" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModalEliminar") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">Confirmar eliminación</h2>
        	<p>
			¿Está seguro que desea eliminar la siguiente tarea?
			</p>
			<p>
			<b>Nombre:</b> <%= nombre %>
			<br>
			<b>Descripcion:</b> <%= descripcion %>
			</p>
         <form action="TareaServlet" method="post" class="space-y-4">
         	<input type="hidden" name="action" value="confirmDelete" />
            <input type="hidden" name="idTarea" value="<%= t != null? t.getId(): 0%>" />
            <input type="hidden" name="idEtapa" value="<%= e != null? e.getId(): 0%>" />
            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="window.location.href='TareaServlet?action=list&idEtapa=<%= e.getId() %>'">
                  Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-red-700">
                  Eliminar
                </button>
                
            </div>
        </form>
      </div>
    </div>
    
