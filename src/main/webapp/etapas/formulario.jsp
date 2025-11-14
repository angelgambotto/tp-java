<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "proyectos.Proyecto" %>
<%@page import = "usuarios.Usuario" %>
<%@page import = "clientes.Cliente" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<script src="https://cdn.tailwindcss.com"></script>
<!-- DEBUG: Solo si el formulario existe -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('#insert-update form');
        if (form) {
            form.addEventListener('submit', function(e) {
                console.log('=== FORMULARIO ENVIADO ===');
                const formData = new FormData(this);
                for (let [key, value] of formData.entries()) {
                    console.log(key + ': ' + value);
                }
            });
        } else {
            console.log('Formulario no encontrado (modal cerrado)');
        }
    });
</script>

<% 
	//Date fechaInicio = (Date) request.getAttribute("fechaInicio");
    //LinkedList<Usuario> supervisores = (LinkedList<Usuario>) request.getAttribute("supervisores");
    //List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");  // <-- CAMBIO AQUÍ: List en vez de LinkedList
%>
<div id="insert-update" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %>">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">Agregar / Editar Etapa</h2>
        <form action="EtapaServlet" method="post" class="space-y-4">
            <input type="hidden" name="id" value="${id}" />
            <input type="hidden" name="idProyecto" value="${idProyecto}" />

            <div>
                <label class="block font-medium">Nombre:</label>
                <input type="text" name="nombre" 
               value="<%= request.getAttribute("nombre") != null ? request.getAttribute("nombre") : "" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Descripción:</label>
                <input type="text" name="descripcion" 
                value=<%= request.getAttribute("descripcion") %>
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Estado:</label>
                <select name="estado" 
               
                required class="w-full border border-gray-300 rounded px-3 py-2" <%= proyectoFinalizado ? "disabled" : "" %> 
                >
                    <option value="To Do" <%= "To Do".equals(request.getAttribute("estado")) ? "selected" : "" %>>To Do</option>
                    <option value="In Progress" <%= "In Progress".equals(request.getAttribute("estado")) ? "selected" : "" %>>In Progress</option>
<% if (!bloqueado) { %>
    <option value="Done" <%= "Done".equals(request.getAttribute("estado")) ? "selected" : "" %>>Done</option>
<% } %>
                    <option value="Canceled" <%= "Canceled".equals(request.getAttribute("estado")) ? "selected" : "" %>>Canceled</option>
                </select>
                 <% if (proyectoFinalizado) { %>
    <input type="hidden" name="estado" value="<%= request.getAttribute("estado") %>">
<% } %>
                
            </div>

            <div>
                <label class="block font-medium">Fecha Inicio:</label>
                <input type="date" name="fechaInicio" 
                value="<%= request.getAttribute("fechaInicio") != null ? request.getAttribute("fechaInicio") : "" %>"
                       readonly
                       class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100" />
            </div>
            <div>
                <label class="block font-medium">Fecha Tentativa fin:</label>
                <input type="date" name="fechaTentativa" 
                value="<%= request.getAttribute("fechaTentativa") != null ? request.getAttribute("fechaTentativa") : "" %>"
                       class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100" />
            </div>
            <div>
                <label class="block font-medium">Fecha Fin:</label>
                <input type="date" name="fechaFin" 
                       value="<%= request.getAttribute("fechaFin") != null ? request.getAttribute("fechaFin") : "" %>"
                       class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100" />
            </div>
            <div class="flex justify-end space-x-4">
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    Guardar
                </button>
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal('insert-update')">
                    Cancelar
                </button>
            </div>
        </form>
    </div>
</div>