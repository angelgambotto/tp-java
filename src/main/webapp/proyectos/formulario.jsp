<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "proyectos.Proyecto" %>
    <%@page import = "usuarios.Usuario" %>  
    <%@ page import="java.util.LinkedList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listado de proyectos</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
        function toggleModal() {
            const modal = document.getElementById('modal');
            modal.classList.toggle('hidden');
        }
    </script>
<%LinkedList<Usuario> supervisores=(LinkedList<Usuario>)request.getAttribute("supervisores"); %>
</head>
<body>
<%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %>
<div id="modal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %>">
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
</div>
</body>
</html>