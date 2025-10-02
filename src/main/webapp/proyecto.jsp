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
    <%LinkedList<Usuario> supervisores=(LinkedList<Usuario>)request.getAttribute("supervisores"); %>
</head>
<body class="bg-gray-100 p-8">
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
    <button class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700" onClick="toggleModal()">
      Nuevo
    </button>
  </div>

<div class="flex mt-8 bg-white shadow-lg rounded-lg p-6"> 
    <table class="w-full border-collapse border border-gray-300">
    	<thead>
        <tr>
            <th class="border border-gray-300 px-4 py-2">ID</th>
            <th class="border border-gray-300 px-4 py-2">Nombre</th>
            <th class="border border-gray-300 px-4 py-2">Descripción</th>
            <th class="border border-gray-300 px-4 py-2">Cuit/Cuil</th>
            <th class="border border-gray-300 px-4 py-2">Fecha Creación</th>
            <th class="border border-gray-300 px-4 py-2">Supervisor</th>
            <th class="border border-gray-300 px-4 py-2  w-[180px]">Acciones</th>
        </tr>
        </thead>
        <tbody>        
        <%
            List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
            if (proyectos != null) {
                for (Proyecto pro : proyectos) {
        %>
        <tr class="hover:bg-gray-100">
            <td class="border border-gray-300 px-4 py-2"><%= pro.getId() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= pro.getNombre() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= pro.getDescripcion() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= pro.getCuitCuil() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= pro.getFechaCreacion() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= pro.getSupervisor().getNombreCompleto() %></td>
            <td class="border border-gray-300 px-4 py-2">
             <a href="ProyectoServlet?action=edit&id=<%= pro.getId() %>" 
                   class="bg-blue-600 text-white px-2 py-1 rounded text-sm hover:bg-blue-700 w-[60px] inline-block text-center">Editar</a>
                <a href="ProyectoServlet?action=delete&id=<%= pro.getId() %>"
                   class="bg-blue-600 text-white px-2 py-1 rounded text-sm hover:bg-blue-700 w-[70px] inline-block text-center">Eliminar</a>
            </td>
        </tr>
        <%      }
            }
        %>
        </tbody>
    </table>
</div>

<!-- Modal -->
<div id="modal" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">Agregar / Editar Proyecto</h2>
        <form action="ProyectoServlet" method="post" class="space-y-4">
            <input type="hidden" name="id" value="${id}" />

            <div>
                <label class="block font-medium">Nombre:</label>
                <input type="text" name="nombre" value="${nombre}"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Descripción:</label>
                <input type="text" name="descripcion" value="${descripcion}"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Cuit/Cuil:</label>
                <input type="text" name="cuitCuil" value="${cuitCuil}"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Fecha Creación:</label>
                <input type="date" name="fechaCreacion" value="${fechaCreacion}"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>
            
            <div>
			    <label class="block font-medium">Supervisor</label>
			    <select name="supervisorId" required class="w-full border border-gray-300 rounded px-3 py-2">
			        <% 
			            if (supervisores != null) {
			                for (Usuario sup : supervisores) {
			                    String selected = "";
			                    if (request.getAttribute("supervisorId") != null && sup.getId() == (Integer) request.getAttribute("supervisorId")) {
			                        selected = "selected";
			                    }
			        %>
			                    <option value="<%= sup.getId() %>" <%= selected %>><%= sup.getNombreCompleto() %></option>
			        <% 
			                }
			            }
			        %>
			    </select>
			</div>

            <div class="flex justify-end space-x-4">
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    Guardar
                </button>
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal()">
                    Cancelar
                </button>
            </div>
        </form>
    </div>
   </div>

<% if ("edit".equals(request.getParameter("action"))) { %>
    <script>toggleModal();</script>
<% } %>

</body>
</html>