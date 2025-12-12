package categoriaTarea;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import usuarios.Usuario;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import exceptions.DAOException;

/**
 * Servlet implementation class ServletCategoriaTarea
 */
@WebServlet("/CategoriaTareaServlet")
public class CategoriaTareaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CategoriaTareaDAO dao;
	
	//metodo para cargar las tareas y no tener problemas con el bloque try catch
	private List<CategoriaTarea> cargarCategoriasSeguro(HttpServletRequest request) {
	    try {
	        return dao.getAll();
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar las categorías: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}

    @Override
    public void init() {
        dao = new CategoriaTareaDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String action = request.getParameter("action");
        int idCategoria;
        if (action == null) action = "list";

        switch (action) {
	        case "new":
	   		 request.setAttribute("categoriaTarea", null);
	   		 request.setAttribute("abrirModal", true);
	   		break;
	   		
	        case "edit":
	        	try {
	        		
	        		idCategoria=Integer.parseInt(request.getParameter("id"));
	        		CategoriaTarea c=dao.getById(idCategoria);
	        		if(c!=null) {
	        			request.setAttribute("categoriaTarea", c);
	        			request.setAttribute("abrirModal", true);	        			
	        		} else {
                        request.setAttribute("error", "No se encontró la categoría con ID: " + idCategoria);
	        		}
	        	} catch (DAOException e) {
                    request.setAttribute("error", e);
                }
        	break;
	        	
	    	case "delete":
	    		
	    	try{
	    		idCategoria=Integer.parseInt(request.getParameter("id"));
	    		CategoriaTarea cat = dao.getById(idCategoria);
	    		if (cat != null) {
	    			request.setAttribute("categoriaTarea", cat);
	    			request.setAttribute("abrirModalEliminar", true);
	    		}else {
                    request.setAttribute("error", "No se encontró la categoría con ID: " + idCategoria);
        		}
	    		
	    	} catch (DAOException e) {
                request.setAttribute("error", e);
            }
	    		break;
        }

        request.setAttribute("categorias", cargarCategoriasSeguro(request));
        request.getRequestDispatcher("categorias/listado.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Trae el id de la request
    	Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
	    if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
	        response.sendRedirect("login.jsp");
	        return; 
	    }
    	int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                 ? 0 : Integer.parseInt(request.getParameter("id"));
    	
    	// trae el nombre y descripcion por si hay que hacer insert/update
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        
        //trae la accion para eliminar
        String action = request.getParameter("action");

        
        //bloque try general
        try {
    	   
        	if ("confirmDelete".equals(action)) {
        	    id = Integer.parseInt(request.getParameter("id"));
        	    try {
        	        dao.delete(id);
        	        request.getSession().setAttribute("mensajeExito", "Categoría eliminada con éxito");
        	    } catch (DAOException e) {

        	        request.getSession().setAttribute("mensajeError", e.getMessage());
        	    }
        	    response.sendRedirect("CategoriaTareaServlet");
        	    return;
        	}
    
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
    	   
       } catch (DAOException e) {
           request.setAttribute("error", e.getMessage());
           request.setAttribute("categorias", cargarCategoriasSeguro(request));
           request.getRequestDispatcher("categorias/listado.jsp").forward(request, response);
            
       } catch (NumberFormatException e) {
	        request.setAttribute("error", "ID de categoría inválido.");
	        request.setAttribute("categorias", cargarCategoriasSeguro(request));
	        request.getRequestDispatcher("categorias/listado.jsp").forward(request, response);
	        return;
       }
    }// cierra dopost	
 } //cierra servlet 

    
    
