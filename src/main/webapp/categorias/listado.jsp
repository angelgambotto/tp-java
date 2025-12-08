<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="categoriaTarea.CategoriaTarea" %>

<html>
<head>
    <title>ABM Categoría Tarea</title>
     <script src="https://cdn.tailwindcss.com"></script>
     <script>
     	//para cerrar el modal
        function toggleModal(nameModal) {
            const modal = document.getElementById(nameModal);
            modal.classList.toggle('hidden');
        }
    </script>
</head>
<body class="bg-gray-100">
<jsp:include page="../header.jsp" />
<div class="p-8">

<!-- Mostrar errores -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
 <div class="flex items-center justify-between mb-4">
    <!-- Título -->
    <h2 class="text-2xl font-bold text-black">Listado de Categorías</h2>

     <!-- Buscador con ícono de lupa -->
    <div class="relative flex-1 max-w-md">
        <input type="text" id="searchInput" placeholder="Buscar..."
               class="w-full border border-gray-300 rounded px-3 py-2 pr-10 focus:ring-indigo-500 focus:border-indigo-500" />
        <button class="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m1.85-5.65a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
        </button>
    </div>
    <!-- Botón -->
     <a href="CategoriaTareaServlet?action=new" 
	   class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
	   Nueva
	</a>
  </div>

<div class="flex mt-8 bg-white shadow-lg rounded-lg p-6"> 
    <table class="w-full border-collapse border border-gray-300">
    	<thead>
        <tr>
            <th class="border border-gray-300 px-4 py-2">Nombre</th>
            <th class="border border-gray-300 px-4 py-2">Descripción</th>
            <th class="border border-gray-300 px-4 py-2  w-[180px]">Acciones</th>
        </tr>
        </thead>
        <tbody>        
        <%
            List<CategoriaTarea> categorias = (List<CategoriaTarea>) request.getAttribute("categorias");
        	System.out.println("categorias en categorias: "+categorias);
            if (categorias != null) {
                for (CategoriaTarea cat : categorias) {
        %>
        <tr class="hover:bg-gray-100">
            <td class="border border-gray-300 px-4 py-2"><%= cat.getNombre() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= cat.getDescripcion() %></td>
            <td class="border border-gray-300 px-4 py-2">
             <a href="CategoriaTareaServlet?action=edit&id=<%= cat.getId() %>" 
                   class="bg-blue-600 text-white px-2 py-1 rounded text-sm hover:bg-blue-700 w-[60px] inline-block text-center">Editar</a>
              <a href="CategoriaTareaServlet?action=delete&id=<%= cat.getId() %>"
                class="bg-blue-600 text-white px-2 py-1 rounded text-sm hover:bg-red-700 w-[70px] inline-block text-center">Eliminar</a>           
            </td>
        </tr>
        <%      }
            }
        %>
        </tbody>
    </table>
</div>

<!-- Aca esta el form con el modal -->
<jsp:include page="formulario.jsp" />
<jsp:include page="modalEliminar.jsp" />
</div>
<script>
const searchInput=document.getElementById("searchInput");
const tableRows = document.querySelectorAll('tbody tr');
function filterTable(){
	const searchText=searchInput.value.toLowerCase();
	tableRows.forEach(row => {
        const cells = row.querySelectorAll('td');
       	
        if (cells.length === 0) return;

        const nombre = cells[0].textContent.toLowerCase();
        const descripcion = cells[1].textContent.toLowerCase();
       

        const matchesSearch = !searchText ||
            nombre.includes(searchText) ||
            descripcion.includes(searchText);

  

        row.style.display = matchesSearch  ? '' : 'none';
    });
		
}
searchInput.addEventListener('input', filterTable);

</script>
<!-- MENSAJE FLOTANTE -->
<div id="mensaje" class="hidden fixed top-4 right-4 z-50 max-w-md">
    <div id="mensajeContenido" class="px-6 py-4 py-3 rounded-lg shadow-lg text-white flex items-center justify-between">
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
    
    textoSpan.textContent = texto;
    contenido.className = color === "verde" 
        ? "px-6 py-4 rounded-lg shadow-lg text-white flex items-center justify-between bg-green-600"
        : "px-6 py-4 rounded-lg shadow-lg text-white flex items-center justify-between bg-red-600";
    
    div.classList.remove('hidden');

    // Se cierra solo en 10 segundos
    setTimeout(() => {
        div.classList.add('hidden');
    }, 10000);
}
</script>
</body>
</html>
