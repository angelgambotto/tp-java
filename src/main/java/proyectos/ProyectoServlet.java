package proyectos;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import usuarios.Usuario;
import usuarios.UsuariosDAO;

/**
 * Servlet implementation class ProyectoServlet
 */
@WebServlet("/ProyectoServlet")
public class ProyectoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProyectoDAO dao;
    private UsuariosDAO usuarioDao;

    @Override
    public void init() {
        dao = new ProyectoDAO();
        usuarioDao = new UsuariosDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) action = "list";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        switch (action) {
        	case "new":
                String currentDate = sdf.format(new Date());
                request.setAttribute("fechaCreacion", currentDate);
       		 	request.setAttribute("abrirModal", true);
        		break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Proyecto proEdit = dao.getById(editId);
                request.setAttribute("id", proEdit.getId());
                request.setAttribute("nombre", proEdit.getNombre());
                request.setAttribute("descripcion", proEdit.getDescripcion());
                request.setAttribute("cuitCuil", proEdit.getCuitCuil());
                request.setAttribute("fechaCreacion", sdf.format(proEdit.getFechaCreacion()));
                request.setAttribute("supervisorId", proEdit.getSupervisor().getId());
                request.setAttribute("abrirModal", true);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                dao.delete(deleteId);
                break;
        }

        request.setAttribute("proyectos", dao.getAll());
        request.setAttribute("supervisores", usuarioDao.getAll());
        request.getRequestDispatcher("proyectos/listado.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                 ? 0 : Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String cuitCuil = request.getParameter("cuitCuil");
        String fechaStr = request.getParameter("fechaCreacion");
        int supervisorId = Integer.parseInt(request.getParameter("supervisorId"));

        Date fechaCreacion = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            fechaCreacion = sdf.parse(fechaStr);
        } catch (ParseException e) {
            e.printStackTrace();
            // Handle error, perhaps redirect with error message
            response.sendRedirect("ProyectoServlet?error=invalid_date");
            return;
        }

        Usuario supervisor = new Usuario();
        supervisor.setId(supervisorId);

        Proyecto pro = new Proyecto(id, nombre, descripcion, cuitCuil, fechaCreacion, supervisor, new LinkedList<>());

        if (id > 0) {
            dao.update(pro);
        } else {
            dao.insert(pro);
        }

        response.sendRedirect("ProyectoServlet");
    }

}