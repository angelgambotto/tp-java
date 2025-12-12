<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "categoriaTarea.CategoriaTarea" %>  
    
 <html>
<head>
<meta charset="UTF-8">
<title>Listado categoria tarea</title>
<script src="https://cdn.tailwindcss.com"></script>
<% //definimos el objeto cat para poder utilizarlo --> variables para limpiar un poco el codigo y no se rompa
	CategoriaTarea cat=(CategoriaTarea) request.getAttribute("categoriaTarea"); 
	String nombreCat = (cat != null && cat.getNombre() != null) ? cat.getNombre() : "Desconocida";
	String descripcionCat = (cat != null && cat.getDescripcion() != null) ? cat.getDescripcion() : "Sin descripción";
    String idCat = (cat != null) ? String.valueOf(cat.getId()) : "";
%>
</head>
<body>
<!--  (request.getAttribute("abrirModal") != null) ? "" : "hidden" esto se evalua, se expresa como texto, "hiden" es una clase de tailwind que hace que no se vea -->
<div id="delete" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModalEliminar") != null) ? "" : "hidden" %> flex items-center justify-center" >
  <div class="bg-white rounded-lg p-6 w-full max-w-md">
  	<h2 class="text-xl font-bold mb-4">Confirmar Eliminación</h2>
	<p>
	¿Está seguro que desea eliminar la siguiente categoria?
	</p>
	<p>
	<b>Nombre:</b> <%= nombreCat %>
	<br>
	<b>Descripcion:</b> <%= descripcionCat %>
	</p>
	<form action="CategoriaTareaServlet" method="post">
       <input type="hidden" name="action" value="confirmDelete" />
       <input type="hidden" name="id" id="deleteCategoriaId" value="<%= idCat %>" />
        <div class="flex justify-end space-x-4 mt-4">
         <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal('delete')">
             Cancelar
         </button>
         <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-red-700">
             Eliminar
         </button>
     </div>
    </form>    
  </div>
</div>
</body>
</html>