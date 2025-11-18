<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "usuarios.Usuario" %>  
    <%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mis tareas</title>
<script src="https://cdn.tailwindcss.com"></script>

<% Integer idTareaObj = (Integer) request.getAttribute("idTarea");
Integer idEmpleadoObj = (Integer) request.getAttribute("idEmpleado");
int idTarea = (idTareaObj != null) ? idTareaObj : 0;
int idEmpleado = (idEmpleadoObj != null) ? idEmpleadoObj : 0;

%>
</head>
<body>

<div id="insert" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">Agregar horas trabajadas</h2>
        <form action="HoraTrabajadaServlet" method="post" class="space-y-4">
            <input type="hidden" name="idTarea" value="<%= idTarea != 0 ? idTarea : 0 %>" />
            <input type="hidden" name="idEmpleado" value="<%= idEmpleado != 0 ? idEmpleado : 0 %>" />
            <input type="hidden" name="action" value="new"/>
			<input type="hidden" name="returnUrl" value="<%= request.getHeader("Referer") %>">
             <div>
                <label class="block font-medium">Fecha:</label>
                <input type="datetime-local" 
				       name="fecha" 
				       required
				       class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100" />
		     </div>
            
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Horas trabajadas:</label>
                <input type="number" 
                       name="cantidad" 
                       min="1" 
                       step="1"
                       required
                       class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="Ej: 2">
            </div>
            
            

            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal('insert')">
                    Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                     Guardar
                </button>
            </div>
        </form>
    </div>
   </div>

</body>
</html>


