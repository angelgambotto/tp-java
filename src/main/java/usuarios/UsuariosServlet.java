package usuarios;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class UsuariosServlet
 */
@WebServlet("/UsuariosServlet")
public class UsuariosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UsuariosDAO userDAO;
       
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
	case "edit":
		idUsuario=Integer.parseInt(request.getParameter("id"));
		Usuario u=userDAO.getOne(idUsuario);
		if(u!=null) {
		request.setAttribute("usuario", u);
		request.getRequestDispatcher("editarUsuario.jsp").forward(request,	 response);
		return;
		}
		break;
	case "delete":
		idUsuario=Integer.parseInt(request.getParameter("id"));
		userDAO.delete(idUsuario);
		break;
	}
	}	
	request.setAttribute("usuarios", userDAO.getAll());
	request.getRequestDispatcher("usuario.jsp").forward(request, response);
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String idReq=request.getParameter("id");
		int id=(idReq==null)?0:Integer.parseInt(idReq);
		String nombreUsuario=request.getParameter("nombre");
		String apellidoUsuario=request.getParameter("apellido");
		String claveUsuario=request.getParameter("clave");
		String mailUsuario=request.getParameter("mail");
		String rolUsuario=request.getParameter("rol");
		String supervisorUsuario=request.getParameter("usuario");
		Usuario user=new Usuario(id,nombreUsuario,apellidoUsuario,mailUsuario,claveUsuario,supervisorUsuario,rolUsuario);
		if(id==0) {
		
		userDAO.add(user);}
		else {
			userDAO.update(user);
		}
		
		response.sendRedirect("UsuariosServlet");
	}

}
