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
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                System.out.println("El id a editar es:"+editId);
                Cliente cliEdit = dao.getOne(editId);
                System.out.println("El id obtenido es:"+cliEdit.getId());               
                request.setAttribute("cliente", cliEdit);
                request.setAttribute("abrirModal", true);
                break;
            case "delete":
            	try {
            		int deleteId = Integer.parseInt(request.getParameter("id"));
            		if (deleteId != 0) {
            			try {
            				Cliente cli = dao.getOne(deleteId);
            				request.setAttribute("cliente", cli);
            				request.setAttribute("abrirModalEliminar", true);
            				
            			} catch(NumberFormatException e) {
            				request.setAttribute("error", "No se encontro al cliente");
            			}
            		}
            	} catch (NumberFormatException e) {
            		request.setAttribute("error", "Hubo un error al intentar eliminarlo, intente de nuevo");
            	}
                //dao.delete(deleteId);
                break;
        }
        
        request.setAttribute("clientes", dao.getAll());
        request.getRequestDispatcher(vista).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("id"));
    	
    	//para delete
    	String action = request.getParameter("action");
    	
    	if("confirmDelete".equals(action)) {
    		try {
    			int deleteId = Integer.parseInt(request.getParameter("id"));
                if (id > 0 && dao.getOne(deleteId) != null) {
                	dao.delete(deleteId);              
                } else {
                    request.setAttribute("error", "No se pudo eliminar el cliente: ID inválido.");
                    request.setAttribute("clientes", dao.getAll());
                    request.getRequestDispatcher("clientes/listado.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de cliente inválido.");
                request.setAttribute("clientes", dao.getAll());
                request.getRequestDispatcher("clientes/listado.jsp").forward(request, response);
                return;
            }
        	
        	response.sendRedirect("ClienteServlet");
        	return;
    		
    	}
    	
    	
    	//para insert o update
    	String cuitCuil = request.getParameter("cuitCuil");
        String razonSocial = request.getParameter("razonSocial");
        String mail = request.getParameter("mail");
        
        Cliente cli = new Cliente(id, cuitCuil, razonSocial, mail);
        
        if (id>0) {
            dao.update(cli);
        } else {
            dao.insert(cli);
        }

        response.sendRedirect("ClienteServlet");
    }

}
