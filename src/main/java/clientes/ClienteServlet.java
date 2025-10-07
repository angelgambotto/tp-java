package clientes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
/**
 * Servlet implementation class ServletCliente
 */
@WebServlet("/ClienteServlet")
public class ClienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ClienteDAO dao;

    @Override
    public void init() {
        dao = new ClienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        String vista = "clientes/listado.jsp";
        switch (action) {
            case "new":
                request.setAttribute("cliente", null);
                request.setAttribute("abrirModal", true);
                vista = "clientes/formulario.jsp";
                break;
            case "edit":
                String cuitCuil = request.getParameter("cuitCuil");
                Cliente cliEdit = dao.getByCuitCuil(cuitCuil);
                request.setAttribute("cliente", cliEdit);
                request.setAttribute("abrirModal", true);
                vista = "clientes/formulario.jsp";
                break;
            case "delete":
                String deleteCuitCuil = request.getParameter("cuitCuil");
                dao.delete(deleteCuitCuil);
                break;
        }
        
        request.setAttribute("clientes", dao.getAll());
        request.getRequestDispatcher(vista).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cuitCuil = request.getParameter("cuitCuil") == null || request.getParameter("cuitCuil").isEmpty()
                 ? null : request.getParameter("cuitCuil");
        String razonSocial = request.getParameter("razonSocial");
        String mail = request.getParameter("mail");
        
        Cliente cli = new Cliente();
        cli.setCuitCuil(cuitCuil);
        cli.setRazonSocial(razonSocial);
        cli.setMail(mail);
        
        String cliEdit = request.getParameter("cliente");
        
        if (cliEdit != null) {
            dao.update(cli);
        } else {
            dao.insert(cli);
        }

        response.sendRedirect("ClienteServlet");
    }

}
