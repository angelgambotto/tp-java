<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="usuarios.Usuario" %>
<%@ page import="clientes.Cliente" %>

<html>
<head>
    <title>ABM Proyecto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function toggleModal() {
            const modal = document.getElementById('modal');
            modal.classList.toggle('hidden');
        }

        // Script para manejar los menús de tres puntos (dropdown por click)
        document.addEventListener('DOMContentLoaded', function() {
            const menuButtons = document.querySelectorAll('.menu-button');
            const menus = document.querySelectorAll('.project-menu');

            menuButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const menu = this.nextElementSibling;
                    const isHidden = menu.classList.contains('hidden');
                    // Cerrar otros menús
                    menus.forEach(m => m.classList.add('hidden'));
                    // Toggle este
                    if (isHidden) {
                        menu.classList.remove('hidden');
                    }
                });
            });

            // Cerrar menús al click fuera
            document.addEventListener('click', function() {
                menus.forEach(menu => menu.classList.add('hidden'));
            });
        });
    </script>
    <% LinkedList<Usuario> supervisores = (LinkedList<Usuario>) request.getAttribute("supervisores");
	   Usuario usuarioActual = (Usuario) session.getAttribute("usuario");
	   String rol = usuarioActual.getRol();
    %>
</head>
<body class="bg-gray-100">
<jsp:include page="../header.jsp" />
<div class="p-8">
    <div class="flex items-center justify-between mb-4">
        <!-- Título -->
        <h2 class="text-2xl font-bold text-black">Listado de Proyectos</h2>

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
        <% if(rol.equalsIgnoreCase("administrador")) {%>
        <!-- Botón -->
        <a href="ProyectoServlet?action=new">
            <button class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                Nuevo
            </button>
        </a>
        <%} %>
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

        // Nueva estructura: lista de columnas y headers para loop único
        List<LinkedList<Proyecto>> columnas = Arrays.asList(todo, inProgress, done, canceled);
        String[] headers = {"To Do", "In Progress", "Done", "Canceled"};
    %>

    <div class="grid grid-cols-4 gap-6 mt-8">
        <%
            for (int col = 0; col < 4; col++) {
                LinkedList<Proyecto> proyectosCol = columnas.get(col);
        %>
                <div class="bg-white shadow-lg rounded-lg p-6">
                    <h3 class="text-xl font-bold mb-4 text-gray-800"><%= headers[col] %></h3>
                    <div class="space-y-4 max-h-96 overflow-y-auto">
                        <%
                            for (Proyecto pro : proyectosCol) {
                                // Cálculo de iniciales en Java (server-side)
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
                                <!--  <div class="bg-gray-50 p-4 rounded-lg border border-gray-200 relative"> -->
                                <!-- Descomentar para activar redireccion a EtapaServletal ahcer click sobre una card-->
                                <div class=" proyecto_card bg-gray-50 p-4 rounded-lg border border-gray-200 relative cursor-pointer" onclick="window.location.href='EtapaServlet?action=list&idProyecto=<%= pro.getId() %>';" >
                                
                                    <!-- Menú de tres puntos arriba derecha -->
                                    <div class="absolute top-2 right-2">
                                        <button class="menu-button text-gray-500 hover:text-gray-700 p-1 rounded-full hover:bg-gray-200" aria-label="Opciones">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                                            </svg>
                                        </button>
                                        <div class="project-menu absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-10 hidden border">
                                            <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Editar</a>
                                            <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                                               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Eliminar</a>
                                        </div>
                                    </div>

                                    <!-- Contenido de la card -->
                                    <h4 class="font-semibold text-gray-900 mb-2"><%= pro.getNombre() %></h4>
                                    <p class="text-sm text-gray-600 mb-3"><%= pro.getDescripcion() %></p>

                                    <!-- Cliente con icono de persona -->
                                    <div class="flex items-center mb-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-500 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                        </svg>
                                        <p class="text-xs text-gray-500"><%= pro.getCliente().getRazonSocial() %></p>
                                    </div>

                                    <!-- Fecha de creación y cantidad de usuarios -->
                                    <p class="text-xs text-gray-500 mb-2">Fecha Creación: <%= pro.getFechaCreacion() %></p>
                                    <p class="text-xs text-gray-500 mb-4">Usuarios asignados: <%= usuariosCount %></p>

                                    <!-- Supervisor: Círculo abajo derecha con tooltip SOLO en hover del círculo -->
                                    <div class="absolute bottom-2 right-2">
                                        <div class="relative group"> <!-- Group movido AQUÍ: solo hover en el círculo -->
                                            <div class="w-8 h-8 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold" title="<%= pro.getSupervisor().getNombreCompleto() %>">
                                                <%= initials %>
                                            </div>
                                            <div class="absolute bottom-full right-0 mb-2 px-2 py-1 bg-gray-800 text-white text-xs rounded opacity-0 invisible group-hover:opacity-100 group-hover:visible transition whitespace-nowrap z-10">
                                                <%= pro.getSupervisor().getNombreCompleto() %>
                                                <div class="absolute top-full right-0 w-0 h-0 border-l-4 border-r-4 border-t-4 border-transparent border-t-gray-800"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                              
                        <%
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
<<<<<<< HEAD

=======
>>>>>>> 2531eddb660f058cf7da72333808b969186ac37b
<!-- MENSAJE FLOTANTE (éxito/error) -->
<div id="mensaje" class="hidden fixed top-4 right-4 z-50 max-w-md">
    <div id="mensajeContenido" class="px-6 py-4 rounded-lg shadow-lg text-white flex items-center justify-between">
        <span id="mensajeTexto"></span>
        <button onclick="document.getElementById('mensaje').classList.add('hidden')" 
                class="ml-4 text-2xl font-bold hover:opacity-70">×</button>
    </div>
</div>

<script>
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
    setTimeout(() => div.classList.add('hidden'), 6000);
}
</script>
<script>
document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("searchInput");
    const cards = document.querySelectorAll(".proyecto_card");
    console.log("Tarjetas encontradas:", cards.length);
    function filtrarProyectos() {
        const searchText = searchInput.value.toLowerCase();
        
        cards.forEach(card => {
            
            const nombre = card.querySelector('h4')?.textContent.toLowerCase() || '';
            const descripcion = card.querySelector('p')?.textContent.toLowerCase() || '';
           
            
            // Verificar si coincide con la búsqueda
            const matches = !searchText ||
                nombre.includes(searchText) ||
                descripcion.includes(searchText) 
                
            
            // Mostrar u ocultar
            if (matches) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
        
        
    }
    searchInput.addEventListener('input', filtrarProyectos);});
</script>

</body>
</html>