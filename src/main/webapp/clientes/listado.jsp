<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="clientes.Cliente" %>

<html>
<head>
    <title>Gestión de Clientes</title>
     <script src="https://cdn.tailwindcss.com"></script>
     <script>
        function toggleModal(nameModal) {
            const modal = document.getElementById(nameModal);
            modal.classList.toggle('hidden');
        }
    </script>
</head>
<body class="bg-gray-100 font-sans">
<jsp:include page="../header.jsp" />
<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex items-center gap-3">
            <div class="bg-indigo-100 p-3 rounded-lg">
                <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                 <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                </svg>
            </div>
            <div>
                <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800">Gestión de Clientes</h1>
                 <p class="text-sm sm:text-base text-gray-600">Administre la lista de clientes y empresas</p>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex flex-col lg:flex-row gap-3 lg:items-center lg:justify-between">
            
            <div class="relative flex-1 max-w-md">
                <input type="text" id="searchInput" placeholder="Buscar por CUIT, Razón Social, Mail..."
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 pl-10 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition" />
                <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                </svg>
            </div>
            
            <a href="ClienteServlet?action=new" class="bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 sm:px-6 py-2 rounded-lg shadow transition flex items-center justify-center gap-2 whitespace-nowrap">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                    <span>Nuevo Usuario</span>
                </a>
        </div>
    </div>

    <div class="bg-white rounded-lg shadow overflow-x-auto">
        <table class="w-full border-collapse whitespace-nowrap">
            <thead class="bg-gray-50 border-b">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Cuit/Cuil</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Razon Social</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mail</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider w-[180px]">Acciones</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">        
            <%
                List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                if (clientes != null  && !clientes.isEmpty()) {
                    for (Cliente cli : clientes) {
            %>
            <tr class="hover:bg-gray-50 transition cliente-row">
                <td class="px-6 py-4 text-sm font-medium text-gray-900"><%= cli.getCuitCuil() %></td>
                <td class="px-6 py-4 text-sm text-gray-600"><%= cli.getRazonSocial() %></td>
                <td class="px-6 py-4 text-sm text-gray-600"><%= cli.getMail() %></td>
                <td class="px-6 py-4 text-center whitespace-nowrap">
                 <a href="ClienteServlet?action=edit&id=<%= cli.getId() %>" 
                       class="inline-block bg-blue-600 text-white px-4 py-1.5 rounded-lg text-sm hover:bg-blue-700 transition mr-2">
                       Editar
                    </a>
                 <a href="ClienteServlet?action=delete&id=<%= cli.getId() %>"
                    class="inline-block bg-red-600 text-white px-4 py-1.5 rounded-lg text-sm hover:bg-red-700 transition">
                    Eliminar
                    </a>
                </td>
            </tr>
            <%      }
                }
                else {
            %>
                	<tr>
                		<td colspan="4" class="px-6 py-12 text-center">
                            <svg class="mx-auto h-12 w-12 mb-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                            </svg>
                            <p class="text-sm text-gray-500">No hay clientes registrados</p>
                        </td>
                	</tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</div>

<jsp:include page="formulario.jsp" />
<jsp:include page="modalEliminar.jsp" />


<script>
const searchInput=document.getElementById("searchInput");
const tableRows = document.querySelectorAll('tbody tr');
function filterTable(){
	const searchText=searchInput.value.toLowerCase();
	tableRows.forEach(row => {
        const cells = row.querySelectorAll('td');
   
        // Ignorar la fila de "Sin clientes"
        if (cells.length === 1 && cells[0].getAttribute('colspan') === '4') return;
        if (cells.length === 0) return;

        const cuil = cells[0].textContent.toLowerCase();
        const razon = cells[1].textContent.toLowerCase();
       	const mail=cells[2].textContent.toLowerCase()

        const matchesSearch = !searchText ||
            cuil.includes(searchText) ||
            razon.includes(searchText)||
            mail.includes(searchText);

        row.style.display = matchesSearch  ? '' : 'none';
    });
 }
searchInput.addEventListener('input', filterTable);

</script>

<div id="mensaje" class="hidden fixed top-4 right-4 z-50 max-w-md">
    <div id="mensajeContenido" class="px-6 py-4 rounded-lg shadow-lg text-white flex items-center">
        <svg id="mensajeIcono" class="w-6 h-6 flex-shrink-0 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
        <span id="mensajeTexto"></span>
        <button onclick="document.getElementById('mensaje').classList.add('hidden')" 
                class="ml-4 text-2xl font-bold hover:opacity-70">×</button>
    </div>
</div>

<script>
// Mostrar mensaje de éxito o error que venga de la sesión
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

    // Se cierra solo en 10 segundos
    setTimeout(() => {
        div.classList.add('hidden');
    }, 10000);
}
</script>
</body>
</html>