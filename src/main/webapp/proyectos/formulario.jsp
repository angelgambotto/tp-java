<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "proyectos.Proyecto" %>
<%@page import = "usuarios.Usuario" %>
<%@page import = "clientes.Cliente" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<script src="https://cdn.tailwindcss.com"></script>
<script>        function toggleModalPro() {
    const modal = document.getElementById('modal');
    modal.classList.toggle('hidden');
}</script>

<% 
    LinkedList<Usuario> supervisores = (LinkedList<Usuario>) request.getAttribute("supervisores");
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes"); // <-- CAMBIO AQUÍ: List en vez de LinkedList
%>
<div id="modal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center <%= (request.getAttribute("abrirModalPro") != null) ? "" : "hidden" %>">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4">${id != null ? "Editar proyecto" : "Crear proyecto"} </h2>
        <form action="ProyectoServlet" method="post" class="space-y-4">
            <input type="hidden" name="id" value="${id}" />
			<input type="hidden" name="origin" value="${origin}" />
			
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
                <label class="block font-medium">Cliente:</label>
                <select name="clienteId" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <%
                        if (clientes != null) {
                            for (Cliente cli : clientes) {  // <-- Funciona con List sin problemas
                                String selected = "";
                                if (request.getAttribute("cliente") != null) {
                                    Cliente selectedCliente = (Cliente) request.getAttribute("cliente");
                                    if (cli.getId() == selectedCliente.getId()) {
                                        selected = "selected";
                                    }
                                }
                    %>
                                <option value="<%= cli.getId() %>" <%= selected %>><%= cli.getRazonSocial() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div> <% Boolean tp = (Boolean) request.getAttribute("tieneEtapasPendientes"); 
            boolean bloqueado = (tp != null && tp);%>
                <label class="block font-medium">Estado:</label>
                <select name="estado" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="To Do" <%= "To Do".equals(request.getAttribute("estado")) ? "selected" : "" %>>To Do</option>
                    <option value="In Progress" <%= "In Progress".equals(request.getAttribute("estado")) ? "selected" : "" %>>In Progress</option>
                    <% if (!bloqueado) { %>
    <option value="Done" <%= "Done".equals(request.getAttribute("estado")) ? "selected" : "" %>>Done</option>
<% } %>
                    <option value="Canceled" <%= "Canceled".equals(request.getAttribute("estado")) ? "selected" : "" %>>Canceled</option>
                </select>
            </div>

            <div>
                <label class="block font-medium">Fecha Creación:</label>
                <input type="date" name="fechaCreacion" value="${fechaCreacion}"
                       readonly
                       class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100" />
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
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModalPro()">
                    Cancelar
                </button>
            </div>
        </form>
    </div>
</div>