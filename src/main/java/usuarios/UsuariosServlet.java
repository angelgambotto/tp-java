package usuarios;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
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
		LinkedList<Usuario> supervisores=new LinkedList<>();
		 request.setAttribute("user", null);
		 request.setAttribute("abrirModal", true);
		 try{
			  supervisores=userDAO.getPorRol("Supervisor");
		 }
		 catch(DAOException e) {
			 request.setAttribute("error", "No se pudieron cargar los supervisores: " + e.getMessage());
		 }
		 request.setAttribute("supervisores", supervisores);
		
		break;
	case "edit":
		idUsuario=Integer.parseInt(request.getParameter("id"));
		Usuario u= cargarUsuSeguro(request, idUsuario);
		if(u!=null) {
		request.setAttribute("user", u);
		request.setAttribute("abrirModal", true);
		List<Usuario> supervisoresEdit = new ArrayList<>();
        for (Usuario s : cargarUsuariosSeguro(request)) {
            if ("Supervisor".equalsIgnoreCase(s.getRol())) {
                supervisoresEdit.add(s);
            }
        }
        request.setAttribute("supervisores", supervisoresEdit);
		}
		break;
	case "delete":
		try {			
			idUsuario=Integer.parseInt(request.getParameter("id"));
			Usuario usu = cargarUsuSeguro(request, idUsuario);
			request.setAttribute("user", usu);
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
	List<Usuario> usuarios = cargarUsuariosSeguro(request);

	
	for (Usuario u : usuarios) {
	    if (u.getSupervisor() != null) { 
	        Usuario supervisor = cargarUsuSeguro(request, u.getSupervisor());
	        if (supervisor != null && supervisor.getNombre() != null) {
	            u.setNombreSupervisor(supervisor.getApellido() + ", " + supervisor.getNombre());
	        } else {
	            u.setNombreSupervisor("Sin supervisor");
	        }
	    } else {
	        u.setNombreSupervisor("Sin supervisor");
	    }
	}
	request.setAttribute("usuarios", usuarios);
	request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		

		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		boolean esAdmin = (usuario != null && "Administrador".equalsIgnoreCase(usuario.getRol()));

		
		
		String idReq=request.getParameter("id");
		int id=(idReq==null || idReq.isEmpty())?0:Integer.parseInt(idReq);
		String action = (request.getParameter("action")) != null ? request.getParameter("action") : "Desconocido";
		if (!esAdmin && !"signup".equalsIgnoreCase(action)) {
		    response.sendRedirect("login.jsp");
		    return;
		}
		try {
			
			if("signup".equalsIgnoreCase(action)){
				String nombre=request.getParameter("nombre");
				String apellido=request.getParameter("apellido");
				String user=request.getParameter("usuario");
				String mail=request.getParameter("mail");
				String clave=request.getParameter("clave");
				String rol="Usuario";
				Integer supervisor=null;
				Usuario u=new Usuario(0,nombre,apellido,mail,clave,user,rol,supervisor);
				userDAO.add(u);
			}
			if(esAdmin) {
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
				String usuarioUsuario=request.getParameter("usuario");
				String s = request.getParameter("supervisor");
				Integer supervisor = null; 
	
				if (s != null && !s.isEmpty()) {
				    supervisor = Integer.parseInt(s);
				}
	
				if(id!=0) {
					Usuario userPrevio=userDAO.getOne(id);
					if(claveUsuario==null||claveUsuario.isEmpty()) {
						claveUsuario=userPrevio.getClave();
					}
			}
			
			Usuario user=new Usuario(id,nombreUsuario,apellidoUsuario,mailUsuario,claveUsuario,usuarioUsuario,rolUsuario,supervisor);
			if(id==0) {
				userDAO.add(user);
			} else {
				userDAO.update(user);
			}
			}
			response.sendRedirect("UsuariosServlet");
			
		} catch(DAOException e) {
			request.setAttribute("error", e.getMessage());
			request.setAttribute("usuarios", cargarUsuariosSeguro(request));
			request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
			
		} catch (NumberFormatException e) {
			request.setAttribute("error", "Error al procesar datos numéricos (posible valor nulo o inválido). "+e.getMessage());
			request.setAttribute("usuarios", cargarUsuariosSeguro(request));
			request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
			return;
		}
		
		
	} //cierra doPost
} //cierra servlet

