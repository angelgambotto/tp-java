<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "categoriaTarea.CategoriaTarea" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listado categoria tarea</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
        function toggleModal() {
            const modal = document.getElementById('modal');
            modal.classList.toggle('hidden');
        }
    </script>
<%CategoriaTarea cat=(CategoriaTarea) request.getAttribute("categoriaTarea"); %>
</head>
<body>

<div id="modal" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4"><%=cat!=null?"Editar categoriaTarea":"Crear categoriaTarea" %></h2>
         <form action="CategoriaTareaServlet" method="post" class="space-y-4">
            <input type="hidden" name="id" value="<%= cat != null ? cat.getId() : 0 %>" />

            <div>
                <label class="block font-medium">Nombre:</label>
                <input type="text" name="nombre" value="<%= cat != null ? cat.getNombre() : "" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Descripción:</label>
                <input type="text" name="descripcion" value="<%= cat != null ? cat.getDescripcion() : "" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal()">
                    Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    <%= request.getAttribute("usuario") != null ? "Actualizar" : "Guardar" %>
                </button>
                
            </div>
        </form>
      </div>
    </div>
</body>
</html>


