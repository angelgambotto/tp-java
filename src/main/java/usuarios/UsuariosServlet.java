package usuarios;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import categoriaTarea.CategoriaTarea;
import clientes.Cliente;
import exceptions.DAOException;

/**
 * Servlet implementation class UsuariosServlet
 */
@WebServlet("/UsuariosServlet")
public class UsuariosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UsuariosDAO userDAO;
	
	//metodo para cargar los usuarios y no tener problemas con el bloque try catch
		private List<Usuario> cargarUsuariosSeguro(HttpServletRequest request) {
		    try {
		        return userDAO.getAll();
		    } catch (DAOException e) {
		        request.setAttribute("error", "No se pudieron cargar las categorías: " + e.getMessage());
		        return new ArrayList<>();
		    }
		}
	//metodo para cargar un usuario y no tener problemas con el bloque try catch
	private Usuario cargarUsuSeguro(HttpServletRequest request, int id) {
	    try {
	        return userDAO.getOne(id);
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar las categorías: " + e.getMessage());
	        return new Usuario();
	    }
	}
       
    @Override
    public void init() {
    	userDAO=new UsuariosDAO();
  
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	String action=request.getParameter("action");
	int idUsuario;
	if(action!=null) {
	switch(action) {
	case "new":
		 request.setAttribute("usuario", null);
		 request.setAttribute("abrirModal", true);
		
		
		break;
	case "edit":
		idUsuario=Integer.parseInt(request.getParameter("id"));
		Usuario u= cargarUsuSeguro(request, idUsuario);
		if(u!=null) {
		request.setAttribute("usuario", u);
		request.setAttribute("abrirModal", true);

		}
		break;
	case "delete":
		try {			
			idUsuario=Integer.parseInt(request.getParameter("id"));
			Usuario usu = cargarUsuSeguro(request, idUsuario);
			request.setAttribute("usuario", usu);
			request.setAttribute("abrirModalEliminar", true);
		} catch (NumberFormatException e) {
			request.setAttribute("error", "ID de usuario inválido.");
            request.setAttribute("usuarios", cargarUsuariosSeguro(request));
            request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
            return;
		}
		break;
	}
	}	
	request.setAttribute("usuarios", cargarUsuariosSeguro(request));
	request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String idReq=request.getParameter("id");
		int id=(idReq==null || idReq.isEmpty())?0:Integer.parseInt(idReq);
		String action = (request.getParameter("action")) != null ? request.getParameter("action") : "Desconocido";
		
		try {
			if (action.equals("confirmDelete")) {
				if(id> 0 && cargarUsuSeguro(request, id) != null) {
					userDAO.delete(id);
				} else {
					request.setAttribute("error", "ID de usuario inválido");
					request.setAttribute("usuarios", cargarUsuariosSeguro(request));
					request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
				}
				response.sendRedirect("UsuariosServlet");
				return;
			}
			
			String nombreUsuario=request.getParameter("nombre");
			String apellidoUsuario=request.getParameter("apellido");
			String claveUsuario=request.getParameter("clave");
			String mailUsuario=request.getParameter("mail");
			String rolUsuario=request.getParameter("rol");
			String supervisorUsuario=request.getParameter("usuario");
			if(id!=0) {
				Usuario userPrevio=userDAO.getOne(id);
				if(claveUsuario==null||claveUsuario.isEmpty()) {
					claveUsuario=userPrevio.getClave();
				}
			}
			
			Usuario user=new Usuario(id,nombreUsuario,apellidoUsuario,mailUsuario,claveUsuario,supervisorUsuario,rolUsuario);
			if(id==0) {
				userDAO.add(user);
			} else {
				userDAO.update(user);
			}
			
			response.sendRedirect("UsuariosServlet");
			
		} catch(DAOException e) {
			request.setAttribute("error", e.getMessage());
			request.setAttribute("usuarios", cargarUsuariosSeguro(request));
			request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
			
		} catch (NumberFormatException e) {
			request.setAttribute("error", "No se pudo eliminar el usuario");
			request.setAttribute("usuarios", cargarUsuariosSeguro(request));
			request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
			return;
		}
		
		
	} //cierra doPost
} //cierra servlet

