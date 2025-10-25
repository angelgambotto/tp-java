package categoriaTarea;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import usuarios.Usuario;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

/**
 * Servlet implementation class ServletCategoriaTarea
 */
@WebServlet("/CategoriaTareaServlet")
public class CategoriaTareaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CategoriaTareaDAO dao;

    @Override
    public void init() {
        dao = new CategoriaTareaDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int idCategoria;
        if (action == null) {
        	try {
                List<CategoriaTarea> categorias = dao.getAll(); // Obtén las categorías
                request.setAttribute("categorias", categorias); // Pasá la lista al JSP
                request.getRequestDispatcher("categoriaTarea.jsp").forward(request, response); // Ajustá la ruta
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al cargar las categorías");
            }
        }
        switch (action) {
	        case "new":
	   		 request.setAttribute("categoriaTarea", null);
	   		 request.setAttribute("abrirModal", true);
	   		break;
	   		
	        case "edit":
	    		idCategoria=Integer.parseInt(request.getParameter("id"));
	    		CategoriaTarea c=dao.getById(idCategoria);
	    		if(c!=null) {
	    		request.setAttribute("categoriaTarea", c);
	    		request.setAttribute("abrirModal", true);

	    		}
	    		break;
	    	case "delete":
	    		idCategoria=Integer.parseInt(request.getParameter("id"));
	    		dao.delete(idCategoria);
	    		break;
        }
        /*Esto es para recargar la lista actualizada*/
       request.setAttribute("categorias", dao.getAll());
        request.getRequestDispatcher("categoriaTarea.jsp").forward(request, response);
    
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                 ? 0 : Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        CategoriaTarea cat = new CategoriaTarea();
        cat.setId(id);
        cat.setNombre(nombre);
        cat.setDescripcion(descripcion);

        if (id > 0) {
            dao.update(cat);
        } else {
            dao.insert(cat);
        }

        response.sendRedirect("CategoriaTareaServlet");
    }

}
