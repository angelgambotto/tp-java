
<%@page import="proyectos.Proyecto"%>
<% Proyecto pro = (Proyecto) request.getAttribute("proyecto");
	String nombre = (pro != null && pro.getNombre() != null) ? pro.getNombre()  : "Desconocido" ;
%>

<div id="delete" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModalEliminar") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">Confirmar eliminación</h2>
        <p>¿Está seguro que desea eliminar el siguiente proyecto?</p>
		<p>	
			<b>Nombre:</b> <%= nombre %>
		</p>
        <form action="ClienteServlet" method="post" class="space-y-4">
         	<input type="hidden" name="action" value="confirmDelete" />
            <input type="hidden" name="id" value="<%= pro != null? pro.getId(): 0%>" />
            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal('delete')">
                  Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-red-700">
                  Eliminar
                </button>
                
            </div>
    	</form>
	</div>
</div>

