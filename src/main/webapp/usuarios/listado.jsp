<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedList" %>
<%@page import = "usuarios.Usuario" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gestión de Usuarios</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
        function toggleModal(nameModal) {
            const modal = document.getElementById(nameModal);
            modal.classList.toggle('hidden');
        }
</script>

<%LinkedList<Usuario> usuarios=(LinkedList<Usuario>)request.getAttribute("usuarios"); %>

</head>
<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex items-center gap-3">
            <div class="bg-blue-100 p-3 rounded-lg">
                <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                 <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                </svg>
            </div>
            <div>
                <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800">Gestión de Usuarios</h1>    
                 <p class="text-sm sm:text-base text-gray-600">Administre los usuarios del sistema</p>
            </div>
        </div>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4 sm:mb-6 flex items-start gap-2">
            <svg class="w-5 h-5 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
            </svg>
            <span><%= request.getAttribute("error") %></span>
        </div>
    <% } %>

    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex flex-col lg:flex-row gap-3 lg:items-center lg:justify-between">            
            <div class="relative flex-1 max-w-md">
                <input type="text" id="searchInput" placeholder="Buscar por nombre, email, usuario..." class="w-full border border-gray-300 rounded-lg px-4 py-2 pl-10 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" />
                <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
         		</svg>
            </div> 
            <div class="flex flex-col sm:flex-row gap-3">
                <select id="roleFilter" class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
           			<option value="">Todos los roles</option>
                    <option value="Administrador">Administrador</option>
                    <option value="Empleado">Empleado</option>
                    <option value="Cliente">Cliente</option>
                </select>
                
                <a href="UsuariosServlet?action=new" class="bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 sm:px-6 py-2 rounded-lg shadow transition flex items-center justify-center gap-2 whitespace-nowrap">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                    <span>Nuevo Usuario</span>
                </a>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-lg shadow overflow-x-auto">  
        <table class="w-full whitespace-nowrap">
            <thead class="bg-gray-50 border-b">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Usuario</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rol</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Supervisor</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                <% 
                 if(usuarios != null && !usuarios.isEmpty()) {
                    for(Usuario user : usuarios) { %>
                    <tr class="hover:bg-gray-50 transition usuario-row"
                        data-nombre="<%= user.getNombre().toLowerCase() %>"
                     
                     data-apellido="<%= user.getApellido().toLowerCase() %>"
                        data-mail="<%= user.getMail().toLowerCase() %>"
                        data-usuario="<%= user.getUsuario().toLowerCase() %>"
                        data-rol="<%= user.getRol().toLowerCase() %>"
                 
                        data-supervisor="<%= user.getNombreSupervisor() != null ?
                         user.getNombreSupervisor().toLowerCase() : "" %>">
                        
                        <td class="px-6 py-4">
                            <div>
                    	        <div class="text-sm font-medium text-gray-900"><%= user.getNombre() %> <%= user.getApellido() %></div>                              
                        	</div>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600"><%= user.getMail() %></td>
                        <td class="px-6 py-4 text-sm text-gray-600"><%= user.getUsuario() %></td>
              		    <td class="px-6 py-4">
                            <span class="px-3 py-1 text-xs font-semibold rounded-full
                                <%= "Administrador".equals(user.getRol()) ?
                                 "bg-red-100 text-red-800" :
                                    "Supervisor".equals(user.getRol()) ?
                                     "bg-blue-100 text-blue-800" :
                                    "Empleado".equals(user.getRol()) ?
                                     "bg-green-100 text-green-800" :
                                    "Cliente".equals(user.getRol()) ?
                                     "bg-purple-100 text-purple-800" :
                                    "bg-gray-100 text-gray-800" %>">
                                <%= user.getRol() %>
                             </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600">
                           <%= user.getNombreSupervisor() != null && !user.getNombreSupervisor().isEmpty() ? user.getNombreSupervisor() : "—" %>
                        </td>
                        <td class="px-6 py-4 text-center whitespace-nowrap">
        	        		<a href="UsuariosServlet?action=edit&id=<%= user.getId() %>" 
        	        			class="inline-block bg-blue-600 text-white px-4 py-1.5 rounded-lg text-sm hover:bg-blue-700 transition mr-2">
                                Editar
                        	</a>
                            <a href="UsuariosServlet?action=delete&id=<%= user.getId() %>"
                                class="inline-block bg-red-600 text-white px-4 py-1.5 rounded-lg text-sm hover:bg-red-700 transition">
                                Eliminar
                            </a>
                         </td>
                    </tr>
                <% }
                } else { %>
                    <tr>
	                    <td colspan="6" class="px-6 py-12 text-center">
		                    <svg class="mx-auto h-12 w-12 mb-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
		         	           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
		                    </svg>
		                    <p class="text-sm text-gray-500">No hay usuarios registrados</p>
	                    </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<div id="mensaje" class="hidden fixed top-4 right-4 z-50 max-w-md">
    <div id="mensajeContenido" class="px-6 py-4 rounded-lg shadow-lg text-white flex items-center justify-between">
       <div class="flex items-center gap-3">
            <svg id="mensajeIcono" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
            <span id="mensajeTexto"></span>
        </div>
        <button onclick="document.getElementById('mensaje').classList.add('hidden')"
        		class="ml-4 text-2xl font-bold hover:opacity-70">×</button>
    </div>
</div>

<script>
// Filtrado de tabla
const searchInput = document.getElementById('searchInput');
const roleFilter = document.getElementById('roleFilter');
const tableRows = document.querySelectorAll('.usuario-row');

function filterTable() {
    const searchText = searchInput.value.toLowerCase();
    const selectedRole = roleFilter.value.toLowerCase();

    tableRows.forEach(row => {
        const nombre = row.getAttribute('data-nombre') || '';
        const apellido = row.getAttribute('data-apellido') || '';
        const mail = row.getAttribute('data-mail') || '';
        const usuario = row.getAttribute('data-usuario') || '';
        const rol = row.getAttribute('data-rol') || '';
        const supervisor = row.getAttribute('data-supervisor') || '';

        const matchesSearch = !searchText ||
    
             nombre.includes(searchText) ||
            apellido.includes(searchText) ||
            mail.includes(searchText) ||
            usuario.includes(searchText) ||
            rol.includes(searchText) ||
            supervisor.includes(searchText);

        const matchesRole = !selectedRole || rol === selectedRole;

        row.style.display = matchesSearch && 
            matchesRole ? '' : 'none';
    });
}

searchInput.addEventListener('input', filterTable);
roleFilter.addEventListener('change', filterTable);
// Mostrar mensaje de éxito o error
document.addEventListener("DOMContentLoaded", function() {
    <%
    String exito = (String) session.getAttribute("mensajeExito");
    String error = (String) session.getAttribute("mensajeError");
    if (exito != null) {
        session.removeAttribute("mensajeExito");
    %>
        mostrarMensaje("<%= exito %>", "verde");
    <%
    } else if (error != null) {
        session.removeAttribute("mensajeError");
    %>
        mostrarMensaje("<%= error %>", "rojo");
    
 <%
    }
    %>
});

function mostrarMensaje(texto, color) {
    const div = document.getElementById('mensaje');
    const contenido = document.getElementById('mensajeContenido');
    const textoSpan = document.getElementById('mensajeTexto');
    const icono = document.getElementById('mensajeIcono');
    
    textoSpan.textContent = texto;
    if (color === "verde") {
        contenido.className = "px-6 py-4 rounded-lg shadow-lg text-white flex items-center justify-between bg-green-600";
        icono.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>';
    } else {
        contenido.className = "px-6 py-4 rounded-lg shadow-lg text-white flex items-center justify-between bg-red-600";
        icono.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>';
    }
    
    div.classList.remove('hidden');
    setTimeout(() => {
        div.classList.add('hidden');
    }, 10000);
}
</script>

<jsp:include page="formulario.jsp" />
<jsp:include page="modalEliminar.jsp"/>

</body>
</html>