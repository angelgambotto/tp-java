<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="usuarios.Usuario" %>
<%@ page import="categoriaTarea.CategoriaTarea" %>
<%@ page import="tareas.Tarea" %>

<%
    Tarea tarea = (Tarea) request.getAttribute("tarea");
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    List<Usuario> usuariosAsignados = (List<Usuario>) request.getAttribute("usuariosAsignados");
    List<CategoriaTarea> categorias = (List<CategoriaTarea>) request.getAttribute("categorias");
    Integer idEtapa = (Integer) request.getAttribute("idEtapa");
%>

<div id="modalFormTarea"
     class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 hidden">

    <div class="bg-white rounded-lg shadow-lg  w-full max-w-2xl max-h-[90vh] flex flex-col p-6	">

        <h2 class="text-2xl font-bold mb-4 text-gray-800">
            <%= tarea == null ? "Nueva Tarea" : "Editar Tarea" %>
        </h2>

       <form action="TareaServlet" method="post" class="overflow-y-auto flex-1 space-y-4 pr-2">

            <input type="hidden" name="action" value="<%= tarea == null ? "insert" : "update" %>">
            <input type="hidden" name="idEtapa"
                   value="<%= idEtapa != null ? idEtapa : (tarea != null ? tarea.getIdEtapa() : "") %>">

            <% if (tarea != null) { %>
                <input type="hidden" name="idTarea" value="<%= tarea.getId() %>">
            <% } %>

            <div class="mb-4">
                <label class="block text-gray-700 mb-1">Nombre</label>
                <input type="text" name="nombre"
                       class="w-full border rounded-lg px-4 py-2"
                       value="<%= tarea != null ? tarea.getNombre() : "" %>" required>
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 mb-1">Descripción</label>
                <textarea name="descripcion" rows="3"
                          class="w-full border rounded-lg px-4 py-2"><%= tarea != null ? tarea.getDescripcion() : "" %></textarea>
            </div>
<%Boolean f=(Boolean)request.getAttribute("EtapaFinalizada"); 
boolean etapaFinalizada = (f != null && f);
System.out.println("etapaFinalizada:"+ etapaFinalizada);

%>
            <div class="mb-4">
                <label class="block text-gray-700 mb-1">Estado</label>
                <select name="estado" class="w-full border rounded-lg px-4 py-2" <%= etapaFinalizada ? "disabled" : "" %>>
                    <% if (tarea!=null) { %>
        <option value="Done" <%= "Done".equals(request.getAttribute("estado")) ? "selected" : "" %>>Done</option>
    <% } %>
                    <option value="To Do" <%= tarea != null && "To Do".equals(tarea.getEstado()) ? "selected" : "" %>>To Do</option>
                    <option value="In Progress" <%= tarea != null && "In Progress".equals(tarea.getEstado()) ? "selected" : "" %>>In Progress</option>
                    
                </select>
                <% if (etapaFinalizada) { %>
    <input type="hidden" name="estado" value="<%= tarea.getEstado() %>">
<% } %>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <div>
                    <label class="block text-gray-700 mb-1">Fecha Inicio</label>
                    <input type="date" name="fechaInicio" class="w-full border rounded-lg px-4 py-2"
                           value="<%= tarea != null && tarea.getFechaInicio() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(tarea.getFechaInicio()) : "" %>">
                </div>

                <div>
                    <label class="block text-gray-700 mb-1">Fecha Fin</label>
                    <input type="date" name="fechaFin" class="w-full border rounded-lg px-4 py-2"
                           value="<%= tarea != null && tarea.getFechaFin() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(tarea.getFechaFin()) : "" %>">
                </div>
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 mb-1">Categoría</label>
                <select name="idCategoria" class="w-full border rounded-lg px-4 py-2">
                    <% if(categorias != null){
                        for (CategoriaTarea c : categorias) { %>
                        <option value="<%= c.getId() %>"
                                <%= (tarea != null && tarea.getIdCategoria() == c.getId()) ? "selected" : "" %>>
                            <%= c.getNombre() %>
                        </option>
                    <% }} %>
                </select>
            </div>

            <div class="mb-6">
    <label class="block text-gray-700 mb-1">Asignar usuarios</label>

    <div class="border rounded-lg px-4 py-3 max-h-40 overflow-y-auto">

        <% if (usuarios != null) {
            for (Usuario u : usuarios) {
                boolean seleccionado = usuariosAsignados != null &&
                        usuariosAsignados.stream().anyMatch(us -> us.getId() == u.getId());
        %>

            <label class="flex items-center space-x-2 mb-2 cursor-pointer">
                <input type="checkbox"
                       name="usuarios"
                       value="<%= u.getId() %>"
                       <%= seleccionado ? "checked" : "" %>
                       class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                <span><%= u.getNombre() %> <%= u.getApellido() %></span>
            </label>

        <% } } %>
    </div>
</div>

            <div class="flex justify-end space-x-4">
                <button type="button"
                        onclick="cerrarModalYVolver(<%= idEtapa %>)"
                        class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-medium py-2 px-4 rounded-lg">
                    Cancelar
                </button>
                <button type="submit"
                        class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg">
                    Guardar
                </button>
            </div>

        </form>
    </div>
</div>
 <script>
function cerrarModalYVolver(idEtapa) {
    document.getElementById("modalFormTarea").classList.add("hidden");
    window.location.href = `TareaServlet?action=list&idEtapa=${idEtapa}`;
}
</script>