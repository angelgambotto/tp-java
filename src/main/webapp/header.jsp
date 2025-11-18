<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="usuarios.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logueado = (usuario != null);
%>

<header class="bg-blue-600 text-white shadow-lg">
    <div class="container mx-auto px-4">
        <!-- Desktop Header -->
        <div class="hidden md:grid md:grid-cols-3 items-center py-4">
            
            <h1 class="text-xl font-bold justify-self-start">Planera</h1>

            <!-- Desktop Navigation -->
            <nav class="flex justify-center space-x-6 lg:space-x-8">
                <% 
                if(logueado){
                    switch(usuario.getRol().toLowerCase()){
                        case "administrador":
                            %>
                            <a href="UsuariosServlet" class="hover:underline transition">Usuarios</a>
                            <a href="ProyectoServlet" class="hover:underline transition">Proyectos</a>
                            <a href="ClienteServlet" class="hover:underline transition">Clientes</a>
                            <a href="CategoriaTareaServlet" class="hover:underline transition">Categorías</a>
                            <a href="HoraTrabajadaServlet?action=reporte" class="hover:underline transition">Reportes</a>
                            <% break;
                        case "supervisor":
                            %>
                            <a href="ProyectoServlet" class="hover:underline transition">Proyectos</a>
                            <%
                            break;
                        case "empleado":
                            %>
                            <a href="ProyectoServlet" class="hover:underline transition">Mis proyectos</a>
                            <%
                            break;
                        case "usuario":
                            %>
                            <a href="TareaServlet" class="hover:underline transition">Mis tareas</a>
                            <%
                            break;
                        default:
                            break;
                    }
                } %>
            </nav>

            <!-- Desktop Auth Button -->
            <div class="justify-self-end">
                <% if (logueado) { %>
                    <a href="LogoutServlet"
                       class="border border-white text-white bg-blue-600 hover:bg-blue-500 px-4 py-2 rounded-md transition-all">
                        Cerrar sesión
                    </a>
                <% } else { %>
                    <a href="login.jsp"
                       class="border border-white text-white bg-blue-600 hover:bg-blue-500 px-4 py-2 rounded-md transition-all">
                        Iniciar sesión
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Mobile Header -->
        <div class="md:hidden">
            <div class="flex items-center justify-between py-3">
                <h1 class="text-lg font-bold">Planera</h1>
                
                <!-- Mobile Menu Button -->
                <button id="mobileMenuBtn" class="p-2 rounded-md hover:bg-blue-500 transition" onclick="toggleMobileMenu()">
                    <svg id="menuIcon" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                    </svg>
                    <svg id="closeIcon" class="w-6 h-6 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <!-- Mobile Menu -->
            <div id="mobileMenu" class="hidden pb-4">
                <nav class="flex flex-col space-y-3">
                    <% 
                    if(logueado){
                        switch(usuario.getRol().toLowerCase()){
                            case "administrador":
                                %>
                                <a href="UsuariosServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Usuarios</a>
                                <a href="ProyectoServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Proyectos</a>
                                <a href="ClienteServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Clientes</a>
                                <a href="CategoriaTareaServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Categorías</a>
                                <% break;
                            case "supervisor":
                                %>
                                <a href="ProyectoServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Proyectos</a>
                                <a href="TareaServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Mis tareas</a>
                                <%
                                break;
                            case "empleado":
                                %>
                                <a href="TareaServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Mis tareas</a>
                                <%
                                break;
                            case "usuario":
                                %>
                                <a href="TareaServlet" class="py-2 px-3 hover:bg-blue-500 rounded transition">Mis tareas</a>
                                <%
                                break;
                            default:
                                break;
                        }
                    } %>
                    
                    <!-- Mobile Auth Button -->
                    <div class="pt-2 border-t border-blue-500">
                        <% if (logueado) { %>
                            <a href="LogoutServlet"
                               class="block text-center border border-white text-white bg-blue-700 hover:bg-blue-500 px-4 py-2 rounded-md transition-all">
                                Cerrar sesión
                            </a>
                        <% } else { %>
                            <a href="login.jsp"
                               class="block text-center border border-white text-white bg-blue-700 hover:bg-blue-500 px-4 py-2 rounded-md transition-all">
                                Iniciar sesión
                            </a>
                        <% } %>
                    </div>
                </nav>
            </div>
        </div>
    </div>
</header>

<script>
function toggleMobileMenu() {
    const menu = document.getElementById('mobileMenu');
    const menuIcon = document.getElementById('menuIcon');
    const closeIcon = document.getElementById('closeIcon');
    
    menu.classList.toggle('hidden');
    menuIcon.classList.toggle('hidden');
    closeIcon.classList.toggle('hidden');
}

// Cerrar el menú móvil cuando se hace clic en un enlace
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenu = document.getElementById('mobileMenu');
    if (mobileMenu) {
        const links = mobileMenu.querySelectorAll('a');
        links.forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth < 768) {
                    toggleMobileMenu();
                }
            });
        });
    }
});
</script>