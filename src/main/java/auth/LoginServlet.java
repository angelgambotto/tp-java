package auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import usuarios.Usuario;
import usuarios.UsuariosDAO;
import exceptions.DAOException;

import java.io.IOException;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UsuariosDAO userDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    @Override
    public void init() {
    	userDAO=new UsuariosDAO();
  
    }
    private Usuario buscarParaLoginSeguro(HttpServletRequest request,String usuario,String clave) {
		Usuario user=null;
		try {user=userDAO.buscarParaLogin(usuario, clave);
		return user;
		
		}
		catch(DAOException e) {
			request.setAttribute("error", "Error al cargar el usuario: "+e.getMessage());
			return user;
		}
	}
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String usuario=request.getParameter("usuario");
		String password=request.getParameter("clave");
		
		Usuario user=buscarParaLoginSeguro(request,usuario, password);
		if(user!=null) {
			HttpSession session=request.getSession();
			session.setAttribute("usuario", user);
			response.sendRedirect(request.getContextPath() + "/UsuariosServlet");
			
		}
		else {
			request.setAttribute("error", "Usuario o contraseña incorrectos");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}

}
