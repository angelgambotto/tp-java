<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "clientes.Cliente" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listado clientes</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
        function toggleModal() {
            const modal = document.getElementById('modalCliente');
            modal.classList.toggle('hidden');
        }
</script>

<%Cliente cli=(Cliente) request.getAttribute("cliente"); %>

</head>
<body>

<div id="modalCliente" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4"><%=cli!=null?"Editar cliente":"Crear cliente" %></h2>
         <form action="ClienteServlet" method="post" class="space-y-4">
            <input type="hidden" name="id" value="<%= cli != null? cli.getId(): 0%>" />
            <div>
                <label class="block font-medium">Cuit/Cuil:</label>
                <input type="text" name="cuitCuil" value="<%= cli != null ? cli.getCuitCuil() : "" %>" 
                	placeholder="xx-xxxxxxxx-x"
                	required
                    class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Razon social:</label>
                <input type="text" name="razonSocial" value="<%= cli != null ? cli.getRazonSocial() : "" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">E-mail:</label>
                <input type="email" name="mail" value="<%= cli != null ? cli.getMail() : "" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal()">
                    Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    <%= cli != null ? "Actualizar" : "Guardar" %>
                </button>
                
            </div>
        </form>
      </div>
    </div>
</body>
</html>
