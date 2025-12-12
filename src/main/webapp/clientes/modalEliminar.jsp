
<%@page import="clientes.Cliente"%>
<% Cliente cli = (Cliente) request.getAttribute("cliente");
	String razonSocial = (cli != null && cli.getRazonSocial() != null) ? cli.getRazonSocial()  : "Desconocido" ;
	String cuitCuil = (cli != null && cli.getCuitCuil() != null) ? cli.getCuitCuil()  : "Desconocido" ;
	String mail = (cli != null && cli.getMail() != null) ? cli.getMail()  : "Desconocido" ;
%>

<div id="delete" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModalEliminar") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">Confirmar eliminación</h2>
        	<p>
			¿Está seguro que desea eliminar el siguiente cliente?
			</p>
			<p>
			<b>Razon social:</b> <%= razonSocial %>
			<br>
			<b>Cuit/Cuil:</b> <%= cuitCuil %>
			<br>
			<b>Mail:</b> <%= mail %>
			</p>
         <form action="ClienteServlet" method="post" class="space-y-4">
         	<input type="hidden" name="action" value="confirmDelete" />
            <input type="hidden" name="id" value="<%= cli != null? cli.getId(): 0%>" />
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

