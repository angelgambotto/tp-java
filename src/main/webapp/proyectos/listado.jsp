<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="usuarios.Usuario" %>

<html>
<head>
    <title>ABM Proyecto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function toggleModal() {
            const modal = document.getElementById('modal');
            modal.classList.toggle('hidden');
        }
    </script>
    <% LinkedList<Usuario> supervisores = (LinkedList<Usuario>) request.getAttribute("supervisores"); %>
</head>
<body class="bg-gray-100">
<jsp:include page="../header.jsp" />
<div class="p-8">
    <div class="flex items-center justify-between mb-4">
        <!-- Título -->
        <h2 class="text-2xl font-bold text-black">Listado de Proyectos</h2>

        <!-- Buscador con ícono de lupa -->
        <div class="relative flex-1 max-w-md">
            <input type="text" placeholder="Buscar..."
                   class="w-full border border-gray-300 rounded px-3 py-2 pr-10 focus:ring-indigo-500 focus:border-indigo-500" />
            <button class="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m1.85-5.65a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
            </button>
        </div>
        <!-- Botón -->
        <a href="ProyectoServlet?action=new">
            <button class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                Nuevo
            </button>
        </a>
    </div>

    <%
        List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
        LinkedList<Proyecto> todo = new LinkedList<>();
        LinkedList<Proyecto> inProgress = new LinkedList<>();
        LinkedList<Proyecto> done = new LinkedList<>();
        LinkedList<Proyecto> canceled = new LinkedList<>();
        /*if (proyectos != null) {
            for (Proyecto pro : proyectos) {
                String estado = pro.getEstado(); // Asumiendo que existe un método getEstado() en Proyecto que devuelve "To Do", "In Progress", "Done" o "Canceled"
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
        }*/
        if (proyectos != null) {
            for (int i = 0; i < proyectos.size(); i++) {
                Proyecto pro = proyectos.get(i);

                int pos = i % 4; // Para alternar entre los 4 estados si hay más de 4 proyectos
                switch (pos) {
                    case 0:
                        todo.add(pro);
                        break;
                    case 1:
                        inProgress.add(pro);
                        break;
                    case 2:
                        done.add(pro);
                        break;
                    case 3:
                        canceled.add(pro);
                        break;
                }
            }
        }

    %>

    <div class="grid grid-cols-4 gap-6 mt-8">
        <!-- Columna To Do -->
        <div class="bg-white shadow-lg rounded-lg p-6">
            <h3 class="text-xl font-bold mb-4 text-gray-800">To Do</h3>
            <div class="space-y-4 max-h-96 overflow-y-auto">
                <% for (Proyecto pro : todo) { %>
                    <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                        <h4 class="font-semibold text-gray-900"><%= pro.getNombre() %></h4>
                        <p class="text-sm text-gray-600 mt-1"><%= pro.getDescripcion() %></p>
                        <p class="text-xs text-gray-500 mt-2">CUIT/CUIL: <%= pro.getCuitCuil() %></p>
                        <p class="text-xs text-gray-500">Fecha Creación: <%= pro.getFechaCreacion() %></p>
                        <p class="text-xs text-gray-500">Supervisor: <%= pro.getSupervisor().getNombreCompleto() %></p>
                        <div class="mt-3 flex space-x-2">
                            <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>"
                               class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 inline-block text-center">Editar</a>
                            <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                               class="bg-red-600 text-white px-3 py-1 rounded text-sm hover:bg-red-700 inline-block text-center">Eliminar</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Columna In Progress -->
        <div class="bg-white shadow-lg rounded-lg p-6">
            <h3 class="text-xl font-bold mb-4 text-gray-800">In Progress</h3>
            <div class="space-y-4 max-h-96 overflow-y-auto">
                <% for (Proyecto pro : inProgress) { %>
                    <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                        <h4 class="font-semibold text-gray-900"><%= pro.getNombre() %></h4>
                        <p class="text-sm text-gray-600 mt-1"><%= pro.getDescripcion() %></p>
                        <p class="text-xs text-gray-500 mt-2">CUIT/CUIL: <%= pro.getCuitCuil() %></p>
                        <p class="text-xs text-gray-500">Fecha Creación: <%= pro.getFechaCreacion() %></p>
                        <p class="text-xs text-gray-500">Supervisor: <%= pro.getSupervisor().getNombreCompleto() %></p>
                        <div class="mt-3 flex space-x-2">
                            <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>"
                               class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 inline-block text-center">Editar</a>
                            <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                               class="bg-red-600 text-white px-3 py-1 rounded text-sm hover:bg-red-700 inline-block text-center">Eliminar</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Columna Done -->
        <div class="bg-white shadow-lg rounded-lg p-6">
            <h3 class="text-xl font-bold mb-4 text-gray-800">Done</h3>
            <div class="space-y-4 max-h-96 overflow-y-auto">
                <% for (Proyecto pro : done) { %>
                    <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                        <h4 class="font-semibold text-gray-900"><%= pro.getNombre() %></h4>
                        <p class="text-sm text-gray-600 mt-1"><%= pro.getDescripcion() %></p>
                        <p class="text-xs text-gray-500 mt-2">CUIT/CUIL: <%= pro.getCuitCuil() %></p>
                        <p class="text-xs text-gray-500">Fecha Creación: <%= pro.getFechaCreacion() %></p>
                        <p class="text-xs text-gray-500">Supervisor: <%= pro.getSupervisor().getNombreCompleto() %></p>
                        <div class="mt-3 flex space-x-2">
                            <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>"
                               class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 inline-block text-center">Editar</a>
                            <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                               class="bg-red-600 text-white px-3 py-1 rounded text-sm hover:bg-red-700 inline-block text-center">Eliminar</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Columna Canceled -->
        <div class="bg-white shadow-lg rounded-lg p-6">
            <h3 class="text-xl font-bold mb-4 text-gray-800">Canceled</h3>
            <div class="space-y-4 max-h-96 overflow-y-auto">
                <% for (Proyecto pro : canceled) { %>
                    <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                        <h4 class="font-semibold text-gray-900"><%= pro.getNombre() %></h4>
                        <p class="text-sm text-gray-600 mt-1"><%= pro.getDescripcion() %></p>
                        <p class="text-xs text-gray-500 mt-2">CUIT/CUIL: <%= pro.getCuitCuil() %></p>
                        <p class="text-xs text-gray-500">Fecha Creación: <%= pro.getFechaCreacion() %></p>
                        <p class="text-xs text-gray-500">Supervisor: <%= pro.getSupervisor().getNombreCompleto() %></p>
                        <div class="mt-3 flex space-x-2">
                            <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>"
                               class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 inline-block text-center">Editar</a>
                            <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                               class="bg-red-600 text-white px-3 py-1 rounded text-sm hover:bg-red-700 inline-block text-center">Eliminar</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

<jsp:include page="formulario.jsp" />

</body>
</html>