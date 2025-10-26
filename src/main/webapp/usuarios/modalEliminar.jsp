
<%@page import="usuarios.Usuario"%>
<script>
<%Usuario user = (Usuario) request.getAttribute("usuario");
	String nombre = (user.getNombre() != null ? user.getNombre(): "Desconocido");
	String apellido = (user.getApellido() != null ? user.getApellido(): "Desconocido");
	String mail = (user.getMail() != null ? user.getMail() : "Desconocido");
	int id = (user.getId() != 0 ? user.getId() : 0);
	
%>
</script>

<div id="delete" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModalEliminar") != null) ? "" : "hidden" %> flex items-center justify-center">
	<div class="bg-white rounded-lg p-6 w-full max-w-md">
	  	<h2 class="text-xl font-bold mb-4">Confirmar Eliminación</h2>
		<p>
		¿Está seguro que desea eliminar el siguiente usuario?
		</p>
		<p>
		<b>Nombre:</b> <%= nombre %>
		<br>
		<b>Apellido:</b> <%= apellido %>
		<br>
		<b>Mail:</b> <%= mail %>

		</p>
		<form action= "UsuariosServlet" method="post">
			<input type="hidden" name="action" value="confirmDelete" />
	        <input type="hidden" name="id" id="deleteCategoriaId" value="<%= id %>" />
	        <div class="flex justify-end space-x-4 mt-4">
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