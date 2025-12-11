<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="usuarios.Usuario" %>
<%@ page import="clientes.Cliente" %>

<html>
<head>
    <title>Gestión de Proyectos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // Script para manejar los menús de tres puntos
        document.addEventListener('DOMContentLoaded', function() {
            const menuButtons = document.querySelectorAll('.menu-button');
            const menus = document.querySelectorAll('.project-menu');

            menuButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const menu = this.nextElementSibling;
                    const isHidden = menu.classList.contains('hidden');
                    menus.forEach(m => m.classList.add('hidden'));
                    if (isHidden) {
                        menu.classList.remove('hidden');
                    }
                });
            });

            document.addEventListener('click', function() {
                menus.forEach(menu => menu.classList.add('hidden'));
            });
        });
    </script>
    <% 
        LinkedList<Usuario> supervisores = (LinkedList<Usuario>) request.getAttribute("supervisores");
        Usuario usuarioActual = (Usuario) session.getAttribute("usuario");
        String rol = usuarioActual.getRol();
    %>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <!-- HEADER -->
    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex items-center gap-3">
            <div class="bg-blue-100 p-3 rounded-lg">
                <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"></path>
                </svg>
            </div>
            <div>
                <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800">Gestión de Proyectos</h1>
                <p class="text-sm sm:text-base text-gray-600">Administre y visualice todos sus proyectos</p>
            </div>
        </div>
    </div>

    <!-- FILTROS Y BÚSQUEDA -->
    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex flex-col lg:flex-row gap-3 lg:items-center lg:justify-between">
            
            <!-- Búsqueda -->
            <div class="relative flex-1 max-w-md">
                <input type="text" id="searchInput" placeholder="Buscar por nombre, descripción..."
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 pl-10 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" />
                <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                </svg>
            </div>
            
            <% if(rol.equalsIgnoreCase("administrador")) { %>
            <!-- Botón nuevo proyecto -->
            <a href="ProyectoServlet?action=new"
               class="bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 sm:px-6 py-2 rounded-lg shadow transition flex items-center justify-center gap-2 whitespace-nowrap">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
                <span>Nuevo Proyecto</span>
            </a>
            <% } %>
        </div>
    </div>

    <%
        List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
        LinkedList<Proyecto> todo = new LinkedList<>();
        LinkedList<Proyecto> inProgress = new LinkedList<>();
        LinkedList<Proyecto> done = new LinkedList<>();
        LinkedList<Proyecto> canceled = new LinkedList<>();

        if (proyectos != null) {
            for (Proyecto pro : proyectos) {
                String estado = pro.getEstado();
                if ("To Do".equals(estado)) {
                    todo.add(pro);
                } else if ("In Progress".equals(estado)) {
                    inProgress.add(pro);
                } else if ("Done".equals(estado)) {
                    done.add(pro);
                } else if ("Canceled".equals(estado)) {
                    canceled.add(pro);
                }
            }
        }

        List<LinkedList<Proyecto>> columnas = Arrays.asList(todo, inProgress, done, canceled);
        String[] headers = {"Por Hacer", "En Progreso", "Completados", "Cancelados"};
        String[] headerColors = {"bg-yellow-100 text-yellow-800", "bg-blue-100 text-blue-800", "bg-green-100 text-green-800", "bg-gray-100 text-gray-800"};
        String[] iconColors = {"text-yellow-600", "text-blue-600", "text-green-600", "text-gray-600"};
    %>

    <!-- COLUMNAS KANBAN -->
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-4 sm:gap-6">
        <%
            for (int col = 0; col < 4; col++) {
                LinkedList<Proyecto> proyectosCol = columnas.get(col);
        %>
                <div class="bg-white shadow-lg rounded-lg overflow-hidden">
                    <!-- Header de columna -->
                    <div class="<%= headerColors[col] %> px-4 sm:px-6 py-3 sm:py-4 border-b">
                        <div class="flex items-center justify-between">
                            <h3 class="text-base sm:text-lg font-bold flex items-center gap-2">
                                <svg class="w-5 h-5 <%= iconColors[col] %>" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"></path>
                                </svg>
                                <%= headers[col] %>
                            </h3>
                            <span class="text-sm font-semibold px-2 py-1 rounded-full bg-white bg-opacity-50">
                                <%= proyectosCol.size() %>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Tarjetas de proyectos -->
                    <div class="p-4 space-y-4 max-h-[calc(100vh-20rem)] overflow-y-auto">
                        <%
                            if (proyectosCol.isEmpty()) {
                        %>
                            <div class="text-center py-8 text-gray-400">
                                <svg class="mx-auto h-12 w-12 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
                                </svg>
                                <p class="text-sm">Sin proyectos</p>
                            </div>
                        <%
                            } else {
                                for (Proyecto pro : proyectosCol) {
                                    String nombreCompleto = pro.getSupervisor().getNombreCompleto();
                                    String[] partes = nombreCompleto.split(" ");
                                    String initials = "";
                                    if (partes.length > 0) {
                                        initials += partes[0].substring(0, 1).toUpperCase();
                                    }
                                    if (partes.length > 1) {
                                        initials += partes[partes.length - 1].substring(0, 1).toUpperCase();
                                    }
                                    int usuariosCount = (pro.getUsuarios() != null) ? pro.getUsuarios().size() : 0;
                        %>
                                <div class="proyecto_card bg-gray-50 hover:bg-gray-100 p-4 rounded-lg border border-gray-200 hover:border-blue-300 relative cursor-pointer transition-all hover:shadow-md" 
                                     onclick="window.location.href='EtapaServlet?action=list&idProyecto=<%= pro.getId() %>';">
                                    
                                    <!-- Menú de tres puntos -->
                                    <% Usuario supervisor = pro.getSupervisor(); 
                                    if(rol.equalsIgnoreCase("administrador")|| (supervisor.getId() == usuarioActual.getId())) { %>
                                    <div class="absolute top-2 right-2">
                                        <button class="menu-button text-gray-400 hover:text-gray-700 p-1 rounded-full hover:bg-white transition" 
                                                aria-label="Opciones"
                                                onclick="event.stopPropagation()">
                                            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                                            </svg>
                                        </button>
                                        <div class="project-menu absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1 z-10 hidden border border-gray-200">
                                            <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>"
                                               onclick="event.stopPropagation()"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-2">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                                </svg>
                                                Editar
                                            </a>
                                            <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                                               onclick="event.stopPropagation(); return confirm('¿Está seguro de eliminar el proyecto <%= pro.getNombre() %>?')"
                                               class="block px-4 py-2 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                                                </svg>
                                                Eliminar
                                            </a>
                                        </div>
                                    </div>
                                    <% } %>

                                    <!-- Contenido de la tarjeta -->
                                    <h4 class="font-semibold text-gray-900 mb-2 pr-6"><%= pro.getNombre() %></h4>
                                    <p class="text-sm text-gray-600 mb-3 line-clamp-2"><%= pro.getDescripcion() %></p>

                                    <!-- Cliente -->
                                    <div class="flex items-center mb-2 text-xs text-gray-600">
                                        <svg class="h-4 w-4 text-gray-400 mr-1.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                        </svg>
                                        <span class="truncate"><%= pro.getCliente().getRazonSocial() %></span>
                                    </div>

                                    <!-- Metadata -->
                                    <div class="space-y-1 mb-3 text-xs text-gray-500">
                                        <div class="flex items-center">
                                            <svg class="w-3.5 h-3.5 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                            </svg>
                                            <span>Creación: <%= pro.getFechaCreacion() %></span>
                                        </div>
                                        <div class="flex items-center">
                                            <svg class="w-3.5 h-3.5 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                                            </svg>
                                            <span><%= usuariosCount %> usuario<%= usuariosCount != 1 ? "s" : "" %> asignado<%= usuariosCount != 1 ? "s" : "" %></span>
                                        </div>
                                    </div>

                                    <!-- Supervisor -->
                                    <div class="flex items-center justify-between pt-3 border-t border-gray-200">
                                        <span class="text-xs text-gray-500 font-medium">Supervisor</span>
                                        <div class="relative group">
                                            <div class="w-8 h-8 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold" 
                                                 title="<%= pro.getSupervisor().getNombreCompleto() %>">
                                                <%= initials %>
                                            </div>
                                            <div class="absolute bottom-full right-0 mb-2 px-2 py-1 bg-gray-800 text-white text-xs rounded opacity-0 invisible group-hover:opacity-100 group-hover:visible transition whitespace-nowrap z-10">
                                                <%= pro.getSupervisor().getNombreCompleto() %>
                                                <div class="absolute top-full right-2 w-0 h-0 border-l-4 border-r-4 border-t-4 border-transparent border-t-gray-800"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
        <%
            }
        %>
    </div>
</div>

<jsp:include page="formulario.jsp" />

<!-- MENSAJE FLOTANTE -->
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
// Filtrado de proyectos
document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("searchInput");
    const cards = document.querySelectorAll(".proyecto_card");
    
    function filtrarProyectos() {
        const searchText = searchInput.value.toLowerCase();
        
        cards.forEach(card => {
            const nombre = card.querySelector('h4')?.textContent.toLowerCase() || '';
            const descripcion = card.querySelector('p')?.textContent.toLowerCase() || '';
            
            const matches = !searchText ||
                nombre.includes(searchText) ||
                descripcion.includes(searchText);
            
            card.style.display = matches ? '' : 'none';
        });
    }
    
    searchInput.addEventListener('input', filtrarProyectos);
});

// Mensajes flotantes
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
    setTimeout(() => div.classList.add('hidden'), 6000);
}
</script>

</body>
</html>