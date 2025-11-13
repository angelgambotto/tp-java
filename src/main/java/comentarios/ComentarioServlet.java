package comentarios;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tareas.TareaDAO;
import tareas.Tarea;
import comentarios.Comentario;
import comentarios.ComentarioDAO;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import usuarios.Usuario;
import exceptions.DAOException;

/**
 * Servlet implementation class ComentarioServlet
 */
@WebServlet("/ComentarioServlet")
public class ComentarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ComentarioDAO cdao;
	private TareaDAO tdao;
	
	
	public void init() {
		tdao = new TareaDAO();
		cdao = new ComentarioDAO();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		
		if (usuario == null) {
			response.sendRedirect("LoginServlet");
		}
		
		String rol = usuario != null ? usuario.getRol().toLowerCase() : "";
		int idTarea = request.getParameter("idTarea") == null || request.getParameter("idTarea").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("idTarea"));
		String action = request.getParameter("action");
		
		switch(action) {
		
		case "new":
			try {
	            Tarea tarea = tdao.getOne(idTarea);
	            List<Usuario> asignados = tdao.getUsuariosAsignados(tarea.getId());
	            String texto = request.getParameter("texto");
	            
	            // Checkeo que sea parte
	            boolean pertenece = false;
	            for (Usuario u : asignados) {
	                if (u.getId() == usuario.getId()) {
	                    pertenece = true;
	                    break;
	                }
	            }
	            if (!pertenece && !"administrador".equalsIgnoreCase(rol)) {
	            	response.sendRedirect("ProyectoServlet");
	            	return;
	            }
	            
	            
	            // Inserto el comentario
	            Date hoy = new Date();
	            Comentario comentario = new Comentario();
	            comentario.setIdTarea(tarea.getId());
	            comentario.setIdEmpleado(usuario.getId());
	            comentario.setTexto(texto);
	            comentario.setFecha(hoy);
	            cdao.insert(comentario);
	            
	            // FORWARD A LA MISMA PÁGINA
	            response.sendRedirect("TareaServlet?action=detalle&idTarea=" + tarea.getId() + "&idEtapa=" + tarea.getIdEtapa()+ "&tab=comentarios");
	            return;

	        } catch (DAOException e) {
	            request.setAttribute("error", "Comentario invalido");
	            // fallback
	        }
			break;
		
		case "delete":
			try {
				int idComentario = Integer.parseInt(request.getParameter("idComentario"));
				System.out.println("comentario a borrar: "+idComentario);
				Comentario c = cdao.getById(idComentario);
				
				idTarea = c.getIdTarea();
				Tarea tarea = tdao.getOne(idTarea);
				
				
				request.setAttribute(action, tarea);
				if (usuario.getId() != c.getIdEmpleado()) {
					response.sendRedirect("TareaServlet?action=detalle&idTarea=" + tarea.getId() + "&idEtapa=" + tarea.getIdEtapa() + "&tab=comentarios" +"&error=invalid_id");
				}
				
				cdao.delete(c.getId());
				// FORWARD A LA MISMA PÁGINA
	            response.sendRedirect("TareaServlet?action=detalle&idTarea=" + tarea.getId() + "&idEtapa=" + tarea.getIdEtapa() + "&tab=comentarios");
	            return;
				
			} catch (DAOException e) {
	            request.setAttribute("error", "Comentario invalido");
	            // fallback
	        }
		}
	}
}



